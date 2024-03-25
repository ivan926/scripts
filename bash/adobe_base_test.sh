#!/bin/bash

# checks to see if application is already installed on the computer and handles cached adobe package
#####################################################################################################

#change this whenever Matt Kiefer who is in charge of creating the adobe reader package changes it. 
#change this to whatever the latest version of this application (adobe) is when Matt Kiefer has made us aware of a new package he has created
#
latest_package_version="23.006.20360"

#####################################################################################################

echo "Current version number is ${latest_package_version}"

print "Starting policy for Adobe Acrobat Pro and Creative Cloud installer\n" >> "/var/log/adobe_pro.log"

#get the names of the adobe zipped up package and cached XML
adobe_package_zip=$(sudo ls /Library/Application\ Support/JAMF/Waiting\ Room | grep "Adobe Acrobat" | grep -v cache)
adobe_package_cache_xml=$(sudo ls /Library/Application\ Support/JAMF/Waiting\ Room | grep "Adobe Acrobat" | tail -n 1)  


if [ -a "/Applications/Adobe Acrobat DC/Adobe Acrobat.app/" ] || [ -a "/Applications/Adobe Acrobat.app/" ];
then

         print "Adobe already installed, checking to see if base installer needs to be changed" >> "/var/log/adobe_pro.log"

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

        if [ "$users_current_major_adobe_version" -le $latest_package_version ]
        then
            print "User has older or equal version of Adobe Acrobat Pro than the Adobe Acrobat Pro that Matt Kiefer modified" >> "/var/log/adobe_pro.log"            
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
			
            print "removing caches from waiting room" >> "/var/log/adobe_pro.log"
            #remove zip and cache from the waiting room
            rm "/Library/Application Support/JAMF/Waiting Room/$adobe_package_zip"
            rm -r "/Library/Application Support/JAMF/Waiting Room/$adobe_package_cache_xml"


            #find name of package in the download subdirectory of JAMF folder after the package has been cached
            adobe_package_full_path=$(sudo ls "/tmp/tmp" | grep "Adobe Acrobat DC")
            #adobe_package_full_path="\"/tmp/tmp/$adobe_package_zip\"" 

            print $adobe_package_full_path >> "/var/log/adobe_pro.log"
            
            print "downloading package" >> "/var/log/adobe_pro.log"
        
            installer -package "/tmp/tmp/$adobe_package_full_path" -target /
            sleep 5
            rm -R -f /tmp/tmp


        fi
        #end of package version verification
        
else   
        #application does not currently exist
        print "Application currently does not exist in the application folder" >> "/var/log/adobe_pro.log"
        #make directory to unzip the adobe package
        mkdir /tmp/tmp
        sleep 3

        #unzip the zip file from the waiting room to the temporary folder
        unzip "/Library/Application Support/JAMF/Waiting Room/$adobe_package_zip" -d /tmp/tmp/
        echo $adobe_package_zip

        print "Unzipping adobe package ${adobe_package_zip} " >> "/var/log/adobe_pro.log"

        #remove zip and cache from the waiting room
        rm "/Library/Application Support/JAMF/Waiting Room/$adobe_package_zip"
        rm "/Library/Application Support/JAMF/Waiting Room/$adobe_package_cache_xml"
        print "Removing caches from the waiting room" >> "/var/log/adobe_pro.log"

        #find name of package in the download subdirectory of JAMF folder after the package has been cached
        adobe_package_full_path=$(sudo ls "/tmp/tmp" | grep "Adobe Acrobat DC")
        #adobe_package_full_path="\"/tmp/tmp/$adobe_package_zip\"" 

        print "Creating path to adobe packege ${adobe_package_full_path}" >> "/var/log/adobe_pro.log"
        
        echo "downloading package"

        print "Beginning installation of Adobe package" >> "/var/log/adobe_pro.log"
        installer -package "/tmp/tmp/$adobe_package_full_path" -target /
        sleep 5
  
fi