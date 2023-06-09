
############################################################
#Version 20 is also deprecated and is being replaced with
#automated version
#currently only version 17 is specifically being used as
#legacy JDK
############################################################
#find current openJDK version to identify and possibly remove

#find the latest version of the app using web API
currentJDK_Version=20

#Checking to see if they already have 20
JDK=$(ls /Library/Java/JavaVirtualMachines | grep "temurin-20")


# should I remove the application
if [ -z "$JDK" ]; then
    echo "User does not have Open JDK 20 installed"
else
    echo "User has Open JDK 20 installed"
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
    cd /tmp && curl -L -O $intel_pkg && JDK_NAME=$(ls /tmp | grep OpenJDK) && sudo installer -pkg $JDK_NAME -target /tmp && rm -R /tmp/$JDK_NAME
else
    #creates URL link to direct pkg to download using curl for M1
    tempURL=$(curl -L $Repo_URL | awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep mac | grep .pkg | grep aarch | head -n 1) && M1_pkg="github.com/${tempURL}"
    printf "This is a silicon chip"
    #Download package and install the package
    cd /tmp && curl -L -O $M1_pkg && JDK_NAME=$(ls /tmp | grep OpenJDK) && sudo installer -pkg $JDK_NAME -target /tmp && rm -R /tmp/$JDK_NAME
fi

#debug
echo $M1_pkg 
#debug
echo $intel_pkg



# verify that the package was installed and can be found at the correct path
VERIFY_JDK_NUM=$(ls /Library/Java/JavaVirtualMachines | grep "temurin-20" | awk -F'-' '{print $2}' | awk -F'.' '{print $1}') 

echo $VERIFY_JDK_NUM

if [ $VERIFY_JDK_NUM -ne $currentJDK_Version ]; then

    printf "Install not sucessfull \nLatest version is still " 
else
    printf "Install was successful to version ${currentJDK_Version}\n"
    ls /Library/Java/JavaVirtualMachines/ | grep "temurin-${currentJDK_Version}" && printf "Printing working directory of Open JDK Lib \n"
    ls /Library/Java/JavaVirtualMachines/
   
fi