#!/bin/bash

while read domain; do

    TMP_FILE="db/domains/$domain/tmp_subdomains.txt"
    NEW_FILE="db/domains/$domain/new_subdomains.txt"
    #Create directory for the domain
    if [ ! -d "db/domains/$domain"]; then
        mkdir db/domains/$domain
    fi
    #*****Finding subdomains*****
        #Subdomain enumeration  
    subfinder -d $domain -all > "$TMP_FILE"
    sublist3r -d $domain -o sublist.txt 
    cat sublist.txt >> "$TMP_FILE" && rm sublist.txt
        #Certificate search

    #Sorting results
    cat "$TMP_FILE" | sort -u > "$NEW_FILE"
    rm "$TMP_FILE"
    #WatchTower
    ./watchTower.sh

done < domains.txt
