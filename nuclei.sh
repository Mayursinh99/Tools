#!/bin/bash

# Define the input file with target domains
TARGETS_FILE="targets.txt"

# Loop over each line in the targets file
while IFS= read -r target; do
    # Define the folder names for subfinder, httpx, and nuclei
    DOMAIN_FOLDER="${target}_results"
    SUBDOMAIN_FILE="${DOMAIN_FOLDER}/subdomains/${target}_subdomains.txt"
    LIVE_SUBDOMAINS_FILE="${DOMAIN_FOLDER}/httpx/${target}_live_subdomains.txt"
    NUCLEI_OUTPUT_FILE="${DOMAIN_FOLDER}/nuclei/${target}_nuclei_results.txt"
    
    # Create the directory structure for each target
    mkdir -p "${DOMAIN_FOLDER}/subdomains"
    mkdir -p "${DOMAIN_FOLDER}/httpx"
    mkdir -p "${DOMAIN_FOLDER}/nuclei"
    
    # Run Subfinder to get subdomains for the target and save them to the subdomain file
    echo "Running Subfinder on $target..."
    subfinder -d "$target" -o "$SUBDOMAIN_FILE"
    
    # Check if the subdomain file has been created
    if [[ -f "$SUBDOMAIN_FILE" && -s "$SUBDOMAIN_FILE" ]]; then
        # Run httpx to check the live status of subdomains
        echo "Running httpx on $target subdomains..."
        httpx -l "$SUBDOMAIN_FILE" -o "$LIVE_SUBDOMAINS_FILE"
        echo "Live subdomains for $target saved to $LIVE_SUBDOMAINS_FILE"
        
        # Check if the live subdomains file exists and has content
        if [[ -f "$LIVE_SUBDOMAINS_FILE" && -s "$LIVE_SUBDOMAINS_FILE" ]]; then
            # Run Nuclei on the live subdomains
            echo "Running Nuclei on live subdomains for $target..."
            nuclei -l "$LIVE_SUBDOMAINS_FILE" -o "$NUCLEI_OUTPUT_FILE"
            echo "Nuclei results for $target saved to $NUCLEI_OUTPUT_FILE"
        else
            echo "No live subdomains found for $target. Skipping Nuclei."
        fi
    else
        echo "No subdomains found for $target. Skipping httpx and Nuclei."
    fi
done < "$TARGETS_FILE"
