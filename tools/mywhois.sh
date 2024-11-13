#!/bin/bash

if [ "$#" -ne 3 ]; then 
	echo "You must enter exactly 3 arguments" 
	exit 1 
fi
IPs=$1
CO_NAME=$2
OUTPUT=$3
FILE_PATH="$OUTPUT/$CO_NAME-ips"
#Check if the ip file already exists
if [ -f "$FILE_PATH.txt" ]; then	
	mv "$FILE_PATH.txt" "$FILE_PATH.tmp"
else
	touch "$FILE_PATH.tmp"
fi

while read ip
do
	orgName=$(whois "$ip" | grep -i "OrgName" | cut -d ':' -f2)
	if echo "$orgName" | grep -i -q "$CO_NAME"; then
		echo "$ip" | tee -a "$FILE_PATH.tmp"
	fi
done < $IPs && sort -u "$FILE_PATH.tmp" >> "$FILE_PATH.txt" &&
rm "$FILE_PATH.tmp"
