#!/bin/bash

logLocation="/Library/Logs/fmp.log"
echo "Mounting Drive to obtain DMG file" >> ${logLocation}
hdiutil attach "/Users/iarriola/Downloads/fmp_19.6.3.302.dmg"

echo "Moving application into app folder" >> ${logLocation}
cp -R "/Volumes/FileMaker Pro 19/FileMaker Pro.app" /Applications/

rm /Users/iarriola/Downloads/fmp_19.6.3.302.dmg

# hdiutil detach "/Volumes/FileMaker Pro 19"






