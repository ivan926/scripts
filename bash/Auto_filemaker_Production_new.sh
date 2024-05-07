#!/bin/bash


#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	Automatic install of File Maker / created deployment package that will install on users device
#
####################################################################################################
#
# HISTORY
#
#	Version: 2.0
#
#	- Ivan Arriola 4/15/23
#   - Ivan Arriola 5/7/24
#
####################################################################################################

origin="https://www.claris.com"

#download apple script to automate cert input to app
path=$(curl -L https://www.claris.com/resources/documentation/ | grep -E "/resources/documentation/docs/fmp" | head -n 1 )
#cut down parts of url that are undesirable
path=$(echo $url | sed -E 's/^<a href="//g')
path=$(echo $url | sed -e 's/"[^"]*//g')
#concatonate
origin+="$path"

#move into temporary environment
mkdir ~/Downloads/temp
cd ~/Downloads/temp
mkdir ~/Downloads/temp/FileMakerPro
#move certification file installed through jamfPro into FileMakerPro setup folder
mv ~/Downloads/LicenseCert.fmcert ~/Downloads/temp/FileMakerPro/

#download apple script and unzip the file
curl -L -O $origin
unzip fmp_osx_deployment.zip
chmod +x ./AppleRemoteDesktopDeployment.sh

#modify assisted isntall file
sed -i '' "s/AI_SKIPDIALOG=0/AI_SKIPDIALOG=1/g" "Assisted Install.txt"
sed -i '' "s/AI_LICENSE_ACCEPTED=0/AI_LICENSE_ACCEPTED=1/g" "Assisted Install.txt"




dmg="https://accounts.claris.com/software/license/37737-V7JTV-V369T-4N8JJ-JM42K-885N6-TX4NN"
logFile="/Library/Logs/filemaker.log"


####################################################################################
echo "Attempting to close Filemaker app if opened" >> $logFile

if [ -a "Filemaker Pro.app" ]; then


echo "Closing filemaker app" >> $logfile

osascript -e 'quit app "Filemaker Pro.app"'

echo "deleting current Filemaker version" >> $logFile

rm -R-f /Applications/Filemaker\ Pro.app/

fi

####################################################################################

echo "Using curl to extract url to dmg file for file maker" >> $logfile
#Extract the URL link 
dmgExecutable=$(curl -L $dmg | awk '{FS="\""} { for(i=1;i<NF;i++){ print $i}}' | grep .dmg | grep downloads | head -n 1 )
echo $dmgExecutable

echo "mounting the dmg to volume directory"
#mount dmg, move app to Application folder and unmount dmg file
hdiutil attach $dmgExecutable -noBrowse 

echo "Copying filemaker .app to application folder with existing attributes "

cd /Volumes
fileMaker=$(ls | grep File)
echo $fileMaker

echo "/Volumes/$fileMaker/FileMaker\ Pro.app /Applications/"

FileMaker_mount_name=$(ls /Volumes | grep FileMaker | head -n 1)
#copying all contents of opened dmg file to setup filemaker folder
cp -R "/Volumes/$FileMaker_mount_name/" ~/Downloads/temp/FileMakerPro/

#create deployment package with license included
cd ~/Downloads/temp
./AppleRemoteDesktopDeployment.sh FileMakerPro
#detach original dmg file mounted
hdiutil detach "/Volumes/$FileMaker_mount_name"

#install package in newly built package 
installer -pkg FileMakerPro/FileMaker\ Pro\ ARD.pkg -target /

#clean up remove temp folder
#rm -R ~/Download/temp

# chmod -R 755 /Applications/FileMaker\ Pro.app
# chown -R root:wheel /Applications/FileMaker\ Pro.app
# chmod 777 /Applications/FileMaker\ Pro.app

