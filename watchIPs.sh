#!/bin/bash

DOMAIN=$1
IPS_FILE="db/domains/$DOMAIN/ips.txt"

#*******Watch for new IPs*******
    # Comparing two files
NEW_IPS=$(cat "$IPS_FILE.tmp" | anew $IPS_FILE)

# Check if new IPs found 
if [ -n "$NEW_IPS" ]; then 
    echo "New IPs found:" 
    echo "$NEW_IPS"
    #./notification.sh "$NEW_IPS"
else 
    echo "No new assets found." 
fi