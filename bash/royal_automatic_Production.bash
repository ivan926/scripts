
#!/bin/bash

url="royalapps.com/ts/mac/download"
cd /tmp && dmg=$(curl -L $url | awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep dmg)


# Kill & remove Royal TSX if it is installed on the machine
	if [ -a "/Applications/Royal TSX.app" ]; then
        # Kill any open sessions of Royal TSX
        /bin/echo "Killing any open sessions of Royal TSX." 
	    osascript -e 'quit app "Royal TSX"'

        # Remove the previous version of Royal TSX
	    /bin/echo "Removing the previous version of Royal TSX."
	    rm -rf "/Applications/Royal TSX.app"
    fi

#To bypass EULA, a trick for is to change the format from DMG to UDTO
#with the .CDR extension you can still attach (mount the image) 

hdiutil convert -quiet $dmg -format UDTO -o bar
#some of the options below are probably not neccessary but they worked for the bypass so they were kept
hdiutil attach -quiet -noBrowse -noverify -noautoopen -mountpoint right_here bar.cdr

#permissions must be changed to copy software to applications folder
chmod u+x right_here

cd right_here  && cp -R Royal\ TSX.app /Applications

#sleep is given in case the copying takes longer than expected
cd .. && sleep 5 && rm bar.cdr

hdiutil detach right_here


