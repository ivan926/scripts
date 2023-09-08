#!/bin/bash

##################################################
#
#   Project: MACManager
#   Author: Ivan Arriola (da-higgs)
#   Supervisor: Jason Williams, End-User Engineering
#   Date: 2023-08-03
#
##################################################

#create lists of triggers
echo "AdobeAcrobatPro
Audacity
BBEdit
BoxDrive
BoxEdit
CitrixWorkspace
Docker
Etcher
FileMaker
Git
GlobalProtectCampus
GlobalProtectDatacenter
GoogleChrome
JetBrainsToolbox
LastPass
MicrosoftOffice365
#MicrosoftTeams
MozillaFirefox
MySQLWorkbench
Nvivo
PostmanAuto
Python
RStatistics
RStudio
RingCentral
RoyalTSX-auto
SplashtopBusiness
Tableau
VLC
Via
VisualStudioCode
Wireshark
Zoom
endnote20
iTerm
javaopenjdk19intel
microsoftedge" > /tmp/trigger.txt

#create list of applications
echo "EndNote 20/EndNote 20
Adobe Acrobat DC/Adobe Acrobat
Visual Studio Code
LastPass
RingCentral
RStudio
Royal TSX
Audacity
Wireshark
Firefox
MySQLWorkbench
FileMaker Pro
NVivo
iTerm
GlobalProtect
GlobalProtect
Citrix Workspace
Tableau Desktop 2023.2
zoom.us
BBEdit
VLC
Microsoft Teams
balenaEtcher
Python 3.11/IDLE
JetBrains Toolbox
VIA
Docker
Postman
R
Google Chrome
Microsoft Edge" > /tmp/Applist.txt

#read list of triggers and input into an array
triggerList="/tmp/trigger.txt"
appList="/tmp/Applist.txt"

#Teams card URL's
teamsTestingChannelURl="https://byu.webhook.office.com/webhookb2/6a657e98-5590-47ae-8c82-b2430447d22f@c6fc6e9b-51fb-48a8-b779-9ee564b40413/IncomingWebhook/d7cc4cb9e5e248a4bbdc8beac4d70d35/d80d9b1a-9a9b-4063-98b3-47b282e0ddf4"
teamsProductionChannelURL="https://byu.webhook.office.com/webhookb2/6a657e98-5590-47ae-8c82-b2430447d22f@c6fc6e9b-51fb-48a8-b779-9ee564b40413/IncomingWebhook/86e81dfdbb9a4152a2f009789aa15924/d80d9b1a-9a9b-4063-98b3-47b282e0ddf4"


#this variable will hold potential error Teams card output
POLICYERROR=""
LINE_ERROR=""




# use curl below to send post data to teams card.
# on macOS or Linux
#curl -H 'Content-Type: application/json' -d "${cardJsonString}" $teamsTestingChannelURl


#reading from trigger list
#creating arrays that will contain both the trigger names and the app names with append .app 
#respectively
IFS=$'\n'
for line in $(cat $triggerList)
do
    trigger_list+=("$line")
   
done
# reading from app list
for line in $(cat $appList)
do
    app_list_Array+=("$line.app")
    echo $line
   
done




#send proper command line argument if you want to delete applications   "install" = install applications / "d" = delete applications

    echo "initaiting policy checker"
    #this is where we initiate the policy using the jamf trigger
    #############################################################################################################
    error_found=0

    for trigger in "${trigger_list[@]}"
    do
                trigger_result=$(/usr/local/bin/jamf policy -event $trigger -verbose | awk '{print $2 $3}' | tail -n 1)
        if [ $trigger_result == "Policyerror" ]
        then

            error_found=1
            date=$(date)
           printf "there is a policy error for app %s\n %s" $trigger $date >> "/Users/iarriola/Documents/MACManager_files/Log_files/error.txt"
           POLICYERROR+="there is a policy error for app $trigger $date "
        
           
        else
            printf "policy for app %s was a success \n" $trigger 

        fi
        
    done

    #DEBUG statment delete
    echo "Final end product to output for policy errors onto teams card = /n"
    echo $LINE_ERROR


    result=$([[ $error_found == 1 ]] && echo "Error has been found check logs" || echo "No error found")

    echo $result
    #resetting error found variable not sure if neccessary
   

    echo "############################################## END OF REPORT" >> "/Users/iarriola/Downloads/error.txt"
    #############################################################################################################
    # this is where we try to find the location of the applications.

    printf "Begining to check for file path..\n"

    for appName in "${app_list_Array[@]}"
    do


            if [ ! -d "/Applications/${appName}" ]; then
                   #prepend=$(date)

                    echo "Path not found for ${appName}" >> /Users/iarriola/Documents/MACManager_files/Log_files/applications_not_found_list.txt
                    LINE_ERROR+="Path not found for ${appName} "
            
            else
                    echo "Application found"
                     var=$(mdls -name kMDItemVersion "/Applications/${appName}" | awk -F'"' '{for(i=0;i<NF;i++){print $i}}' | tail -n 1)
                     version_number+=("$var")
                     echo "app name is $appName = $var"
            fi

    done

    #if there has been an error found use the webhook to send error message to teams card
    if [ $error_found -eq 1 ];then
        echo "sending info via webhook to teams channel"

        echo "Content of policy error = $POLICYERROR"
        echo "Content of line error = $LINE_ERROR"


         #JSON skeleton for teams message
        cardJsonString=$(jq --null-input \
        --arg jq_error "$POLICYERROR" \
        --arg line_error "$LINE_ERROR" \
        '{
            "type":"message",
            "attachments":[
                {
                    "contentType":"application/vnd.microsoft.card.adaptive",
                    "contentUrl":null,
                    "content":{
                        "`$schema":"http://adaptivecards.io/schemas/adaptive-card.json",
                        "type":"AdaptiveCard",
                        "version":"1.2",
                        "msTeams": { "width": "full" },
                        "body": [
                            {
                                "type": "TextBlock",
                                "text": "MACManager Report:",
                                "wrap": true
                            },
                            {
                                "type": "FactSet",
                                "facts" : [
                                    {
                                        "name": "Description",
                                        "value": "**Policy Report**"
                                    },
                                    {
                                        "name": "Description",
                                        "value": $jq_error
                                    }
                                    ,
                                    {
                                        "name": "Description",
                                        "value": "**Path Report**"
                                    }
                                    ,
                                    {
                                        "name": "Description",
                                        "value": $line_error
                                    }
                                ]
                            }
                        ]
                    }
                }
            ]
        }
        ')

        curl -H 'Content-Type: application/json' -d "${cardJsonString}" $teamsProductionChannelURL

    fi

    #alert for the user.

    osascript -e 'tell application (path to frontmost application as text) to display dialog "Script has finished running" buttons {"OK"} with icon stop'

#############################################################################################################
  


