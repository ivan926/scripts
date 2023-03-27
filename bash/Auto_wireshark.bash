#!/bin/bash

# CurrentVersion=$5
CurrentVersion="4.0.4"

appName="Wireshark"
appFile="$appName.app"


hdiutil attach -nobrowse /Library/"Application Support"/JAMF/"Waiting Room"/"${appName}-${CurrentVersion}-intel.dmg"

if [ -a "/Applications/$appFile" ];then

      
	osascript -e 'quit app "Wireshark"'
    pkill -9 "$appName"

    # Remove the previous version of NVivo 12
	rm -rf "/Applications/$appFile"

fi




#copying application from volume to the application folder
cp -Rfp /Volumes/"${appName} ${CurrentVersion}"/$appFile /Applications/$appFile

#removing the dmg and xml files in the waiting room
rm -f /Library/Application\ Support/JAMF/Waiting\ Room/"${appName}-${CurrentVersion}-intel.dmg"

rm -f /Library/Application\ Support/JAMF/Waiting\ Room/"${appName}-${CurrentVersion}-intel.dmg.cache.xml"

#detaching the volume used to mount our dmg
hdiutil detach /Volumes/"${appName} ${CurrentVersion}"


#removing potential quarantine application could have
xattr -r -d com.apple.quarantine /Applications/Wireshark.app/

#potential code to implement
# chmod -R 755 /Applications/Wireshark.app
# sudo chown -R root:wheel /Applications/Wireshark.apps

