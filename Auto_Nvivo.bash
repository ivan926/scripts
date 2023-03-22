#!/bin/bash

###############################################################################
# Version 1.0
# Ivan Arriola 3/22/23
#
#
###############################################################################







logFile="/Library/Logs/NVivo.log"
urlLink="https://techcenter.qsrinternational.com/Content/nm14/nm14_standard_installation.htm#Install"


 NVivoDMG=$(curl -L $urlLink | awk '{FS="\""}  {for(i=1;i<NF;i++){ print $i} }' | grep .dmg)



#echo "Attempting to find application if opened" >> $logFile

if [ -a "NVivo.app" ]; then

  sudo echo "Closing NVivo.app application" >> $logFile
    osascript -e 'quit app "NVivo.app"'
    echo "Exist appy exists somewhere maybe in the application folder"
   sudo rm -r -f /Applications/NVivo.app
    else

    echo "Application was not Found" >> $logFile

fi

#must go into directory that is not read only
cd tmp

echo "This is the current working directory" >> $logFile
pwd >> $logFile


#since the website does not allow for a direct download from it
# we must download the dmg file to current directory than mount dmg to volume folder
curl -L -O $NVivoDMG
#mounting dmg file
echo "Mounting dmg image to volume" >> $logFile
hdiutil attach NVivo.dmg -noBrowse


echo "Moving application to /Applications/ " >> $logFile
#moving application to /Application/
cp -R -p /Volumes/NVivo/NVivo.app /Applications/


#detaching
hdiutil detach /Volumes/NVivo

echo "Detaching from Volume mount point" >> $logFile

