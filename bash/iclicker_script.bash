#!/bin/bash


DMG_name=$(ls /Library/Application\ Support/JAMF/Waiting\ Room/ | grep iclicker | head -n 1)

XML_name=$(ls /Library/Application\ Support/JAMF/Waiting\ Room/ | grep iclicker | tail -n 1)

echo $DMG_name

echo $XML_name

hdiutil attach -nobrowse "/Library/Application Support/JAMF/Waiting Room/${DMG_name}"

cp -Rf "/Volumes/iclicker-cloud install/iClicker Cloud.app" /Applications/

hdiutil detach "/Volumes/iclicker-cloud install"

rm "/Library/Application Support/JAMF/Waiting Room/${DMG_name}"

rm "/Library/Application Support/JAMF/Waiting Room/${XML_name}" 

