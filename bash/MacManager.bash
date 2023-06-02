#!/bin/bash


#read list of triggers and input into an array
input="/Users/iarriola/Downloads/trigger.txt"


IFS=$'\n'
for line in $(cat $input)
do
    trigger_list+=("$line")
   
done

#this will not be the trigger list but maybe we can use it to identify the application
#this is where we get the version number of each application
for app in "${trigger_list[@]}"
do
     var=$(mdls -name kMDItemVersion /Applications/"${app}" | awk -F'"' '{for(i=0;i<NF;i++){print $i}}' | tail -n 1)
     #echo $var
     version_number+=("$var")
    #  sudo jamf policy -event $value -verbose
done


#this is where we initiate the policy using the jamf trigger
for app in "${trigger_list[@]}"
do
    #   sudo jamf policy -event $app -verbose
   printf "%s\n" $app
  

done

i=0
#this is where we initiate the policy using the jamf trigger
for app in "${trigger_list[@]}"
do
    
    #   sudo jamf policy -event $app -verbose
   printf "%s\n" $app
   test=$( echo $app | grep Adobe)
   if [ ! -z  "$test" ]
   then
        printf " App %s version number is = " $test
        echo "(${version_number[i]} | cut -c1-8 )"
   fi
   unset test

    ((i=i+1))
done

unset i


#prints out version numbers
for num in "${version_number[@]}"
do

    printf "%s\n" $num

done

#clears current file and then appends latest application information
echo "Applications" > test.txt
for index in ${!trigger_list[*]}
do
    printf "${trigger_list[$index]} " >> test.txt   
   printf "Version: ${version_number[$index]} \n" >> test.txt
done

#paste <(printf "App Name: %s \n" ${trigger_list[@]}) <(printf " \tVersion Number: %s\n" ${version_number[@]})


