
#The script below is to get the base installer automatically 
url="https://helpx.adobe.com/acrobat/kb/acrobat-dc-downloads.html"

if [ -d "/Applications/Adobe Acrobat DC" ] || [ -a "/Applications/Adobe Acrobat.app" ]
then

    echo "File does indeed exist currently"
    #get current version of the exiting base installer
    current_version_number=$(mdls -name kMDItemVersion /Applications/Adobe\ Acrobat.app | awk -F'"' '{print $2}') 
    echo "Users app current version number is $current_version_number"
    # #download latest Adobe from website then pull version number
    # mkdir /Applications/Adobe\ Acrobat\ DC && sudo cp -R /Applications/Adobe\ Acrobat.app /Applications/Adobe\ Acrobat\ DC
    # cd /tmp && DMG=$(curl -L $url  | awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep trials | grep dmg | sort | head -n 1)
    # echo "current in" && ls
    # hdiutil attach $DMG && sudo installer -pkg /Volumes/Acrobat/Acrobat/Acrobat\ DC\ Installer.pkg -target /tmp && hdiutil detach /Volumes/Acrobat

    # #get version number of current website base installer
    # echo "getting version of application"
    # other_version_number=$(mdls -name kMDItemVersion /Applications/Adobe\ Acrobat\ DC/Adobe\ Acrobat.app | awk -F'"' '{print $2}') 
    # echo "most recent download Version number is $other_version_number"



    # #function to figure out which version number is greater
    # function convert_to_integer {
    #     echo "$@" | awk -F "." '{ printf("%03d%03d%03d", $1,$2,$3); }';
    # }

    # if [ "$(convert_to_integer $current_version_number)" -ge "$(convert_to_integer $other_version_number)" ];then
    #        echo "Deleting the original application"
    #     sudo rm -R -f /Applications/Adobe\ Acrobat.app
    #     echo "Moving the new version into application folder"
    #     sudo cp -R -f /Applications/Adobe\ Acrobat\ DC/Adobe\ Acrobat.app /Applications/ 
    #     sleep 10
    #     echo "deleting the adobe application folder"
    #     sudo rm -R -f /Applications/Adobe\ Acrobat\ DC
    # else
    #     echo "The temp folder that has the prospective most recent download application folder will be removed and replaced with package"
    #     sudo rm -R -f /Applications/Adobe\ Acrobat\ DC
    #     echo "Current version is either the same or greater"
    #     echo "No need to upgrade the adobe application"
    # fi
     


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
# current_version_number=$(mdls -name kMDItemVersion /Applications/Adobe\ Acrobat.app | awk -F'"' '{print $2}') 
# echo "Users app current version number is $current_version_number"



###############################################################################################################################

#code below might not be neccessary if base installer installs latest base installer and patch
# code below to get current major Version of adobe acrobat using patches
current_patch_version_number=$(mdls -name kMDItemVersion /Applications/Adobe\ Acrobat\ DC/Adobe\ Acrobat.app | awk -F'"' '{print $2}' | awk -F'.' '{print $1}')
echo $current_patch_version_number


#if patch version matches the base installer version
#Proceed

#get current month and date and year

month=$(date |  awk -F' ' '{print $2}')

day=$(date |  awk -F' ' '{print $3}')

year=$(date |  awk -F' ' '{print $6}')

#possible newest base installer
# https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/continuous/dccontinuous.html#dccontinuous


#gets all the past patches for adobe except windows only
current_patch=$(curl -L https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html | awk -F'><' '{for(i = 1; i < NF;i++){print $i}}' | grep update, | tail -n +2 | sed 's/span class="std std-ref">//g' | sed 's:</span::g' | head -n 1)
echo $current_patch
has_windows=$(echo $currentPatch | grep Windows)
if [ -z "$has_windows"] 
then
    echo "String did not contain windows, string = \"${has_windows}\""
    url=https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/
    path=$(curl -L https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html | awk -F'"' '{for(i = 1; i < NF;i++){print $i}}' | grep continuous | tail -n +9 | head -n 1)
    url+=$path

    
    dmg=$(curl -L $url | awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep mac | head -n 1)
    echo $dmg
    cd ~/Downloads
    curl -O $dmg && dmg=$(ls | grep AcrobatDCUp) && hdiutil attach $dmg 
    sudo installer -pkg /Volumes/AcrobatDCUpd2300120177/AcrobatDCUpd2300120177.pkg -target /tmp 
    cd / && sleep 5
    hdiutil detach /Volumes/AcrobatDCUpd2300120177
    

else
    echo "No download, latest patch is windows only"
fi

