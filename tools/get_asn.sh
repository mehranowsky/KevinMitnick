#!/bin/bash

if [ "$#" -ne 1 ]; then 
	echo "You must enter exactly 1 arguments" 
	exit 1 
fi

IPs=$1

get_asn(){ 
  IP=$1
  curl -s https://api.bgpview.io/ip/$IP | jq -r '.data.prefixes[] | .prefix'
}

while read -r line
do
	get_asn $line | jq -r '.prefix'
done < "$IPs"
