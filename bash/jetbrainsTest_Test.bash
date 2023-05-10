#!/bin/bash     


#The several statements below though they may seem uneccessary but in fact are
#vital in allowing the execution time needed for the most important
#commands to be applied, HDIUTIL detach for example looks like it needs time and a statment
#before the detach, as trivial as it may seem. 
#You are welcome to try to fix it if you deem it neccessary.

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

echo $URL

# ${v::${#v}-4}
#URL=$(echo $URL | awk '{print substr($0,1, length($0)-1)}')


open -j -g -u $URL

sleep 3
# close all tabs that were just opened
osascript -e 'tell application "firefox" to activate
tell application "System Events" to keystroke "w" using command down'
osascript -e 'tell application "Google Chrome"
	delete (every tab of every window where its title contains "Thank you for downloading the Toolbox App!")
end tell'

osascript -e 'tell application "Safari"
	delete (every tab of every window whose name = "Thank you for downloading the Toolbox App!")
end tell'



echo "Done trying to close all tabs that opened"


#give the curl command enough time to download the dmg file from website
sleep 5

#extract name of current DMG
DMG=$(ls ~/Downloads/ | grep jet | head -n 1)
echo $DMG



sleep 20


cd ~/Downloads/

xattr -d com.apple.quarantine $DMG
#debug prints
pwd
ls


#needs more time 
sleep 20
hdiutil attach -noBrowse $DMG

#must be within directory in order to copy to applications folder

cd /Volumes/"JetBrains Toolbox"
echo "Inside the volumes folder"
ls
sleep 5
#copy to app folder
echo "copying application to app folder"
ls
cp -R JetBrains\ Toolbox.app /Applications

#sudo cp -r -p /Volumes/JetBrains\ Toolbox/JetBrains\ Toolbox.app/ /Applications/
echo "attempting to remove dmg"
ls ~/Downloads
rm ~/Downloads/$DMG
ls ~/Downloads

sleep 60
cd /Volumes/
ls
hdiutil detach /Volumes/JetBrains\ Toolbox
ls









