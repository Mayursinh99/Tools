#!/bin/bash

# Function to run httpx and save the results
run_httpx() {
    target=$1
    output_folder=$2

    echo "Running httpx on $target"
    httpx -u "$target" -silent > "$output_folder/httpx_results.txt"
    echo "Saved httpx results for $target to $output_folder/httpx_results.txt"
}

# Function to run dirb and save the results
run_dirb() {
    target=$1
    output_folder=$2

    echo "Running dirb on $target"
    dirb "$target" > "$output_folder/dirb_results.txt"
    echo "Saved dirb results for $target to $output_folder/dirb_results.txt"
}

# Check if targets file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <targets_file>"
    exit 1
fi

# Read the targets file
targets_file=$1

# Check if the file exists
if [ ! -f "$targets_file" ]; then
    echo "File $targets_file not found!"
    exit 1
fi

# Loop through each target in the targets file
while IFS= read -r target; do
    # Clean up the target string (remove any leading/trailing spaces)
    target=$(echo "$target" | xargs)

    # Skip empty lines or invalid lines
    if [ -z "$target" ]; then
        continue
    fi

    # Create an output folder for each target
    target_folder="results/$(echo $target | sed 's/[:\/]/_/g')"
    mkdir -p "$target_folder"

    # Run httpx and dirb for the current target
    run_httpx "$target" "$target_folder"
    run_dirb "$target" "$target_folder"

done < "$targets_file"

echo "All tools have finished running."
