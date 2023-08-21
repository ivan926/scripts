#!/bin/bash

###############################################################################
# ONLY EDIT THIS SECTION FOR UPDATES (Insert the new version number and zip name)

currentVersion="2023a"
zipName="R2023aUpdate5"

# DO NOT EDIT BELOW THIS LINE UNLESS THE SCRIPT IS BROKEN
###############################################################################


# Create tmp folder for install zip
mkdir /tmp/matlab$currentVersion
cd /tmp/matlab$currentVersion

# Unzip matlab zip
echo "Unzipping matlab in "
ls /Library/Application\ Support/JAMF/Waiting\ Room
unzip -o /Library/Application\ Support/JAMF/Waiting\ Room/$zipName.zip -d /tmp/matlab$currentVersion/


# Run the silent installation with all needed configurations
													#may need to be installer "InstallForMacOSX"
/bin/bash /tmp/matlab$currentVersion/$zipName/install -inputFile /tmp/matlab$currentVersion/$zipName/installer_input.txt

# Unzip the network.lic file
unzip -o /Library/Application\ Support/JAMF/Waiting\ Room/network.lic.zip -d /Library/Application\ Support/JAMF/Waiting\ Room

#Make the license file (Changed in 2020b)
mkdir /Applications/MATLAB_R$currentVersion.app/licenses

# Move the network.lic file into MATLAB.app/licenses
mv /Library/Application\ Support/JAMF/Waiting\ Room/network.lic /Applications/MATLAB_R$currentVersion.app/licenses

# Change the read & write permission of the network.lic file so that MATLAB can read it
chmod a+rwx /Applications/MATLAB_R$currentVersion.app/licenses/network.lic

# Remove the leftover files from the Waiting Room
rm -f /Library/Application\ Support/JAMF/Waiting\ Room/$zipName.zip
rm -f /Library/Application\ Support/JAMF/Waiting\ Room/$zipName.zip.cache.xml
rm -f /Library/Application\ Support/JAMF/Waiting\ Room/network.lic.zip
rm -f /Library/Application\ Support/JAMF/Waiting\ Room/network.lic.zip.cache.xml
rm -rf /Library/Application\ Support/JAMF/Waiting\ Room/__MACOSX
rm -rf /tmp/matlab$currentVersion