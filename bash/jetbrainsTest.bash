#!/bin/bash     




UNAME="(uname -m)"
INTEL_LINK="https://www.jetbrains.com/toolbox-app/download/download-thanks.html?platform=macM1"


# Kill & remove JetBrains if it is installed on the machine
if [ -a /Applications/JetBrains\ Toolbox.app ]; then
	# Kill any open sessions of JetBrains
	osascript -e 'quit app "JetBrains\ Toolbox"'

    # Remove the previous version of JetBrains Toolbox
	rm -rf /Applications/JetBrains\ Toolbox.app
fi
# logic to find intel download 
# curl -L https://www.jetbrains.com/toolbox-app/download/download-thanks.html\?platform=mac | awk '{FS="\""}   { for(i=1;i<NF;i++){ print $i} } ' | grep jetbrains | grep thanks | head -n 1



URL=$(curl -L $INTEL_LINK | awk '{FS="\""}   { for(i=1;i<NF;i++){ print $i} } ' | grep jetbrains | grep thanks | head -n 1)


# ${v::${#v}-4}
#URL=$(echo $URL | awk '{print substr($0,1, length($0)-1)}')


open -j -g -u $URL

#give the curl command enough time to download the dmg file from website
sleep 2

#extract name of current DMG
DMG=$(ls ~/Downloads/ | grep jet | head -n 1)

sleep 4


cd ~/Downloads/
ls ~/Downloads/


pwd
sleep 6
hdiutil attach -noBrowse $DMG

#must be within directory in order to copy to applications folder
cd /Volumes/JetBrains Toolbox
#copy to app folder
cp -R JetBrains\ Toolbox.app /Applications

#sudo cp -r -p /Volumes/JetBrains\ Toolbox/JetBrains\ Toolbox.app/ /Applications/

rm $DMG

shdiutil detach /Volumes/JetBrains\ Toolbox









