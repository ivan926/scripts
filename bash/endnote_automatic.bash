#!/bin/zsh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	auto-installEndNoteX9Patch.sh -- Installs the latest patch for EndNote (but doesn't install the latest major version)
#
# SYNOPSIS
#	sudo sh auto-installEndNoteX9Patch.sh
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Griffin Holt, 10.08.2019
#
#   Version 2.0
#   - Ivan Arriola, 9.21.2023
#   Automated the base install
####################################################################################################
#Installing dmg directly from the Internet
#finding the latest major version
mkdir /tmp/endnote
cd /tmp/endnote
majorVersionNumber=$(curl -L $url | awk -F'"' '{for(i=1;i<NR;i++){print $i}}' | grep "for macOS" | awk -F'><' '{print $1}' | sed 's/<[^>]*>//g; s/[^.0123456789]*//g' | awk -F'.' '{print $1}' )
#
dmg="https://download.endnote.com/downloads/$majorVersionNumber/EndNote${majorVersionNumber}Installer.dmg"
#Downloading the dmg file from the internet
curl -o /tmp/endnote/endnote${majorVersionNumber}
#Mounting the DMG file
hdiutul attach -noBrowse endnote${majorVersionNumber}


# Script to download and install Endnote patches directly from the Internet

# Assign global variable for path of the log file that this script will write to
#parsing through page to find latest major version

logfile="/Library/Logs/EndNote$majorVersionNumber""InstallScript.log"

# Assignment of constant variables
updatePage='https://endnote.com/downloads/available-updates/'
#url for direct major version download and possible small update. 
#http://download.endnote.com/downloads/21/EndNote21Installer.dmg

# Begin writing to a log file
/bin/echo "--" >> ${logfile}

# Find the version number for EndNote
/bin/echo "Parsing through $updatePage in order to find the current version number of EndNote $majorVersionNumber." >> ${logfile}
versionNumber=$(curl $updatePage | grep 'for macOS' | sed 's/<[^>]*>//g; s/[^.0123456789]*//g')

minorVersion=${versionNumber#"$majorVersionNumber."}

if [ "$minorVersion" != '0' ] # Check to see if there are any patches
then # There is a patch

    # Kill any open sessions of EndNote
    /bin/echo "Killing any open sessions of EndNote $majorVersionNumber." >> ${logfile}
    osascript -e "quit app \"EndNote $majorVersionNumber\""

    # Download the latest version from the parsed url via 'curl'
    /bin/echo "`date`: Downloading the latest patch - EndNote $versionNumber." >> ${logfile}
    versionWithoutPeriod=$(echo $versionNumber | sed 's/\.//g')
    zipfile="EndNote$versionWithoutPeriod""UpdateInstaller.zip"
    downloadURL="http://download.endnote.com/updates/20.0/$zipfile" # IMPORTANT: This '19.0' directory may change with major updates
    /usr/bin/curl -s -o /tmp/$zipfile $downloadURL

    # Unzip the compressed .app and move it to /Applications
    /bin/echo "Unzipping the compressed folder for the patch." >> ${logfile}
    unzip /tmp/${zipfile} -d /tmp

    # Apply the patch
    /bin/echo "Applying the patch." >> ${logfile}
    unzippedFolderPath="/tmp/EndNote $versionNumber Update Installer"
    patchPath="$unzippedFolderPath/EndNote $versionNumber Updater.app/Contents/Resources"
    "$patchPath/applyPatch" -d /Applications/EndNote\ $majorVersionNumber -i "$patchPath/Patchfile.patch"

    # Remove the leftover zip file and the unzipped folder from the /tmp cache
    /bin/echo "Removing the .zip file and the unzipped folder from /tmp." >> ${logfile}
    rm -f /tmp/${zipfile}
    rm -rf "$unzippedFolderPath"

else # There is no patch
    /bin/echo "No patches are posted for EndNote $majorVersionNumber." >> ${logfile}
fi

	# Write final line to the log
    /bin/echo "Installation complete." >> ${logfile}
	
exit 0
