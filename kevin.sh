#!/bin/bash

if [ ! -s "domains.txt" ];then
    echo "There is no company domain!"
    exit 1
fi

while read -r domain; do

    TMP_FILE="db/domains/$domain/tmp_subdomains.txt"
    NEW_FILE="db/domains/$domain/new_subdomains.txt"
    MAIN_FILE="db/domains/$domain/subdomains.txt"
    #Create directory for the domain
    if [ ! -d "db/domains/$domain" ]; then
        mkdir db/domains/$domain
    fi
    #*****Finding subdomains*****
        #Subdomain enumeration  
    subfinder -d $domain -all > "$TMP_FILE"
    sublist3r -d $domain -o sublist.txt 
    cat sublist.txt >> "$TMP_FILE" && rm sublist.txt
        #Certificate search

    #Check if it's first recon or not
    if [ -f "$MAIN_FILE" ]; then
        #Sorting results
        sort -u "$TMP_FILE" > "$NEW_FILE"
        rm "$TMP_FILE"
        #WatchTower
        ./watchTower.sh "$domain"
    else
        #Sorting results
        sort -u "$TMP_FILE" > "$MAIN_FILE"
        rm "$TMP_FILE"
    fi

done < domains.txt
