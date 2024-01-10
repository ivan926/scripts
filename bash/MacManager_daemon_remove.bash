#!/bin/bash
 appListToDelete="/Users/iarriola/Documents/MACManager_files/app_to_delete.txt"

touch /tmp/the_process_begins.txt

#making sure that when we use cat to get our list of applications
#that we are getting the full line instead of breaking every space with a line
IFS=$'\n'

 # reading from app list to delete
for line in $(cat $appListToDelete)
do
    app_list_delete_Array+=("$line.app")

   
done
 
 echo "Begining process to delete applications"
   

    for appName in "${app_list_delete_Array[@]}"
    do    

        if [ "$appName" == "EndNote 20.app" ];then
             rm -Rf "/Applications/EndNote 20"

        elif [ "$appName" == "Adobe Acrobat DC.app" ];then
            echo "in the adobe sphere"
             rm -Rf "/Applications/Adobe Acrobat DC"
             if [ -d  "/Applications/Adobe Creative Cloud" ];then
                 rm -Rf "/Applications/Adobe Creative Cloud"
             fi
        elif [ "$appName" == "Box.app" ];then
            echo "in the Box block"
             rm -Rf "/Applications/Box.app"
            user_name=$(whoami)
            echo $user_name
             rm -Rf "/Users/$user_name/Library/Application Support/Box"

        #Probably cannot use the script below because we cannot uninstall citrix automatically

        elif [ "$appName" == "Citrix Workspace.app" ];then

            #INSTALL VARIABLES
            # Using portal link which contains download button
            LATESTPORTAL="https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html"
            #DMG download name
            DMGNAME="LatestCitrixWorkspace.dmg"

            #Get Download Link
            #/bin/echo "Checking $LATESTPORTAL for the newest version" >> ${LOGFILE}
            ############################################################################################################################################################
            downloadURL=$(curl $LATESTPORTAL | awk -F"['\"]" '{ for (i = 1; i <= NF; i++) {print $i } }' | grep 'dmg' | grep 'CitrixWorkspaceApp' | grep '=' | head -n 1)
            #############################################################################################################################################################
            downloadURL="https:$downloadURL"
            echo $downloadURL
            #/bin/echo "Selected download link: $downloadURL" >> ${LOGFILE}

            #Download the newest citrix workspace dmg
            /bin/echo "Downloading the latest version to $DOWNLOADPATH as $DMGNAME"
            ########################################################################
            cd /tmp && curl -L -o $DMGNAME $downloadURL
            ########################################################################
            #Mount the dmg
            #/bin/echo "Mounting $DMGNAME" >> ${LOGFILE}
            ########################################################################
            hdiutil attach -nobrowse $DMGNAME
            ########################################################################

            #Find the DMG
            mountedDMG="$(find /Volumes -maxdepth 1 -name "*Citrix Workspace*")"

           


            echo "Inside citrix workspace"

            echo "closing citrix work station"
            citrix_workspace_process_id=$(ps -ax | grep "Citrix Workspace LaunchStatusMenuFromHelper" | head -n 1 | awk '{print $1}')
            echo $citrix_workspace_process_id
             kill $citrix_workspace_process_id 

            echo "running uninstall executable"

    
             open -gj /Volumes/Citrix\ Workspace/Uninstall\ Citrix\ Workspace.app/Contents/MacOS/Uninstall\ Citrix\ Workspace

            echo "Uninstall citrix work station osascript running now"
            sleep 5
                 osascript -e '
            tell application "System Events"
                    tell process "Uninstall Citrix Workspace" 
                        click button "Continue" of window "Uninstall Citrix Workspace"
                    end tell
            end tell'
            sleep 15
            osascript -e '
            tell application "System Events"
                tell process "Uninstall Citrix Workspace"
                    click button "Quit" of window "Uninstall Citrix Workspace"
                end tell
            end tell'



             #Unmount and delete the .dmg
            /bin/echo "Detaching and removing the .dmg from $DOWNLOADPATH"
            #########################################################################
            sleep 3 && hdiutil detach $mountedDMG

            rm -f /tmp/${DMGNAME}
            #########################################################################


        


        else

            echo "Removing the app $appName"
            sudo rm -Rf "/Applications/${appName}"
        fi

    done