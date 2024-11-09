#!/bin/bash

source ~/.bashrc
get_asn(){ 
        IP=$1;
        curl -s https://api.bgpview.io/ip/$IP | jq -r '.data.prefixes[] | {prefix: .prefix, ASN: .asn.asn}'
}

while read line
do
	get_asn $line >> asn.txt
done < ips.txt
cat asn.txt | sort -u
