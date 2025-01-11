#!/bin/bash

DOMAIN=$1
NEW_IPS="db/$DOMAIN/ips/new_ips.txt"
IPS_FILE="db/$DOMAIN/ips/ips.txt"

#*******Watch for new IPs*******
    # Comparing two files
NEW=$(cat "$NEW_IPS" | anew $IPS_FILE)

# Check if new IPs found 
if [ -n "$NEW" ]; then 
    ./notification.sh "$NEW"
else 
    echo "No new assets found." 
fi