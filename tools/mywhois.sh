#!/bin/bash

if [ "$#" -ne 2 ]; then 
	echo "You must enter exactly 2 arguments" 
	exit 1 
fi

IPs=$1
CO_NAME=$2

while read -r ip
do
	orgName=$(whois "$ip" | grep -i "OrgName" | cut -d ':' -f2)
	if echo "$orgName" | grep -i -q "$CO_NAME"; then
		echo "$ip"
	fi
done < $IPs
