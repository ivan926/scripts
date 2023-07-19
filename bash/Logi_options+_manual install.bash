#! /bin/bash

####################################################################################
# MANUAL INSTALL
#7/19/23
#
####################################################################################

#current_version_number=$1
current_version_number="1.46.425296"

#once the logi Options package has been downloaded transfer the package to the tmp folder
sudo cp -Rf /Library/Application\ Support/JAMF/Waiting\ Room/Logi\ Options+\ Installer_${current_version_number}.pkg /tmp  

#installs the package, but the application becomes unwrapped in the /Users/ directory
sudo installer -pkg /tmp/Logi\ Options+\ Installer_${current_version_number}.pkg -target /tmp 

#run the executable with the arg of silent
sudo "/Users/logioptionsplus_installer.app/Contents/MacOS/logioptionsplus_installer" --quiet

#remove the package from the waiting room along with the XML cache
sudo rm -Rf /Library/Application\ Support/JAMF/Waiting\ Room/Logi\ Options+\ Installer_${current_version_number}.pkg
 sudo rm -Rf "/Library/Application Support/JAMF/Waiting Room/Logi Options+ Installer_${current_version_number}.pkg.cache.xml"

#remove the app from the user folder and the package from the tmp folder
sudo rm -Rf /Users/logioptionsplus_installer.app
sudo rm -Rf /tmp/Logi\ Options+\ Installer_${current_version_number}.pkg