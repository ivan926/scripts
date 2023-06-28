#!/bin/bash

###############################################################################################################################
#		Auto Patch installer 																								  #
#							Version 1.0                                                                                       #
#                  Author   Ivan Arriola 6/21/23																              #
###############################################################################################################################

#test install, not neccessary package is create by Matt and is stored on jamf Admin repo
#sudo installer -pkg "/Tmp/Adobe Acrobat DC 23_Install.pkg/" -target /

#first things first, close the application if open or else you will not be able to apply patch, it will fail
if [ -a "/Applications/Adobe Acrobat DC/Adobe Acrobat.app" ] || [ -a "/Applications/Adobe Acrobat.app" ]; then

    echo "Closing Adobe Acrobat.app application"
    osascript -e 'quit app "Adobe Acrobat.app"'
    echo "app exists"

    else
    	echo "Application was not Found"

fi

# code below to get current patch version
current_patch_version_number=$(mdls -name kMDItemVersion /Applications/Adobe\ Acrobat\ DC/Adobe\ Acrobat.app | awk -F'"' '{print $2}' | awk -F'.' '{print $1}')
echo $current_patch_version_number

#gets the latest patch
latest_patch=$(curl -L https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html | awk -F'><' '{for(i = 1; i < NF;i++){print $i}}' | grep update, | tail -n +2 | sed 's/span class="std std-ref">//g' | sed 's:</span::g' | head -n 1)
echo $latest_patch
has_windows=$(echo $latest_patch | grep Windows)

if [ -z "$has_windows"] 
then
      echo "String did not contain windows, string = \"${has_windows}\""
    url=https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/
    path=$(curl -L https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html | awk -F'"' '{for(i = 1; i < NF;i++){print $i}}' | grep continuous | tail -n +9 | head -n 1)
    url+=$path

    dmg=$(curl -L $url | awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep mac | head -n 1)
    echo $dmg
    #Creating invisible temp folder
    cd ~/Downloads 
	mkdir .tmp 
	cd .tmp
	#pull latest patch and attach the DMG
    sudo curl -O $dmg 
	dmg=$(ls | grep AcrobatDCUp) 
	hdiutil attach -noBrowse $dmg 
	#get the patch name of the package in order to install automatically and to detach automatically
    pathName=$(ls | awk -F'.' '{print $1}') 
	PKG_path="/Volumes/${pathName}/${pathName}.pkg" 
	detachmentPath="/Volumes/${pathName}" 
	#install package
    sudo installer -pkg $PKG_path -target / 
	#remove the hidden folder and sleep to ensure everything executes accordingly
    cd / 
	sudo rm -R ~/Downloads/.tmp 
	sleep 5
    #hdiutil detach $detachmentPath



else
    echo "No download, latest patch is windows only"
fi
