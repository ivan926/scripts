#!/bin/bash

url=https://my.splashtop.com/src/mac 

cd ~/Downloads && curl -L -o splashtopBusiness.dmg $url && hdiutil attach splashtopBusiness.dmg && sudo installer -pkg /Volumes/Splashtop\ Business/Splashtop\ Business.pkg -target /tmp

hdiutil detach /Volumes/Splashtop\ Business 