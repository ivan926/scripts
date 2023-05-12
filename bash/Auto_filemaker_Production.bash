#!/bin/bash


#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	Automatic install of File Maker
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Ivan Arriola 4/15/23
#
#
####################################################################################################

url="https://accounts.claris.com/software/license/332K4-243VM-J1V1V-MN971-18847-VKK55-N5J62"
logFile="/Library/Logs/filemaker.log"



echo "Attempting to close Filemaker app if opened" >> $logFile

if [ -a "Filemaker Pro.app" ]; then


echo "Closing filemaker app" >> $logfile

osascript -e 'quit app "Filemaker Pro.app"'

echo "deleting current Filemaker version" >> $logFile

rm -R-f /Applications/Filemaker\ Pro.app/

fi

echo "Using curl to extract url to dmg file for file maker" >> $logfile
#Extract the URL link 
dmgExecutable=$(curl -L $url | awk '{FS="\""} { for(i=1;i<NF;i++){ print $i}}' | grep .dmg | grep downloads | head -n 1 )


echo $dmgExecutable


echo "mounting the dmg to volume directory"
#mount dmg, move app to Application folder and unmount dmg file
hdiutil attach $dmgExecutable -noBrowse 

echo "Copying filemaker .app to application folder with existing attributes "

cd /Volumes
fileMaker=$(ls | grep File)
echo $fileMaker

echo "/Volumes/$fileMaker/FileMaker\ Pro.app /Applications/"
cp -R /Volumes/"$fileMaker"/FileMaker\ Pro.app /Applications/

echo "unmounting from volume directory" 
hdiutil detach /Volumes/"$fileMaker"

echo "app finished downloading "

# chmod -R 755 /Applications/FileMaker\ Pro.app
# chown -R root:wheel /Applications/FileMaker\ Pro.app
# chmod 777 /Applications/FileMaker\ Pro.app

