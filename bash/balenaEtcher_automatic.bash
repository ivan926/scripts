#!/bin/bash

###########################
#
#
# Inspired by Anton Hinkleth
# - Ivan Arriola 12.12.23
#
#
############################

# Kill & remove balenaEtcher if it is installed on the machine
	if [ -a /Applications/balenaEtcher.app ]; then
        # Kill any open sessions of balenaEtcher
        /bin/echo "Killing any open sessions of balenaEtcher." >> ${logfile}
	    osascript -e 'quit app "balenaEtcher"'

        # Remove the previous version of balenaEtcher
	    /bin/echo "Removing the previous version of balenaEtcher." >> ${logfile}
	    rm -rf /Applications/balenaEtcher.app
    fi

cd /tmp

url=$(curl "https://formulae.brew.sh/cask/balenaetcher" | awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep http | grep dmg)

curl -O -L $url

dmg=$(ls | grep balena)

echo $dmg

hdiutil attach -noBrowse $dmg

rm $dmg

balena_volume=$(ls /Volumes | grep balenaEtcher)

cp -Rf "/Volumes/$balena_volume/balenaEtcher.app" /Applications/

echo "/Volumes/$balena_volume/balenaEtcher.app"

hdiutil detach "/Volumes/$balena_volume"
