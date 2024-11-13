#!/bin/bash

if [ ! -s "domains.txt" ];then
    echo "There is no company domain!"
    exit 1
fi

RESOLVER="tools/tools_requirements/resolver.txt"
DNS_WORDLIST="tools/tools_requirements/sub_brute.txt"

while read -r domain; do

    NEW_SUBS="db/domains/$domain/new_subdomains.txt"
    SUBS_FILE="db/domains/$domain/subdomains.txt"
    CRT_FILE="db/domains/$domain/ssl_crt.txt"
    IPS_FILE="db/domains/$domain/ips.txt"
    #Create directory for the domain
    if [ ! -d "db/domains/$domain" ]; then
        mkdir db/domains/$domain
    fi
    #*****Finding subdomains*****
        #Subdomain enumeration  
    subfinder -d $domain -all -silent > "$NEW_SUBS.tmp"
    sublist3r -d $domain -o sublist.txt && cat sublist.txt >> "$NEW_SUBS.tmp" && rm sublist.txt
        #DNS brute force
    shuffledns -d $domain -r $RESOLVER -w $DNS_WORDLIST -mode bruteforce >> "$NEW_SUBS.tmp"
        #Provider search
    curl -s "https://crt.sh?q=$domain&output=json" | jq -r ".[].common_name" | sort -u > "$CRT_FILE.tmp"
    curl -s "https://crt.sh?q=$domain&output=json" | jq -r ".[].name_value" | sort -u >> "$CRT_FILE.tmp"
    get_cert_nuclei $domain >> "$CRT_FILE.tmp" && sort -u "$CRT_FILE.tmp" > "$CRT_FILE" && rm "$CRT_FILE.tmp"
    
    #Check if it's the first recon or not
    if [ -f "$SUBS_FILE" ]; then
        ./watchTower.sh "$domain"
    else
        #Create the first main file
        sort -u "$NEW_SUBS.tmp" > "$SUBS_FILE"        
    fi
    rm "$NEW_SUBS.tmp"

    #*****Resolve and filter IPs*****
    cat "$SUBS_FILE" | dnsx -silent -resp-only | cut-cdn >> "$IPS_FILE.tmp"
    #Get ASNs
    #get_asn $domain | sort -u
    #mapcidr -cidr ? > "$IPS_FILE.tmp"


done < domains.txt
