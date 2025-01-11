#!/bin/bash

DOMAIN="$1"
SUBS_FILE="db/$DOMAIN/subs/subdomains.txt"
NEW_SUBS="db/$DOMAIN/subs/new_subdomains.txt"

#*******Watch for new subdomains*******
    # Comparing two files
NEW_ASSETS=$(cat "$NEW_SUBS" | anew "$SUBS_FILE")

# Check if new assets found 
if [ -n "$NEW_ASSETS" ]; then 
    #./notification.sh "$NEW_ASSETS"
else 
    echo "No new assets found." 
fi