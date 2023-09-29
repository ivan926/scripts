#!/bin/bash

#Current License key as of 9/26/23 software.byu.edu/fusiont should always have the latest
#Not actually used in the script, it is for reference (2023/2024)
license_key="NN601-J8L46-58VQ2-0C88P-1NZH1"

#VMware URL for universal DMG



#checking to see if VMware is opened, if so close
if [ -a "/Applications/VMware Fusion.app" ]; then

    osascript -e 'quit app "VMware Fusion.app"'

fi

#removing application and ensuring application installed is Latest version
if [ -d "/Applications/VMware Fusion.app" ]; then
    #remove uninstall application, we do this so if there is a new license it can be reapplied when a user re-installs the application
    #should remove application in app folder
    sudo rm -Rf "/Applications/VMware Fusion.app"

fi



#retrieiving the DMG file from the internet
#################################################################################
major_version=$(curl -s -L https://softwareupdate.vmware.com/cds/vmw-desktop/fusion-universal.xml | awk '/<url>/{ for(i=1;i < NR;i++){print $i}}' | awk '/<url>/ {for(i=1;i<NR;i++){ print $i} }' | head -n 1 | awk -F'>' '{print $2}' | awk -F'<' '{print $1}' | awk -F'/' '{print $2}')
small_version=$(curl -s -L https://softwareupdate.vmware.com/cds/vmw-desktop/fusion-universal.xml | awk '/<url>/{ for(i=1;i < NR;i++){print $i}}' | awk '/<url>/ {for(i=1;i<NR;i++){ print $i} }' | head -n 1 | awk -F'>' '{print $2}' | awk -F'<' '{print $1}' | awk -F'/' '{print $3}')
FUS_num=$(curl -s -L https://softwareupdate.vmware.com/cds/vmw-desktop/fusion-universal.xml | awk '/<url>/{ for(i=1;i < NR;i++){print $i}}' | awk '/<url>/ {for(i=1;i<NR;i++){ print $i} }' | head -n 1 | awk -F'>' '{print $2}' | awk -F'<' '{print $1}' | awk -F'/' '{print $2}' | tr -d '.')

VMware_URL_download="https://download3.vmware.com/software/FUS-${FUS_num}/VMware-Fusion-${major_version}-${small_version}_universal.dmg"

#Debug print statement below
#printf "major = %s small = %s FUS = %s \n" $major_version $small_version $FUS_num
#cho $VMware_URL_download

#create temporary fusion directory
mkdir /tmp/fusion

cd /tmp/fusion

sudo curl -s -L -O $VMware_URL_download

dmg=$(ls /tmp/fusion)

hdiutil attach -noBrowse /tmp/fusion/$dmg

#execute the application
sudo "/Volumes/VMware Fusion/VMware Fusion.app/Contents/MacOS/VMware Fusion"

#give some time for screen to open and then close that screen
sleep 3
osascript -e 'quit app "VMware Fusion.app"'

#This error potentially needs to be checked
pid=$(ps -ax | grep "/Applications/VMware Fusion.app/Contents/Library/VMware Fusion Applications Menu.app/Contents/MacOS/VMware Fusion Applications Menu" | grep -v grep | awk '{print $1}')
if [ ! -z $pid ]; then
    echo "Error process found"
    kill -9 $pid
fi


hdiutil detach "/Volumes/VMware Fusion"




#################################################################################


#sleep to wait for instruction to execute properly
sleep 3

#move deployment package into tmp folder
sudo cp -R "/Applications/VMware Fusion.app/Contents/Library/Deploy VMware Fusion.mpkg" /tmp/fusion

#move VMware xapplication into 00Fusion_deployment_Items
sudo cp -R "/Applications/VMware Fusion.app" "/tmp/fusion/Deploy VMware Fusion.mpkg/Contents/00Fusion_Deployment_Items/"

#sleep to wait for instruction to execute properly
sleep 3

#copy vmware package into temp folder "Fusion"
sudo cp -R  /Applications/VMware\ Fusion.app/Contents/Library/Deploy\ VMware\ Fusion.mpkg /tmp/fusion/

#Go into Fusion package and add the current license key #we need to HARDCODDE THE LICENSE BELOW IN THE SED COMMAND BECAUSE OF SINGLE QUOTATIONS
sudo sed -i'.original' 's/# key = XXXXX-XXXXX-XXXXX-XXXXX-XXXXX/key = NN601-J8L46-58VQ2-0C88P-1NZH1/' "/tmp/fusion/Deploy VMware Fusion.mpkg/Contents/00Fusion_Deployment_Items/Deploy.ini"

#remove the license-less vmware fusion from the app directory
sudo rm -R /Applications/VMware\ Fusion.app/

#install the modified package mpkg
sudo installer -pkg "/tmp/fusion/Deploy VMware Fusion.mpkg" -target /

#clean up
sudo rm -R /tmp/fusion

#message
printf "Directory removed, application ready for use!\n"

