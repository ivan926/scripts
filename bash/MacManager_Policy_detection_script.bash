#!/bin/bash


#read list of triggers and input into an array
triggerList="/Users/iarriola/Downloads/trigger.txt"
appList="/Users/iarriola/Downloads/testApplist.txt"
appListToDelete="/Users/iarriola/Downloads/app_to_delete.txt"

#Teams card URL's
$teamsTestingChannelURl="https://byu.webhook.office.com/webhookb2/6a657e98-5590-47ae-8c82-b2430447d22f@c6fc6e9b-51fb-48a8-b779-9ee564b40413/IncomingWebhook/d7cc4cb9e5e248a4bbdc8beac4d70d35/d80d9b1a-9a9b-4063-98b3-47b282e0ddf4"






ERROR="Something broke"


# AUTH_BODY=$(jq --null-input \
#   --arg user "$USERNAME" \
#   --arg password "$PASSWORD" \
#   '{"user": $user, "password": $password}')


#JSON skeleton for teams message
cardJsonString=$(jq --null-input \
--arg jq_error "$ERROR" \
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
                                "value": "Test from Bash"
                            },
                            {
                                "name": "Description",
                                "value": $jq_error
                            }
                          ]
                     }
                ]
            }
        }
    ]
}
')


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

# reading from app list to delete
for line in $(cat $appListToDelete)
do
    app_list_delete_Array+=("$line.app")

   
done



#send proper command line argument if you want to delete applications   "install" = install applications / "d" = delete applications
if [ "$1" == "install" ];then
    echo "initaiting policy checker"
    #this is where we initiate the policy using the jamf trigger
    #############################################################################################################
    error_found=0

    for trigger in "${trigger_list[@]}"
    do
                trigger_result=$(sudo jamf policy -event $trigger -verbose | awk '{print $2 $3}' | tail -n 1)
        if [ $trigger_result == "Policyerror" ]
        then

            error_found=1
            date=$(date)
            printf "there is a policy error for app %s\n %s" $trigger $date >> "/Users/iarriola/Downloads/error.txt"
        else
            printf "policy for app %s was a success \n" $trigger 

        fi
        
    done



    result=$([[ $error_found == 1 ]] && echo "Error has been found check logs" || echo "No error found")

    echo $result
    #resetting error found variable not sure if neccessary
    error_found=0

    echo "############################################## END OF REPORT" >> "/Users/iarriola/Downloads/error.txt \n\n"
    #############################################################################################################
    # this is where we try to find the location of the applications.

    IFS=$'\n'
    # reading from app list
    for line in $(cat $appList)
    do
        app_list_Array+=("$line.app")
        echo $line

    done

    printf "Begining to check for file path..\n"

    for appName in "${app_list_Array[@]}"
    do


            if [ ! -d "/Applications/${appName}" ]; then
                    prepend=$(date)

                    # echo "Path not found for ${appName}" >> ~/Downloads/applications_not_found_list_${prepend}.txt
                    echo "Path not found for ${appName}"
            else
                    echo "Application found"
                     var=$(mdls -name kMDItemVersion "/Applications/${appName}" | awk -F'"' '{for(i=0;i<NF;i++){print $i}}' | tail -n 1)
                     version_number+=("$var")
                     echo "app name is $appName = $var"
            fi

    done

    #alert for the user.
    osascript -e 'tell application (path to frontmost application as text) to display dialog "Script has finished running" buttons {"OK"} with icon stop'

#############################################################################################################
  
fi


if [ "$1" == "d" ]
then

    echo "Begining process to delete applications"
    for appName in "${app_list_delete_Array[@]}"
    do    

        if [ "$appName" == "EndNote 20.app" ];then
            sudo rm -Rf "/Applications/EndNote 20"

        elif [ "$appName" == "Adobe Acrobat DC.app" ];then
            echo "in the adobe sphere"
            sudo rm -Rf "/Applications/Adobe Acrobat DC"
        elif [ "$appName" == "Box.app" ];then
            echo "in the Box block"
            sudo rm -Rf "/Applications/Box.app"
            user_name=$(whoami)
            echo $user_name
            sudo rm -Rf "/Users/$user_name/Library/Application Support/Box"
        elif [ "$appName" == "Citrix Workspace.app" ];then

            echo "Inside citrix workspace"

            echo "closing citrix work station"
            citrix_workspace_process_id=$(ps -ax | grep "Citrix Workspace LaunchStatusMenuFromHelper" | head -n 1 | awk '{print $1}')
            echo $citrix_workspace_process_id
            sudo kill $citrix_workspace_process_id 

            echo "running uninstall executable"

    
            sudo open -gj /Volumes/Citrix\ Workspace/Uninstall\ Citrix\ Workspace.app/Contents/MacOS/Uninstall\ Citrix\ Workspace

            echo "Uninstall citrix work station osascript running now"
            sleep 5
                sudo osascript -e '
            tell application "System Events"
                    tell process "Uninstall Citrix Workspace" 
                        click button "Continue" of window "Uninstall Citrix Workspace"
                    end tell
            end tell'
            sleep 3
            osascript -e '
        tell application "System Events"
	        tell process "Uninstall Citrix Workspace"
		        click button "Quit" of window "Uninstall Citrix Workspace"
	        end tell
        end tell'


        


        else

            echo "Removing the app $appName"
            sudo rm -Rf "/Applications/${appName}"
        fi

    done

    

fi
