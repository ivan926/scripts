#!/bin/bash
#The script below is to get the base installer automatically 
url="https://helpx.adobe.com/acrobat/kb/acrobat-dc-downloads.html"

if [ -d "/Applications/Adobe Acrobat DC" ] || [ -a "/Applications/Adobe Acrobat.app" ]
then

    echo "File does indeed exist currently"
    #get current version of the exiting base installer
    current_version_number=$(mdls -name kMDItemVersion /Applications/Adobe\ Acrobat.app | awk -F'"' '{print $2}') 
    echo "Users app current major version number is $current_version_number"

    

else
    echo "No Adobe application found installing new Adobe"
    cd /tmp && DMG=$(curl -L $url  | awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep trials | grep dmg | sort | head -n 1)

    mkdir /Applications/Adobe\ Acrobat\ DC
    #mount dmg to volume folder and install package using installer command and detach DMG file
    hdiutil attach -noBrowse $DMG && sudo installer -pkg /Volumes/Acrobat/Acrobat/Acrobat\ DC\ Installer.pkg -target /tmp && hdiutil detach /Volumes/Acrobat

    sudo cp -R -f /Applications/Adobe\ Acrobat\ DC/Adobe\ Acrobat.app /Applications/ 
    sudo rm -R -f /Applications/Adobe\ Acrobat\ DC
fi

#getting the current version of the adobe pro app 


###############################################################################################################################

#code below might not be neccessary if base installer installs latest base installer and patch
# code below to get current major Version of adobe acrobat using patches
echo "Going to the tmp folder and getting the current applications path number"
cd /tmp && current_patch_version_number=$(mdls -name kMDItemVersion /Applications/Adobe\ Acrobat\ DC/Adobe\ Acrobat.app | awk -F'"' '{print $2}' | awk -F'.' '{print $1}')
echo "The current patch version number is $current_patch_version_number"


#if patch version matches the base installer version
#Proceed

#get current month and date and year

month=$(date |  awk -F' ' '{print $2}')

day=$(date |  awk -F' ' '{print $3}')

year=$(date |  awk -F' ' '{print $6}')

#possible newest base installer
# https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/continuous/dccontinuous.html#dccontinuous


#gets all the past patches for adobe except windows only
echo "Getting latest current patch from website"
current_patch=$(curl -L https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html | awk -F'><' '{for(i = 1; i < NF;i++){print $i}}' | grep update, | tail -n +2 | sed 's/span class="std std-ref">//g' | sed 's:</span::g' | head -n 1)

latest_version_number=$(echo $current_patch | awk '{print $1}') 

echo "The latest current patch = $current_patch"
has_windows=$(echo $currentPatch | grep Windows)
if [ -z "$has_windows" ] 
then
    echo "String did not contain windows, string = \"${has_windows}\""
    url=https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/
    path=$(curl -L https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html | awk -F'"' '{for(i = 1; i < NF;i++){print $i}}' | grep continuous | tail -n +9 | head -n 1)
    url+=$path

    
    dmg=$(curl -L $url | awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep mac | head -n 1)
    echo $dmg
    #remember to delete tmp folder
    cd ~/Downloads && mkdir .tmp && cd .tmp
    sudo curl -O $dmg && dmg=$(ls | grep AcrobatDCUp) && hdiutil attach -noBrowse $dmg 
    pathName=$(ls | awk -F'.' '{print $1}') && PKG_path="/Volumes/${pathName}/${pathName}.pkg" && detachmentPath="/Volumes/${pathName}" 
    sudo installer -pkg $PKG_path -target / 
    cd / && sudo rm -R ~/Downloads/.tmp && sleep 5
    hdiutil detach $detachmentPath
    

else
    echo "No download, latest patch is windows only"
fi

