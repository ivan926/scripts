#!/bin/bash

# checks to see if application is already installed on the computer and handles cached adobe package
#####################################################################################################

#change this whenever Matt Kiefer who is in charge of creating the adobe reader package changes it. 
#change this to whatever the latest version that this application was downloading before a change was made
#
latest_package_version="23.006.20360"

#####################################################################################################

#get the names of the adobe zipped up package and cached XML
adobe_package_zip=$(sudo ls /Library/Application\ Support/JAMF/Waiting\ Room | grep "Adobe Acrobat" | grep -v cache)
adobe_package_cache_xml=$(sudo ls /Library/Application\ Support/JAMF/Waiting\ Room | grep "Adobe Acrobat" | tail -n 1)  


if [ -a "/Applications/Adobe Acrobat DC/Adobe Acrobat.app/" ] || [ -a "/Applications/Adobe Acrobat.app/" ];
then

         echo "Adobe already installed, checking to see if base installer needs to be changed"

        if [ -a "/Applications/Adobe Acrobat DC/Adobe Acrobat.app/" ]
        then
            current_version_number=$(mdls -name kMDItemVersion "/Applications/Adobe Acrobat DC/Adobe Acrobat.app" | awk -F'"' '{print $2}')     
            echo "Users app version num = $current_version_number"
            users_current_major_adobe_version=$(echo $current_version_number | awk -F'.' '{print $1}')
            echo "Current users current major version = $users_current_major_adobe_version"
            else 
            current_version_number=$(mdls -name kMDItemVersion "/Applications/Adobe Acrobat.app" | awk -F'"' '{print $2}') 
            echo "Users app version num = $current_version_number"
            users_current_major_adobe_version=$(echo $current_version_number | awk -F'.' '{print $1}')
            echo "Current users current major version = $users_current_major_adobe_version"
        fi 

        #the following commented out code has been deprecated
        #as the major version will not always increment when Matt Kiefer creates his package
        #getting the major version for our current package made by Matt Kiefer
        #casper_fs_package_version_num=$(echo $adobe_package_zip | awk '{print $4}' | awk -F'_' '{print $1}')
        #echo $casper_fs_package_version_num

        if [ "$users_current_major_adobe_version" -le ${latest_package_version} ]
        then
            echo "must remove current adobe and install new adobe package"            
            echo "$users_current_major_adobe_version and $latest_package_version"

            if [ -a "/Applications/Adobe Acrobat DC/Adobe Acrobat.app/" ]
            then
                rm -Rf "/Applications/Adobe Acrobat DC"
                
            elif [ -a "/Applications/Adobe Acrobat.app" ] 
            then
                rm -Rf "/Applications/Adobe Acrobat DC" 
            fi 

            #install new package
            #make directory to unzip the adobe package
            mkdir /tmp/tmp
            sleep 3

            #unzip the zip file from the waiting room to the temporary folder
            sudo unzip "/Library/Application Support/JAMF/Waiting Room/$adobe_package_zip" -d /tmp/tmp/
            echo $adobe_package_zip
			
            echo "removing caches from waiting room"
            #remove zip and cache from the waiting room
            rm "/Library/Application Support/JAMF/Waiting Room/$adobe_package_zip"
            rm "/Library/Application Support/JAMF/Waiting Room/$adobe_package_cache_xml"


            #find name of package in the download subdirectory of JAMF folder after the package has been cached
            adobe_package_full_path=$(sudo ls "/tmp/tmp" | grep "Adobe Acrobat DC")
            #adobe_package_full_path="\"/tmp/tmp/$adobe_package_zip\"" 

            echo $adobe_package_full_path
            
            echo "downloading package"
        
            installer -package "/tmp/tmp/$adobe_package_full_path" -target /
            sleep 5
            rm -R -f /tmp/tmp


        else
            echo "Major versions are the same ${users_current_major_adobe_version} == ${casper_fs_package_version_num} carry on. "

        fi
        #end of package version verification
        
else   
        #application does not currently exist

        #make directory to unzip the adobe package
        mkdir /tmp/tmp
        sleep 3

        #unzip the zip file from the waiting room to the temporary folder
        unzip "/Library/Application Support/JAMF/Waiting Room/$adobe_package_zip" -d /tmp/tmp/
        echo $adobe_package_zip

        #remove zip and cache from the waiting room
        rm "/Library/Application Support/JAMF/Waiting Room/$adobe_package_zip"
        rm "/Library/Application Support/JAMF/Waiting Room/$adobe_package_cache_xml"


        #find name of package in the download subdirectory of JAMF folder after the package has been cached
        adobe_package_full_path=$(sudo ls "/tmp/tmp" | grep "Adobe Acrobat DC")
        #adobe_package_full_path="\"/tmp/tmp/$adobe_package_zip\"" 

        echo $adobe_package_full_path
        
        echo "downloading package"
      
        installer -package "/tmp/tmp/$adobe_package_full_path" -target /
        sleep 5
        rm -R -f /tmp/tmp
fi

##############################################################################################################
#
#           Auto Patch installer script below
##############################################################################################################

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
echo "Getting the latest patch"
latest_patch=$(curl -L https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html | awk -F'><' '{for(i = 1; i < NF;i++){print $i}}' | grep update, | tail -n +2 | sed 's/span class="std std-ref">//g' | sed 's:</span::g' | head -n 1)
echo $latest_patch
has_windows=$(echo $latest_patch | grep Windows)

echo "checking to see if line has the word windows using control structure"

if [ -z "$has_windows" ] 
then
      echo "String did not contain windows, string = \"${has_windows}\"\n"
      echo "getting the correct full path to latest patch"
    url=https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/
    path=$(curl -L https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html | awk -F'"' '{for(i = 1; i < NF;i++){print $i}}' | grep continuous | tail -n +9 | head -n 1)
    url+=$path
    echo "URL path = $url"

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
    echo "installing package, pkg path = $PKG_path"
    sudo installer -pkg $PKG_path -target / 
	#remove the hidden folder and sleep to ensure everything executes accordingly
    cd / 
	sudo rm -R ~/Downloads/.tmp 
	sleep 5
    hdiutil detach $detachmentPath
else
    echo "No download, latest patch is windows only"
fi