#!/bin/bash

# Directory to store log files
LOG_DIR="$HOME/speedtest_logs"
mkdir -p "$LOG_DIR"

# Log file path
LOG_FILE="$LOG_DIR/global_speedtest_$(date '+%Y-%m-%d').csv"

# Create CSV header if file doesn't exist
if [ ! -f "$LOG_FILE" ]; then
    echo "Timestamp,Server Name,Server Country,Download (Mbps),Upload (Mbps),Ping (ms)" >> "$LOG_FILE"
fi

# List of country codes for global testing (add more as needed)
COUNTRIES=("US" "GB" "JP" "AU" "DE" "FR" "BR" "ZA" "IN" "CN")

# Perform speed tests
while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    # Choose a random country
    COUNTRY=${COUNTRIES[$RANDOM % ${#COUNTRIES[@]}]}

    # Get a list of servers in the selected country
    SERVERS=$(./speedtest --servers | grep $COUNTRY | awk '{print $1}')

    # Select a random server from the list
    SERVER=$(echo "$SERVERS" | shuf -n 1)

    # Run speed test using the selected server
    RESULT=$(./speedtest --server-id $SERVER --format=json)
    
    # Extract results
    SERVER_NAME=$(echo "$RESULT" | jq -r '.server.name')
    SERVER_COUNTRY=$(echo "$RESULT" | jq -r '.server.location.country')
    DOWNLOAD=$(echo "$RESULT" | jq -r '.download.bandwidth' | awk '{print $1/125000}')  # Convert to Mbps
    UPLOAD=$(echo "$RESULT" | jq -r '.upload.bandwidth' | awk '{print $1/125000}')    # Convert to Mbps
    PING=$(echo "$RESULT" | jq -r '.ping.latency')

    # Append results to CSV
    echo "$TIMESTAMP,$SERVER_NAME,$SERVER_COUNTRY,$DOWNLOAD,$UPLOAD,$PING" >> "$LOG_FILE"

    # Wait for 15 minutes before the next test (adjust as needed)
    # sleep 900
done
