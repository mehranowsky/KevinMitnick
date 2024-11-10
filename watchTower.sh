#!/bin/bash

MAIN_FILE="subdomains.txt"
NEW_FILE="new_subdomains.txt"

# Comparing two files using process substitution
NEW_ASSETS=$(comm -23 <(sort "$NEW_FILE") <(sort "$MAIN_FILE"))

# Check if new assets found 
if [ -n "$NEW_ASSETS" ]; then 
    echo "New assets found: $NEW_ASSETS"
else 
    echo "No new assets found." 
fi

#Sorting files
cat "$NEW_FILE" >> 