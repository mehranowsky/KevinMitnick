#!/bin/bash

DOMAIN="$1"
TMP_FILE="db/domains/$domain/tmp_subdomains.txt"
MAIN_FILE="db/domains/$DOMAIN/subdomains.txt"
NEW_FILE="db/domains/$DOMAIN/new_subdomains.txt"

# Comparing two files using process substitution
NEW_ASSETS=$(comm -23 <(sort "$NEW_FILE") <(sort "$MAIN_FILE"))

# Check if new assets found 
if [ -n "$NEW_ASSETS" ]; then 
    echo "New assets found:" 
    echo "$NEW_ASSETS"
    echo "$NEW_ASSETS" >> "$TMP_FILE"
    sort -u "$TMP_FILE" "$MAIN_FILE" > "$MAIN_FILE.tmp"
    mv "$MAIN_FILE.tmp" "$MAIN_FILE"
    ./notification.sh "$NEW_ASSETS"
else 
    echo "No new assets found." 
    sort -u "$NEW_FILE" "$MAIN_FILE" > "$MAIN_FILE.tmp"
    mv "$MAIN_FILE.tmp" "$MAIN_FILE"
fi