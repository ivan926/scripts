#!/bin/bash

website=https://www1.kramerav.com/us/product/via%20campus%C2%B2#Tab_Resources

url=$(curl -L $website | awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep mac | tail -n +2 | head -n 1)

cd /tmp && zip=$(echo $url | awk -F'/' '{print $7}')  && curl -o $zip $url && unzip $zip && rm $zip && hdiutil convert VIASetup.dmg -format UDTO -o VIAsetup.cdr && rm VIAsetup.dmg

hdiutil attach VIAsetup.cdr && cp -R /Volumes/VIASetup/VIA.app /Applications/ &&  hdiutil detach /Volumes/VIASetup && rm VIAsetup.cdr 