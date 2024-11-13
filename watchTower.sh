#!/bin/bash

DOMAIN="$1"
TMP_FILE="db/domains/$DOMAIN/tmp_subdomains.txt"
SUBS_FILE="db/domains/$DOMAIN/subdomains.txt"
NEW_SUBS="db/domains/$DOMAIN/new_subdomains.txt"

#Sorting new subdomains
sort -u "$NEW_SUBS.tmp" > "$NEW_SUBS"
# Comparing two files using process substitution
NEW_ASSETS=$(comm -23 <(sort "$NEW_SUBS") <(sort "$SUBS_FILE"))

# Check if new assets found 
if [ -n "$NEW_ASSETS" ]; then 
    echo "New assets found:" 
    echo "$NEW_ASSETS"
    echo "$NEW_ASSETS" > "$TMP_FILE"
    sort -u "$TMP_FILE" "$SUBS_FILE" > "$SUBS_FILE.tmp"
    #./notification.sh "$NEW_ASSETS"
    mv "$SUBS_FILE.tmp" "$SUBS_FILE" && rm "$TMP_FILE"
else 
    echo "No new assets found." 
fi
rm "$NEW_SUBS"