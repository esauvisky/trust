#!/bin/bash

# Define input and output CSV files
INPUT_CSV="servers.csv"
OUTPUT_CSV="selected_servers.csv"
LOG_FILE="server_check_log.txt"

# List of major countries (add or modify as needed)
MAJOR_COUNTRIES=("US" "GB" "JP" "BR")

# Temporary files to store shuffled and filtered servers
SHUFFLED_FILE=$(mktemp)

# Shuffle the input CSV file (excluding the header)
echo "Shuffling the server list..."
head -n 1 "$INPUT_CSV" > "$SHUFFLED_FILE"  # Copy header to the shuffled file
tail -n +2 "$INPUT_CSV" | shuf >> "$SHUFFLED_FILE"  # Shuffle the rest and append

# Initialize log file
echo "Server Check Log - $(date)" > "$LOG_FILE"
echo "----------------------------------------" >> "$LOG_FILE"

# Declare an associative array to count selected servers per country
declare -A server_count

# Initialize server count for each major country to zero
for country in "${MAJOR_COUNTRIES[@]}"; do
    server_count["$country"]=0
done

# Filter for major countries and check if the servers are functional
echo "Filtering servers from major countries and checking functionality..."

# Use IFS to properly handle quoted fields with commas
while IFS=, read -r url lat lon distance name country cc sponsor id preferred https_functional host; do
    # Handle lines with embedded commas correctly
    # Use sed to remove potential carriage return characters for proper parsing
    url=$(echo "$url" | sed 's/\r//g')

    # Skip header
    if [[ "$url" == "url" && ! -f "$OUTPUT_CSV" ]]; then
        echo "$url,$lat,$lon,$distance,$name,$country,$cc,$sponsor,$id,$preferred,$https_functional,$host" > "$OUTPUT_CSV"
        continue
    fi

    # Check if the server is in a major country and if less than 2 servers have been selected for that country
    if [[ " ${MAJOR_COUNTRIES[*]} " == *" $cc "* ]] && [[ ${server_count["$cc"]} -lt 2 ]]; then
        # Check if the server is functional using speedtest binary with a short timeout
        CHECK_RESULT=$(./speedtest --server-id "$id" --format=json)

        if [[ $? -eq 0 ]]; then
            echo "$url,$lat,$lon,$distance,$name,$country,$cc,$sponsor,$id,$preferred,$https_functional,$host" >> "$OUTPUT_CSV"
            echo "SUCCESS: Server $id ($name, $country) is functional." | tee -a "$LOG_FILE"
            ((server_count["$cc"]++))  # Increment the counter for the selected country
        else
            echo "FAILURE: Server $id ($name, $country) is not functional." | tee -a "$LOG_FILE"
        fi
    fi
done < <(tail -n +2 "$SHUFFLED_FILE" | sed 's/\r//g' | awk -v FPAT='([^,]*)|("[^"]*")' '1')

# Clean up temporary files
rm "$SHUFFLED_FILE"

echo "Up to 2 random, functional servers per major country have been saved to $OUTPUT_CSV."
