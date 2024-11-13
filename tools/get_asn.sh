#!/bin/bash

if [ "$#" -ne 2 ]; then 
	echo "You must enter exactly 2 arguments" 
	exit 1 
fi

IPs=$1
OUTPUT=$3
FILE_PATH="$OUTPUT/asn"

#Check if the ASN file already exists
if [ -f "asn.txt" ]; then	
	mv "$FILE_PATH.txt" "$FILE_PATH.tmp"
else
	touch "$FILE_PATH.tmp"
fi

get_asn(){ 
  IP=$1;
  curl -s https://api.bgpview.io/ip/$IP | jq -r '.data.prefixes[] | {prefix: .prefix, ASN: .asn.asn}'
}

while read line
do
	get_asn $line | tee -a "$FILE_PATH.tmp"
done < "$IPs" && sort -u "$FILE_PATH.tmp" > "$FILE_PATH.txt"
