#!/bin/bash

DOMAIN="$1"
TMP_FILE="db/domains/$DOMAIN/tmp_subdomains.txt"
SUBS_FILE="db/domains/$DOMAIN/subdomains.txt"
NEW_SUBS="db/domains/$DOMAIN/new_subdomains.txt"

#*******Watch for new subdomains*******
    # Comparing two files
NEW_ASSETS=$(cat "$NEW_SUBS" | anew "$SUBS_FILE")

# Check if new assets found 
if [ -n "$NEW_ASSETS" ]; then 
    echo "New assets found:" 
    echo "$NEW_ASSETS"
    #./notification.sh "$NEW_ASSETS"
else 
    echo "No new assets found." 
fi
rm "$NEW_SUBS"