###############################################

# -Ivan Arriola
# 12.05.23
# Manual Policy
###############################################


#!/bin/bash

bambu_dmg=$(sudo ls "/Library/Application Support/JAMF/Waiting Room" | grep Bambu | head -n 1)

xml_dmg=$(sudo ls "/Library/Application Support/JAMF/Waiting Room" | grep Bambu | tail -n 1)

hdiutil attach "/Library/Application Support/JAMF/Waiting Room/$bambu_dmg"

rm "/Library/Application Support/JAMF/Waiting Room/$bambu_dmg"

rm "/Library/Application Support/JAMF/Waiting Room/$xml_dmg"

ls "/Library/Application Support/JAMF/Waiting Room"

cp -R "/Volumes/Bambu Studio/BambuStudio.app" /Applications/

#trying to ensure that app fully installs
sleep 2

hdiutil detach "/Volumes/Bambu Studio"

