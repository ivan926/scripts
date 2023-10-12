
#!/bin/bash


#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	Automatic targeted install of Open JDK Temurin 
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Ivan Arriola 5/10/23
#
#
####################################################################################################

#find current openJDK version to identify and possibly remove

#find the latest version of the app using web API
currentJDK_Version=$(curl -X 'GET' 'https://api.adoptium.net//v3/info/available_releases' | python3 -c "import sys, json; print(json.load(sys.stdin)['available_lts_releases'])")  
currentJDK_Version=$(echo $currentJDK_Version | sed 's:[][]::g' | tail -c3)

#get users most current full name of JDK version
JDK=$(ls /Library/Java/JavaVirtualMachines | grep "temurin-*" | sort -V | tail -n 1)

#get the number of the users most current JDK version
JDK_NUM=$(ls /Library/Java/JavaVirtualMachines | grep "temurin-*" | sort -V | tail -n 1 | awk -F'-' '{print $2}' | awk -F'.' '{print $1}')

if [ -a "/Library/Java/JavaVirtualMachines/${JDK}" ]; then
    echo "The latest version of JDK for current user is ${JDK_NUM}"
else
    echo "User does not have OpenJDK version on their computer"
fi


#I could just delete the full url and add a partial, i.e (https://github.com/adoptium/) but I wanted viewer of the script to see an example of the correct full url ///// URL was found using developer tools and investigating network tab
url=$(echo https://github.com/adoptium/temurin20-binaries/releases | awk -F 'temurin' '{print $1}') && append="temurin${currentJDK_Version}-binaries/releases/expanded_assets/jdk-" && url+=$append 

Repo_URL=("https://github.com/adoptium/temurin${currentJDK_Version}-binaries/releases")

#produces last file header for the url path

JDK_HEAD=$(curl -L $Repo_URL| awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep jdk | awk -F'/' '{for(i=1;i<NF;i++){print $i}}' | grep jdk | sed 's:%2B:+:g' | head -n 1)


#link to repo with pkgs
Repo_URL+="/expanded_assets/${JDK_HEAD}"


#decide if the computer is intel or M1 chip

if [ $(uname -m) = "x86_64" ];
then
    #creates URL link to direct pkg to download using curl for intel
    tempURL=$(curl -L $Repo_URL | awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep mac | grep .pkg | grep x64 | head -n 1) && intel_pkg="github.com/${tempURL}"
    #Download package and install the package
    cd /tmp && curl -L -O $intel_pkg 
    JDK_NAME=$(ls /tmp | grep OpenJDK) 
    sudo installer -pkg $JDK_NAME -target /tmp 
    rm -R /tmp/$JDK_NAME
else
    #creates URL link to direct pkg to download using curl for M1
    tempURL=$(curl -L $Repo_URL | awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep mac | grep .pkg | grep aarch | head -n 1) && M1_pkg="github.com/${tempURL}"
    printf "This is a silicon chip"
    #Download package and install the package
    cd /tmp && curl -L -O $M1_pkg 
    JDK_NAME=$(ls /tmp | grep OpenJDK) && sudo installer -pkg $JDK_NAME -target /tmp
    rm -R /tmp/$JDK_NAME
fi

#debug
echo $M1_pkg 
#debug
echo $intel_pkg



# verify that the package was installed and can be found at the correct path
VERIFY_JDK_NUM=$(ls /Library/Java/JavaVirtualMachines | grep "temurin-*" | sort -V | tail -n 1 | awk -F'-' '{print $2}' | awk -F'.' '{print $1}')


#After downloading update current JDK 
JDK_NUM=$(ls /Library/Java/JavaVirtualMachines | grep "temurin-*" | sort -V | tail -n 1 | awk -F'-' '{print $2}' | awk -F'.' '{print $1}')

if [ $VERIFY_JDK_NUM -ne $currentJDK_Version ]; then

    printf "Install not sucessfull \nLatest version is still " 
    ls /Library/Java/JavaVirtualMachines/ | sort -V | tail -n 1 
else
    printf "Install was successful to version ${JDK_NUM}\n"
    ls /Library/Java/JavaVirtualMachines/ | grep "temurin-${JDK_NUM}"
   
fi
