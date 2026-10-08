#!/usr/bin/env bash
# Total FPV focus minutes over the last 3 days.

API_URL="https://ct.dmitrym.online/api/occurrences?activity=Focus%3A%20FPV"
DATA=$(curl -s "$API_URL")

if [ -z "$DATA" ] || [ "$DATA" = "null" ]; then
    echo "🚁 ?"
    exit 0
fi

THREE_DAYS_AGO=$(/bin/date -v-3d "+%Y-%m-%d")
TOTAL_MINUTES=$(echo "$DATA" | /opt/homebrew/bin/jq --arg cutoff "${THREE_DAYS_AGO}T00:00:00" \
    '[.events[] | select(.startTime >= $cutoff) | .durationMinutes] | add // 0')

echo "🚁 ${TOTAL_MINUTES}m"
