#!/bin/bash     

architecture=$(uname -m)
JSON_API_URL="https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release"


# Kill & remove JetBrains if it is installed on the machine
if [ -a /Applications/JetBrains\ Toolbox.app ]; then
	# Kill any open sessions of JetBrains
	osascript -e 'quit app "JetBrains\ Toolbox"'

    # Remove the previous version of JetBrains Toolbox
	rm -rf /Applications/JetBrains\ Toolbox.app
fi



if [ $architecture == "x86_64" ];
then
	JSON_DMG_PATH=$(curl -H "Accept: application/json" $JSON_API_URL |awk -F',' '{for(i=1;i<NF;i++){print $i}}' | grep mac | head -n 2 | awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep http | grep -v arm64 )
	sudo mkdir /tmp/temp
	sudo cd /tmp/temp
	sudo curl -L -O $JSON_DMG_PATH

	DMG=$(ls | grep jetbrains-toolbox)

	#mount and copy application to applications folder
	sudo hdiutil attach $DMG
	sudo cp -R /Volumes/JetBrains\ Toolbox/JetBrains\ Toolbox.app /Applications
	#remove folder and detach image from volume
	sudo rm -R /tmp/temp
	sudo hdiutil detach /Volumes/jetBrains\ Toolbox



	else
	echo "in else"
	JSON_ARM64_DMG_PATH=$(curl -H "Accept: application/json" $JSON_API_URL |awk -F',' '{for(i=1;i<NF;i++){print $i}}' | grep mac | head -n 2 | awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep http | grep arm64 )
	sudo mkdir /tmp/temp
	sudo cd /tmp/temp
	sudo curl -L -O $JSON_ARM64_DMG_PATH

	DMG=$(ls | grep jetbrains-toolbox)

	#mount and copy application to applications folder
	sudo hdiutil attach $DMG
	sudo cp -R /Volumes/JetBrains\ Toolbox/JetBrains\ Toolbox.app /Applications
	#remove folder and detach image from volume
	sudo rm -R /tmp/temp 
	sudo hdiutil detach /Volumes/jetBrains\ Toolbox

fi

