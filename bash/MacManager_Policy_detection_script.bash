#!/bin/bash


#read list of triggers and input into an array
triggerList="/Users/iarriola/Downloads/trigger.txt"
appList="/Users/iarriola/Downloads/testApplist.txt"
appListToDelete="/Users/iarriola/Downloads/app_to_delete.txt"


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
    # echo "initaiting policy checker"
    # #this is where we initiate the policy using the jamf trigger
    # #############################################################################################################
    # error_found=0

    # for trigger in "${trigger_list[@]}"
    # do
    #             trigger_result=$(sudo jamf policy -event $trigger -verbose | awk '{print $2 $3}' | tail -n 1)
    #     if [ $trigger_result == "Policyerror" ]
    #     then

    #         error_found=1
    #         date=$(date)
    #         printf "there is a policy error for app %s\n %s" $trigger $date >> "/Users/iarriola/Downloads/error.txt"
    #     else
    #         printf "policy for app %s was a success \n" $trigger 

    #     fi
        
    # done



    # result=$([[ $error_found == 1 ]] && echo "Error has been found check logs" || echo "No error found")

    # echo $result
    # #resetting error found variable not sure if neccessary
    # error_found=0

    # echo "############################################## END OF REPORT" >> "/Users/iarriola/Downloads/error.txt \n\n"
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


if [ $1 == "d" ]
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


        else
            sudo rm -Rf "/Applications/${appName}"
        fi

    done

    

fi
