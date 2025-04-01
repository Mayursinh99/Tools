#!/bin/bash

# Define the input file with target domains
TARGETS_FILE="targets.txt"

# Loop over each line in the targets file
while IFS= read -r target; do
    # Define output files for subdomains and live subdomains
    SUBDOMAIN_FILE="${target}_subdomains.txt"
    LIVE_SUBDOMAINS_FILE="${target}_live_subdomains.txt"
    
    # Run Subfinder to get subdomains for the target and save them to the subdomain file
    echo "Running Subfinder on $target..."
    subfinder -d "$target" -o "$SUBDOMAIN_FILE"
    
    # Check if the subdomain file has been created
    if [[ -f "$SUBDOMAIN_FILE" && -s "$SUBDOMAIN_FILE" ]]; then
        # Run httpx to check the live status of subdomains
        echo "Running httpx on $target subdomains..."
        httpx -l "$SUBDOMAIN_FILE" -o "$LIVE_SUBDOMAINS_FILE"
        echo "Live subdomains for $target saved to $LIVE_SUBDOMAINS_FILE"
    else
        echo "No subdomains found for $target. Skipping httpx."
    fi
done < "$TARGETS_FILE"
