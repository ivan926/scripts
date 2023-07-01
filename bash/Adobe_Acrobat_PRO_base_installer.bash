
#!/bin/bash

# checks to see if application is already installed on the computer and handles cached adobe package
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

        
        #getting the major version for our current package made by Matt Kiefer
        casper_fs_package_version_num=$(echo $adobe_package_zip | awk '{print $4}' | awk -F'_' '{print $1}')
        echo $casper_fs_package_version_num

        if [ "$users_current_major_adobe_version" != "$casper_fs_package_version_num" ]
        then
            echo "must remove current adobe and install new adobe package"            
            echo "$users_current_major_adobe_version and $casper_fs_package_version_num"

            if [ -a "/Applications/Adobe Acrobat DC/Adobe Acrobat.app/" ]
            then
                sudo rm -Rf "/Applications/Adobe Acrobat DC"
                
            elif [ -a "/Applications/Adobe Acrobat.app" ] 
            then
                sudo rm -Rf "/Applications/Adobe Acrobat DC" 
            fi 

            #install new package
            #make directory to unzip the adobe package
            sudo mkdir /tmp/tmp
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


        else
            echo "Major versions are the same ${users_current_major_adobe_version} == ${casper_fs_package_version_num} carry on. "

        fi
        #end of package version verification
        
else   
        #application does not currently exist
        echo "Application does not exist installing with base"

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