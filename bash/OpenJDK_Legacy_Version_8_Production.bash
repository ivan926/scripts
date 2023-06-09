
################################################################
#DEPRECATED VERSION 8 NO LONGER BEING USED #####################                   
################################################################
#find current openJDK version to identify and possibly remove

#find the latest version of the app using web API
################################################################
#CHANGE THIS TO VERSION NUMBER YOU NEED
currentJDK_Version=8

################################################################

#Checking to see if they already have 8
################################################################
#CHANGE VERSION NUMBER AFTER GREP TO DESIRED
JDK=$(ls /Library/Java/JavaVirtualMachines | grep "temurin-8")

################################################################


# should I remove the application
if [ -z "$JDK" ]; then
    echo "User does not have Open JDK 8 installed"
else
    echo "User has Open JDK 8 installed"
fi


#I could just delete the full url and add a partial, i.e (https://github.com/adoptium/) but I wanted viewer of the script to see an example of the correct full url to GITHUB REPO
url=$(echo https://github.com/adoptium/temurin8-binaries/releases | awk -F 'temurin' '{print $1}') && append="temurin${currentJDK_Version}-binaries/releases/expanded_assets/jdk-" && url+=$append 

Repo_URL=("https://github.com/adoptium/temurin${currentJDK_Version}-binaries/releases")





#produces last file header for the url path

JDK_HEAD=$(curl -L $Repo_URL| awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep jdk | awk -F'/' '{for(i=1;i<NF;i++){print $i}}' | grep jdk | sed 's:%2B:+:g' | head -n 1)



#link to repo with pkgs
Repo_URL+="/expanded_assets/${JDK_HEAD}"



#Version 8 is not available for MAC M1 Silicon

    #creates URL link to direct pkg to download using curl for intel
    tempURL=$(curl -L $Repo_URL | awk -F'"' '{for(i=1;i<NF;i++){print $i}}' | grep mac | grep .pkg | grep x64 | head -n 1) && intel_pkg="github.com/${tempURL}"
    #Download package and install the package
    cd /tmp && curl -L -O $intel_pkg && JDK_NAME=$(ls /tmp | grep OpenJDK) && sudo installer -pkg $JDK_NAME -target /tmp && rm -R /tmp/$JDK_NAME



#debug
echo $intel_pkg



# verify that the package was installed and can be found at the correct path
VERIFY_JDK_NUM=$(ls /Library/Java/JavaVirtualMachines | grep "temurin-8" | awk -F'-' '{print $2}' | awk -F'.' '{print $1}')



echo $VERIFY_JDK_NUM

echo $currentJDK_Version

if [ $VERIFY_JDK_NUM -ne $currentJDK_Version ]; then

    printf "Install not sucessfull \nLatest version is still " 
else
    printf "Install was successful to version ${currentJDK_Version}\n"
    ls /Library/Java/JavaVirtualMachines/ | grep "temurin-${currentJDK_Version}" && printf "Printing working directory of Open JDK Lib \n"
    ls /Library/Java/JavaVirtualMachines/
   
fi