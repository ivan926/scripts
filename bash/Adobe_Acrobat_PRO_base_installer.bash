#!/bin/bash

# checks to see if application is already installed on the computer
###############################################################################################

#get the names of the adobe zipped up package and cached XML
adobe_package_zip=$(sudo ls /Library/Application\ Support/JAMF/Waiting\ Room | grep "Adobe Acrobat" | grep -v cache)
adobe_package_cache_xml=$(sudo ls /Library/Application\ Support/JAMF/Waiting\ Room | grep "Adobe Acrobat" | tail -n 1)  




if [ -a "/Applications/Adobe Acrobat DC/Adobe Acrobat.app/" ] || [ -a "/Applications/Adobe Acrobat.app/" ];
then

        echo "Adobe already installed, removing cached adobe package"
           #remove zip and cache from the waiting room
        sudo rm "/Library/Application Support/JAMF/Waiting Room/$adobe_package_zip"
        sudo rm "/Library/Application Support/JAMF/Waiting Room/$adobe_package_cache_xml"
    else   
        #application does not currently exist

        #make directory to unzip the adobe package
        mkdir /tmp/tmp
        sleep 3

        #unzip the zip file from the waiting room to the temporary folder
        sudo unzip "/Library/Application Support/JAMF/Waiting Room/$adobe_package_zip" -d /tmp/tmp/
        echo $adobe_package_zip

        #remove zip and cache from the waiting room
        sudo rm "/Library/Application Support/JAMF/Waiting Room/$adobe_package_zip"
        sudo rm "/Library/Application Support/JAMF/Waiting Room/$adobe_package_cache_xml"


        #find name of package in the download subdirectory of JAMF folder after the package has been cached
        adobe_package_full_path=$(sudo ls "/tmp/tmp" | grep "Adobe Acrobat DC")
        #adobe_package_full_path="\"/tmp/tmp/$adobe_package_zip\"" 

        echo $adobe_package_full_path
        
        echo "downloading package"
      
        sudo installer -package "/tmp/tmp/$adobe_package_full_path" -target /
        sudo sleep 5
        sudo rm -R -f /tmp/tmp
fi

##############################################################################################################