#!/bin/bash

# Input CSV file containing selected servers
SERVER_CSV="selected_servers.csv"
# Output CSV file to store speed test results
RESULT_CSV="speedtest_results.csv"

# Create the output CSV header
echo "Timestamp,Server Name,Country,Download (Mbps),Upload (Mbps),Ping (ms)" > "$RESULT_CSV"

# Function to perform speed test and log results
run_speed_test() {
    local url="$1"
    local server_name="$2"
    local country="$3"

    echo "Testing server: $server_name ($country) - $url"

    # Run speed test
    RESULT=$(./speedtest --server-id "$url" --format=json)

    # Extract results
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    DOWNLOAD=$(echo "$RESULT" | jq -r '.download.bandwidth' | awk '{print $1/125000}')  # Convert to Mbps
    UPLOAD=$(echo "$RESULT" | jq -r '.upload.bandwidth' | awk '{print $1/125000}')    # Convert to Mbps
    PING=$(echo "$RESULT" | jq -r '.ping.latency')

    # Log results to CSV
    echo "$TIMESTAMP,$server_name,$country,$DOWNLOAD,$UPLOAD,$PING" >> "$RESULT_CSV"
}

# Read selected servers from CSV and perform tests
echo "Reading selected servers from $SERVER_CSV..."
while IFS=, read -r url lat lon distance name country cc sponsor id preferred https_functional host; do
    # Skip the header
    if [[ "$url" == "url" ]]; then
        continue
    fi

    # Run speed test for each server
    run_speed_test "$id" "$name" "$country"
done < "$SERVER_CSV"

# Calculate and display statistics
echo "Calculating statistics..."
awk -F, '
    BEGIN { download_total = 0; upload_total = 0; ping_total = 0; count = 0 }
    NR > 1 {
        download_total += $4;
        upload_total += $5;
        ping_total += $6;
        count++;
    }
    END {
        print "Average Download Speed (Mbps):", (count > 0 ? download_total / count : 0);
        print "Average Upload Speed (Mbps):", (count > 0 ? upload_total / count : 0);
        print "Average Ping (ms):", (count > 0 ? ping_total / count : 0);
    }
' "$RESULT_CSV"
