#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	Automatic install of Applications using Homebrew
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Brenden Layton 2/1/2023
#
#	Scripts pulled from https://github.com/Honestpuck/homebrew.sh
#
####################################################################################################
#
# Pulls the Application to install from the script parameters
#
	item="$4"
#
####################################################################################################


#Check to make sure Homebrew is already installed
# Set the prefix based on the machine type
if [[ "$UNAME_MACHINE" == "arm64" ]]; then
    # M1/arm64 machines
    HOMEBREW_PREFIX="/opt/homebrew"
else
    # Intel machines
    HOMEBREW_PREFIX="/usr/local"
fi

if [[ -e "${HOMEBREW_PREFIX}/bin/brew" ]]; then
    su -l "$consoleuser" -c "${HOMEBREW_PREFIX}/bin/brew update"
else 
	jamf policy -event homebrew
fi


# check something set #
if [[ "$item" == "" ]]; then
echo "****  No item set! exiting ****"
exit 1
fi

UNAME_MACHINE="$(uname -m)"

ConsoleUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

# Check if the item is already installed. If not, install it

if [[ "$UNAME_MACHINE" == "arm64" ]]; then
    # M1/arm64 machines
    brew=/opt/homebrew/bin/brew
else
    # Intel machines
    brew=/usr/local/bin/brew
fi

cd /tmp/ # This is required to use sudo as another user or you get a getcwd error
if [[ $(sudo -H -iu ${ConsoleUser} ${brew} info ${item}) != *Not\ installed* ]]; then
	echo "${item} is installed already. Skipping installation"
else
	echo "${item} is either not installed or not available. Attempting installation..."
	sudo -H -iu ${ConsoleUser} ${brew} install ${item}
fi

sudo -H -iu ${ConsoleUser} ${brew} link ${item}

exit 0