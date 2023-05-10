

#!/bin/bash

url="https://www.box.com/resources/downloads"

users=$(ls /Users)

echo "Attempting to close Box tools app if opened" 

for user_name in $users; do

    if [ -d "/Users/"$user_name"/Library/Application Support/Box/Box Edit" ]; 
    then
            echo $user_name
        
        rm -R -f "/Users/{$user_name}/Library/Application Support/Box"

        process_ID_S=($(ps -ax | grep Box | head -n 2 | awk '{print $1}'))

        num_of_process=${#process_ID_S[@]}

        echo $num_of_process

        if [ $num_of_process -gt 1 ]; then
          
          
          	 for ((i=0; i < $num_of_process;i++)); do 
				
               echo "Killing processes right now"
                
              kill -9 ${process_ID_S[$i]}
              if [ $i -eq 1 ]; then
              	echo "Breaking from for loop that was infinite"
              	break 
              fi

          	  done
        else
            echo "Did not find the processes"
          
        fi
      

    fi

done

cd /tmp

dmg=$(curl -L $url | awk -F'\"'  '  {for(i=1;i<NF;i++){print $i}}' | grep dmg | head -n 1 | sed 's:\\::g')

curl -O $dmg

hdiutil attach -noBrowse $dmg

#open both applications needed to run box edit tool box successfully

cp -Rp "/Volumes/Box Tools Installer" /Applications/

open -F "/Applications/Box Tools Installer/Install Box Tools.app/Contents/Resources/Box Local Com Server.app" && open -F "/Applications/Box Tools Installer/Install Box Tools.app/Contents/Resources/Box Edit.app"

sleep 3

hdiutil detach "/Volumes/Box Tools Installer"

dmg=$(ls /tmp | grep BoxToolsInstall)

rm $dmg && sudo rm -Rf "/Applications/Box Tools Installer"

