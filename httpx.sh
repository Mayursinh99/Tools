#!/bin/bash

# Define the input file with target domains
TARGETS_FILE="targets.txt"

# Loop through each target domain in the targets file
while IFS= read -r target; do
    # Define the output subdomain file from subfinder
    SUBDOMAIN_FILE="${target}_subdomains.txt"
    
    # Define the output file for live subdomains from httpx
    LIVE_SUBDOMAINS_FILE="${target}_live_subdomains.txt"
    
    # Check if the subdomain file exists
    if [[ -f "$SUBDOMAIN_FILE" ]]; then
        # Run httpx on the subdomains file and save live subdomains to the output file
        httpx -l "$SUBDOMAIN_FILE" -o "$LIVE_SUBDOMAINS_FILE"
        # Print a message indicating the process is done
        echo "Live subdomains for $target saved to $LIVE_SUBDOMAINS_FILE"
    else
        echo "No subdomain file found for $target. Skipping httpx."
    fi
done < "$TARGETS_FILE"
