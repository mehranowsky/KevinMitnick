#!/bin/bash

existing_file="subdomains.txt"
new_file="new_subdomains.txt"

subfinder -d example.com -all > "$new_file"

# Comparing two files using process substitution
new_assets=$(comm -23 <(sort "$new_file") <(sort "$existing_file"))

# Check if new assets found 
if [ -n "$new_assets" ]; then 
    echo "New assets found: $new_assets" 
else 
    echo "No new assets found." 
fi