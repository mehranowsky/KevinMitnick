#!/bin/bash

current_date=$(date +"%d")
while read domain; do
    #Create directory for the domain
    rm -rf db/domains/$domain
    mkdir db/domains/$domain
    temp_file="db/domains/$domain/pre_subdomains.txt"

    #*****Finding subdomains*****
        #Subdomain enumeration  
    subfinder -d $domain -all > "$temp_file"
    sublist3r -d $domain -o sublist.txt 
    cat sublist.txt >> "$temp_file" && rm sublist.txt
        #Certificate search

    #Sorting results
    if [ -f "subdomains_$current_date.txt" ]; then 
        rm subdomains_$current_date.txt
    fi
    cat "$temp_file" | sort -u > db/domains/$domain/subdomains_$current_date.txt
    rm "$temp_file"
done < domains.txt
