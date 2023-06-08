#!/bin/zsh

#  CitrixAutoInstall.sh
#
#  BYU Endpoint Engineering
#  Created by William Kade Mahler on 3/20/20.
#  Fixed by Ivan Arriola on 6/8/23
#
#  Version 1.1

#INSTALL VARIABLES
# Using portal link which contains download button
LATESTPORTAL="https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html"
#DMG download name
DMGNAME="LatestCitrixWorkspace.dmg"
#path for log
LOGFILE="/Library/Logs/CitrixAutoInstallScript.log"
# #download location (JAMF Waiting room)
# DOWNLOADPATH="/Library/Application Support/JAMF/Waiting Room/"



#Start of Auto Install Script

#Use echo to write to logfile
#/bin/echo "-- Citrix Auto Install Started --" >> ${LOGFILE}

#Get Download Link
#/bin/echo "Checking $LATESTPORTAL for the newest version" >> ${LOGFILE}
downloadURL=$(curl $LATESTPORTAL | awk -F"['\"]" '{ for (i = 1; i <= NF; i++) {print $i } }' | grep 'dmg' | grep 'CitrixWorkspaceApp' | grep '=' | head -n 1)
downloadURL="https:$downloadURL"
echo $downloadURL
#/bin/echo "Selected download link: $downloadURL" >> ${LOGFILE}

#Download the newest citrix workspace dmg
#/bin/echo "Downloading the latest version to $DOWNLOADPATH as $DMGNAME" >> ${LOGFILE}
# /bin/echo $(/usr/bin/curl -s -o ${DOWNLOADPATH}/${DMGNAME} ${downloadURL}) >> ${LOGFILE}


cd /tmp && curl -L -o $DMGNAME $downloadURL

#Mount the dmg
#/bin/echo "Mounting $DMGNAME" >> ${LOGFILE}
hdiutil attach -nobrowse $DMGNAME

#Find the DMG
mountedDMG="$(find /Volumes -maxdepth 1 -name "*Citrix Workspace*")"





#Run Cleanup (Merged from Hidden Uninstall, Delete Leftover Files, & Fresh Install - Citrix Workspace)
## Kill running Citrix processes
pkill "Citrix Receiver"
pkill "Citrix Workspace"
pkill "ReceiverHelper"

 
 
#CURRENTLY BROKEN AND HANGS 
## Uninstall the current version of Citrix Workstation
#uninstallPKG=$(find ${mountedDMG} -maxdepth 1 -name "*Uninstall*")
#${uninstallPKG}/Contents/MacOS/Uninstall\ Citrix\ Workspace --nogui

## Create an array of users
unset currentusers
for f in /Users/*; do currentusers+="$f "; done

## Parse through all user accounts and clean up leftover Citrix files
for currentuser in $currentusers; do

    sudo rm -Rf $currentuser/Library/Application\ Support/com.citrix.receiver.nomas
    sudo rm -Rf $currentuser/Library/Application\ Support/com.citrix.ReceiverHelper
    sudo rm -Rf $currentuser/Library/Application\ Support/com.citrix.UninstallReceiver
    sudo rm -Rf $currentuser/Library/Application\ Support/com.citrix.ReceiverUpdater

    sudo rm -Rf $currentuser/Library/WebKit/com.citrix.AuthManagerMac

    sudo rm -f $currentuser/Library/Preferences/com.citrix.UninstallReceiver.plist
    sudo rm -f $currentuser/Library/Preferences/com.citrix.ReceiverHelper.plist
    sudo rm -f $currentuser/Library/Preferences/com.citrix.AuthManager.plist
    sudo rm -f $currentuser/Library/Preferences/com.citrix.AuthManagerMac.plist
    sudo rm -f $currentuser/Library/Preferences/com.citrix.receiver.nomas.plist
    sudo rm -f $currentuser/Library/Preferences/com.citrix.ReceiverFTU.AccountRecords.plist

    rm -Rf $currentuser/Library/Caches/com.citrix.AuthManagerMac
    rm -Rf $currentuser/Library/Caches/com.citrix.UninstallReceiver
    rm -Rf $currentuser/Library/Caches/com.plausiblelabs.crashreporter.data/com.citrix.UninstallReceiver
    rm -Rf $currentuser/Library/Caches/com.plausiblelabs.crashreporter.data/com.citrix.ReceiverHelper
    rm -Rf $currentuser/Library/Caches/com.plausiblelabs.crashreporter.data/com.citrix.receiver.nomas
    rm -Rf $currentuser/Library/Caches/com.plausiblelabs.crashreporter.data/com.citrix.ReceiverUpdater
    rm -Rf $currentuser/Library/Caches/com.citrix.ReceiverUpdater
    rm -Rf $currentuser/Library/Caches/com.citrix.ReceiverHelper
    rm -Rf $currentuser/Library/Caches/com.citrix.receiver.nomas

done



#Install the newest version
pkgFile=$(find ${mountedDMG} -maxdepth 1 -name "*Install*")
echo "Running installer at: $pkgFile"
failed=$(sudo installer -pkg "$pkgFile" -target / | grep failed)

if [ -z $failed ]
then
    echo "Install was a success"
else
    uninstallPkgFile=$(find ${mountedDMG} -maxdepth 1 -name "*Uninstall*")
    installer -pkg "$uninstallPkgFile" -target / 
fi

#Unmount and delete the .dmg
/bin/echo "Detaching and removing the .dmg from $DOWNLOADPATH"

sleep 3 && hdiutil detach $mountedDMG
rm -f /tmp/${DMGNAME}

#Finish
/bin/echo "Installation Script Complete." 

exit 0