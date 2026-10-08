#!/usr/bin/env bash
# Days since last logged Fitness workout.

API_URL="https://ct.dmitrym.online/api/occurrences?activity=Health%3A%20Fitness"
DATA=$(curl -s "$API_URL")

if [ -z "$DATA" ] || [ "$DATA" = "null" ]; then
    echo "🏋️ ?"
    exit 0
fi

LAST=$(echo "$DATA" | /opt/homebrew/bin/jq -r '.events | sort_by(.startTime) | last | .startTime // empty')
if [ -z "$LAST" ]; then
    echo "🏋️ ?"
    exit 0
fi

LAST_DATE=$(/bin/date -j -f "%Y-%m-%dT%H:%M:%S" "${LAST%%.*}" "+%Y-%m-%d" 2>/dev/null)
LAST_EPOCH=$(/bin/date -j -f "%Y-%m-%d" "$LAST_DATE" "+%s")
TODAY_EPOCH=$(/bin/date -j -f "%Y-%m-%d" "$(/bin/date "+%Y-%m-%d")" "+%s")
DAYS_SINCE=$(( (TODAY_EPOCH - LAST_EPOCH) / 86400 ))

if [ "$DAYS_SINCE" -le 1 ]; then COLOR="#8ec07c"
elif [ "$DAYS_SINCE" -le 3 ]; then COLOR="#fabd2f"
else COLOR="#fb4934"; fi

echo "🏋️ ${DAYS_SINCE}d | color=${COLOR}"
