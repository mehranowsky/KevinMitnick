#!/bin/bash

while read ip
do
	orgName=$(whois $ip | grep -i "OrgName" | cut -d ':' -f2)
	if echo "$orgName" | grep -i -q 'ford'; then
		echo "$ip" >> ford_ip.txt
	fi
done < Assets/ips.txt
cat ford_ip.txt | sort -u > ford_ips.txt && rm ford_ip.txt
