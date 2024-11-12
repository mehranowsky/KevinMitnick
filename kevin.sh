#!/bin/bash

if [ ! -s "domains.txt" ];then
    echo "There is no company domain!"
    exit 1
fi

RESOLVER="tools/tools_requirements/resolver.txt"
DNS_WORDLIST="tools/tools_requirements/sub_brute.txt"

while read -r domain; do

    TMP_FILE="db/domains/$domain/tmp_subdomains.txt"
    NEW_FILE="db/domains/$domain/new_subdomains.txt"
    MAIN_FILE="db/domains/$domain/subdomains.txt"
    CRT_FILE="db/domains/$domain/ssl_crt.txt"
    #Create directory for the domain
    if [ ! -d "db/domains/$domain" ]; then
        mkdir db/domains/$domain
    fi
    #*****Finding subdomains*****
        #Subdomain enumeration  
    subfinder -d $domain -all -silent > "$TMP_FILE"
    sublist3r -d $domain -o sublist.txt && cat sublist.txt >> "$TMP_FILE" && rm sublist.txt
        #DNS brute force
    shuffledns -d $domain -r $RESOLVER -w $DNS_WORDLIST -mode bruteforce >> "$TMP_FILE"
        #Provider search
    curl -s "https://crt.sh?q=$domain&output=json" | jq -r ".[].common_name" | sort -u > "$CRT_FILE.tmp"
    curl -s "https://crt.sh?q=$domain&output=json" | jq -r ".[].name_value" | sort -u >> "$CRT_FILE.tmp"
    get_cert_nuclei $domain >> "$CRT_FILE.tmp" && sort -u "$CRT_FILE.tmp" > "$CRT_FILE"
    

    #Check if it's the first recon or not
    if [ -f "$MAIN_FILE" ]; then
        #Sorting results to the main file
        sort -u "$TMP_FILE" > "$NEW_FILE"
        rm "$TMP_FILE"
        #WatchTower
        ./watchTower.sh "$domain"
    else
        #Create the first main file
        sort -u "$TMP_FILE" > "$MAIN_FILE"
        rm "$TMP_FILE"
    fi

done < domains.txt
