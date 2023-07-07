#!/bin/bash


#read list of triggers and input into an array
triggerList="/Users/iarriola/Downloads/trigger.txt"
appList="/Users/iarriola/Downloads/testApplist.txt"


#reading from trigger list
IFS=$'\n'
for line in $(cat $triggerList)
do
    trigger_list+=("$line")
   
done
# reading from app list
for line in $(cat $appList)
do
    app_list_Array+=("$line.app")
    echo $line
   
done


#this is where we get the version number of each application
date >> /Users/iarriola/Downloads/error.txt
for appName in "${app_list_Array[@]}"
do
     var=$(mdls -name kMDItemVersion "/Applications/${appName}" | awk -F'"' '{for(i=0;i<NF;i++){print $i}}' | tail -n 1)
     #echo $var
     version_number+=("$var")
     echo "app name is $appName = $var" | grep "could not find" >> "/Users/iarriola/Downloads/error.txt"
     echo "app name is $appName = $var"

    #  sudo jamf policy -event $value -verbose
done


#this is where we initiate the policy using the jamf trigger
#############################################################################################################
error_found=0

for trigger in "${trigger_list[@]}"
do
    trigger_result=$(sudo jamf policy -event $trigger -verbose | awk '{print $2 $3}' | tail -n 1)
   if [ $trigger_result == "Policyerror" ]
   then

        error_found=1
        date=$(date)
        printf "there is a policy error for app %s\n %s" $trigger $date >> "/Users/iarriola/Downloads/error.txt"

    else
        printf "policy for app %s was a success \n" $trigger 

    fi
  
  

done



result=$([[ $error_found == 1 ]] && echo "Error has been found check logs" || echo "No error found")

echo $result
#resetting error found variable not sure if neccessary
error_found=0

echo "############################################## END OF REPORT" >> "/Users/iarriola/Downloads/error.txt \n\n"
#############################################################################################################
#i=0
# #this is where we initiate the policy using the jamf trigger
# for app in "${trigger_list[@]}"
# do
    
#     #   sudo jamf policy -event $app -verbose
#    printf "%s\n" $app
#    test=$( echo $app | grep Adobe)
#    if [ ! -z  "$test" ]
#    then
#         printf " App %s version number is = " $test
#         echo "(${version_number[i]} | cut -c1-8 )"
#    fi
#    unset test

#     ((i=i+1))
# done

# unset i


#prints out version numbers
for num in "${version_number[@]}"
do

   # printf "%s\n" $num

done

# #clears current file and then appends latest application information
# echo "Applications" > test.txt
# for index in ${!trigger_list[*]}
# do
#     printf "${trigger_list[$index]} " >> test.txt   
#    printf "Version: ${version_number[$index]} \n" >> test.txt
# done

# #paste <(printf "App Name: %s \n" ${trigger_list[@]}) <(printf " \tVersion Number: %s\n" ${version_number[@]})


#check to see if applications are in the location they should be

IFS=$'\n'
# reading from app list
for line in $(cat $appList)
do
    app_list_Array+=("$line.app")
    echo $line

done


for appName in "${app_list_Array[@]}"
do


        if [ ! -d "/Applications/${appName}" ]; then
                prepend=$(date)

                echo "Path not found for ${appName}" >> ~/Downloads/applications_not_found_list_${prepend}.txt

        else
                echo "Application found"
        fi

done


