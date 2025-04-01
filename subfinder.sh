#!/bin/bash

# Define the input file with target domains
TARGETS_FILE="targets.txt"

# Loop over each line in the targets file
while IFS= read -r target; do
    # Define output file based on the target
    OUTPUT_FILE="${target}_subdomains.txt"

    # Run subfinder for the target and save the results to a file
    subfinder -d "$target" -o "$OUTPUT_FILE"
    
    # Print the results
    echo "Subdomains for $target saved to $OUTPUT_FILE"
done < "$TARGETS_FILE"
