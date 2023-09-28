#!/bin/bash

#Current License key as of 9/26/23 software.byu.edu/fusiont should always have the latest
license_key="NN601-J8L46-58VQ2-0C88P-1NZH1"

#checking to see if homebrew is installed

home_brew_installed=$(brew -v)
if [ -z $home_brew_installed ]; then
    #home brew not installed install using policy from JAMF
    sudo jamf policy -event homebrew -verbose

fi 


# #install vmware using brew package manager 
# If application is installed checks to see if the app needs an update
brew install --cask vmware-fusion

#create temporary fusion directory
sudo mkdir /tmp/fusion

#move deployment package into tmp folder
sudo cp -R "/Applications/VMware Fusion.app/Contents/Library/Deploy VMware Fusion.mpkg" /tmp/fusion

#move VMware xapplication into 00Fusion_deployment_Items
sudo cp -R "/Applications/VMware Fusion.app" "/tmp/fusion/Deploy VMware Fusion.mpkg/Contents/00Fusion_Deployment_Items/"

#go into Fusion package and add the current license key #we need to HARDCODDE THE LICENSE BELOW IN THE SED COMMAND BECAUSE OF SINGLE QUOTATIONS
sudo sed -i'.original' 's/# key = XXXXX-XXXXX-XXXXX-XXXXX-XXXXX/key = NN601-J8L46-58VQ2-0C88P-1NZH1/' "/tmp/fusion/Deploy VMware Fusion.mpkg/Contents/00Fusion_Deployment_Items/Deploy.ini"

#copy vmware package into temp folder "Fusion"
sudo cp -R  /Applications/VMware\ Fusion.app/Contents/Library/Deploy\ VMware\ Fusion.mpkg /tmp/fusion/

#remove the license-less vmware fusion from the app directory
sudo rm -R /Applications/VMware\ Fusion.app/

#install the modified package mpkg
sudo installer -pkg "/tmp/fusion/Deploy VMware Fusion.mpkg" -target /

#clean up
sudo rm -R /tmp/fusion

