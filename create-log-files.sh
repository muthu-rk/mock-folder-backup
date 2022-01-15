#!/bin/bash

#set -uo pipefail
#IFS=$'\n\t'

while :
do
    # Create random filename of 10 char length
    filename=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 10)
    echo $filename

    fullpath="./logpath/$filename"
    echo $fullpath

    # Note: if this command fails, run GNU extensions
    dd if=/dev/urandom of=$fullpath bs=1K count=1
	
    echo "Press [CTRL+C] to stop.."
	sleep 1
done