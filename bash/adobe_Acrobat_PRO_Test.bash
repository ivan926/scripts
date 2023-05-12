

url="https://helpx.adobe.com/acrobat/kb/acrobat-dc-downloads.html"


cd /tmp && DMG=$(curl -L $url  | awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep trials | grep dmg | sort | head -n 1)

#mount dmg to volume folder and install package using installer command and detach DMG file
hdiutil attach $DMG && sudo installer -pkg /Volumes/Acrobat/Acrobat/Acrobat\ DC\ Installer.pkg -target /tmp && hdiutil detach /Volumes/Acrobat


