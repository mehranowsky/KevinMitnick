#!/bin/bash

if [ "$#" -ne 2 ]; then 
	echo "You must enter exactly 2 arguments" 
	exit 1 
fi

IPs=$1
OUTPUT=$2
FILE_PATH="$OUTPUT/asn"

#Check if the ASN file already exists
if [ -f "$FILE_PATH.txt" ]; then	
	mv "$FILE_PATH.txt" "$FILE_PATH.tmp"
else
	touch "$FILE_PATH.tmp"
fi

get_asn(){ 
  IP=$1
  curl -s https://api.bgpview.io/ip/$IP | jq -r '.data.prefixes[] | {prefix: .prefix, ASN: .asn.asn}'
}

while read -r line
do
	get_asn $line | tee -a "$FILE_PATH.tmp"
done < "$IPs" && jq -r '.prefix' "$FILE_PATH.tmp" | sort -u > "$FILE_PATH.txt" && rm "$FILE_PATH.tmp"
