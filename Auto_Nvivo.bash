



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

    echo "Application was not opened" >> $logFile

fi

pwd >> $logFile


#since the website does not allow for a direct download from it
# we must download the dmg file to current directory than mount dmg to volume folder
curl -L -O $NVivoDMG
#mounting dmg file
hdiutil attach NVivo.dmg  -noBrowse


echo "Moving application to /Applications/ " >> $logFile
#moving application to /Application/
sudo cp -R -p /Volumes/NVivo/NVivo.app /Applications/


#detaching
hdiutil detach /Volumes/NVivo

echo "Detaching from Volume mount point" >> $logFile


