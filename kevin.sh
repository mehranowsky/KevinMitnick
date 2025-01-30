#!/bin/bash

domain="$1"
if [ -z "$domain" ];then
    echo "There is no company domain!"
    exit 1
fi

RESOLVER="tools/tools_requirements/resolver.txt"
DNS_WORDLIST="tools/tools_requirements/sub_brute.txt"

NEW_SUBS="db/$domain/subs/new_subdomains.txt"
SUBS_FILE="db/$domain/subs/subdomains.txt"
NEW_IPS="db/$domain/ips/new_ips.txt"
IPS_FILE="db/$domain/ips/ips.txt"
CO_NAME=$(echo "$domain" | sed 's/\.[^.]*$//')
# Create directory for the domain
if [ ! -d "db/$domain" ]; then
mkdir db/"$domain"
mkdir db/"$domain"/subs
mkdir db/"$domain"/ips
fi
#*****Getting subdomains*****
# Subdomain enumerations  
echo -e "\e[31m************SubFinder***********\e[0m"
subfinder -d $domain -all -silent > "$NEW_SUBS"    
# shuffledns -d $domain -r $RESOLVER -w $DNS_WORDLIST -t 200 -mode bruteforce -silent | anew -q "$NEW_SUBS"
#Provider search
echo -e "\e[31m*************CRT.SH*************\e[0m"
curl -s "https://crt.sh?q=$domain&output=json" | jq -r ".[].common_name" | sed 's/^[*.]*//' | anew -q "$NEW_SUBS"
curl -s "https://crt.sh?q=$domain&output=json" | jq -r ".[].name_value" | sed 's/^[*.]*//' | anew -q "$NEW_SUBS"
echo -e "\e[31m*************Nuclei*************\e[0m"
tools/get_cert_nuclei.sh $domain | sed 's/^[*.]*//' | anew -q "$NEW_SUBS" 

# Check if it's the first recon or not
if [ -f "$SUBS_FILE" ]; then
./watchSubs.sh "$domain"
else
#Create the first main subs file
sort -u "$NEW_SUBS" > "$SUBS_FILE"        
fi
rm "$NEW_SUBS"

#*****Getting IPs*****
# Resolve and filter
echo -e "\e[31m***Resolve and filter CDN IPs****\e[0m"
cat "$SUBS_FILE" | dnsx -silent -resp-only -t 50 | sort -u | cut-cdn -silent > "$NEW_IPS.resolved"
tools/mywhois.sh "$NEW_IPS.resolved" $CO_NAME | sort -u > "$NEW_IPS" && rm "$NEW_IPS.resolved"
# Get ASN IPs
echo -e "\e[31m*************Get ASN IPs*************\e[0m"
tools/get_asn.sh "$NEW_IPS" | sort -u > "$NEW_IPS.asn"
# Getting IP range from ASN
while read -r ip; do
mapcidr -cidr -silent $ip | anew -q "$NEW_IPS"
done < "$NEW_IPS.asn" && rm "$NEW_IPS.asn"

# Check if it's the first recon or not
if [ -f "$IPS_FILE" ]; then
#Sorting new subdomains
./watchIPs.sh $domain
else
# Create the first main file
sort -u "$NEW_IPS" > "$IPS_FILE"        
fi
rm "$NEW_IPS"
