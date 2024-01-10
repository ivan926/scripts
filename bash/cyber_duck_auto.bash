#!/bin/bash


#####################
#
# -Ivan Arriola
# 12.7.23
#
#####################



url=$(curl -L "https://version.cyberduck.io/changelog.rss" | awk -F'"' '{for(i=1;i<NF;i++){  print $i    }}' | grep http | tail -n 1)

cd /tmp

curl -L -O $url

cyber_zip=$(ls | grep Cyber)

unzip $cyber_zip

rm $cyber_zip

cyber_duck=$(ls | grep Cyber)

cp -R /tmp/$cyber_duck /Applications

rm -R $cyber_duck

