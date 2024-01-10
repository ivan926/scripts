#!/bin/bash

# Define two version numbers to compare
#version one is the old script
version1="23.006.20360"
#new package version number 
version2="23.006.20320"

# Split version numbers into arrays based on dot as a delimiter
IFS='.' read -ra v1_components <<< "$version1"
IFS='.' read -ra v2_components <<< "$version2"

# Compare each component
for i in "${!v1_components[@]}"; do
    if [ "${v1_components[i]}" -lt "${v2_components[i]}" ]; then
        echo "$version1 is less than $version2"
        exit 0
    elif [ "${v1_components[i]}" -gt "${v2_components[i]}" ]; then
        echo "$version1 is greater than $version2"
        exit 0
    fi
done

# If all components are equal, the versions are considered equal
echo "$version1 is equal to $version2"
