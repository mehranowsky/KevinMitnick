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
    DNS_B_RESULTS="db/domains/$domain/dns_brute_results.txt"
    IPS_FILE="db/domains/$domain/ips.txt"
    CO_NAME=$(echo "$domain" | sed 's/\.[^.]*$//')
    #Create directory for the domain
    if [ ! -d "db/domains/$domain" ]; then
        mkdir db/domains/$domain
    fi
    #*****Getting subdomains*****
        #Subdomain enumeration  
    subfinder -d $domain -all -silent > "$NEW_SUBS.tmp"
    sublist3r -d $domain -o sublist.txt && cat sublist.txt >> "$NEW_SUBS.tmp" && rm sublist.txt
        #DNS brute force
    shuffledns -d $domain -r $RESOLVER -w $DNS_WORDLIST -mode bruteforce -o "$DNS_B_RESULTS"
    cat "$DNS_B_RESULTS" >> "$NEW_SUBS.tmp"
        #Provider search
    curl -s "https://crt.sh?q=$domain&output=json" | jq -r ".[].common_name" | sed 's/^[*.]*//' >> "$NEW_SUBS.tmp"
    curl -s "https://crt.sh?q=$domain&output=json" | jq -r ".[].name_value" | sed 's/^[*.]*//' >> "$NEW_SUBS.tmp"
    tools/get_cert_nuclei.sh $domain | sed 's/^[*.]*//' >> "$NEW_SUBS.tmp" 

    #Check if it's the first recon or not
    if [ -f "$SUBS_FILE" ]; then
        #Sorting new subdomains
        sort -u "$NEW_SUBS.tmp" > "$NEW_SUBS"
        ./watchSubs.sh "$domain"
    else
        #Create the first main file
        sort -u "$NEW_SUBS.tmp" > "$SUBS_FILE"        
    fi
    rm "$NEW_SUBS.tmp"

    #*****Getting IPs*****
        #Resolve and filter
    cat "$SUBS_FILE" | dnsx -silent -resp-only | sort -u | cut-cdn >> "$IPS_FILE.resolved.tmp"
    tools/mywhois.sh "$IPS_FILE.resolved.tmp" $CO_NAME | sort -u > "$IPS_FILE.tmp" && rm "$IPS_FILE.resolved.tmp"
        #Get ASN IPs
    tools/get_asn.sh "$IPS_FILE.tmp" | sort -u > "$IPS_FILE.asn.tmp"
        #Getting IP range from ASN
    while read -r ip; do
        mapcidr -cidr $ip >> "$IPS_FILE.tmp"
    done < "$IPS_FILE.asn.tmp" && rm "$IPS_FILE.asn.tmp"

        #Check if it's the first recon or not
    if [ -f "$IPS_FILE" ]; then
        #Sorting new subdomains
        ./watchIPs.sh $domain
    else
        #Create the first main file
        sort -u "$IPS_FILE.tmp" > "$IPS_FILE"        
    fi
    rm "$IPS_FILE.tmp"

done < domains.txt
