#!/usr/bin/env bash
# Desk posture: % of today's active time spent standing / chair / floor.

GREEN="#8ec07c"
RED="#fb4934"

DATA=$(/opt/homebrew/bin/python3.14 "$HOME/workspace/nursery/desk.py" report --json 2>/dev/null)

if [ -z "$DATA" ] || [ "$DATA" = "null" ]; then
    echo "🧍 ?"
    exit 0
fi

read -r STANDING_S CHAIR_S FLOOR_S ACTIVE_S CURRENT < <(echo "$DATA" | /opt/homebrew/bin/jq -r '"\(.standing_s) \(.chair_s) \(.floor_s) \(.active_s) \(.current)"')

if [ "$ACTIVE_S" -eq 0 ]; then
    echo "🧍 ?"
    exit 0
fi

STAND_PCT=$(( STANDING_S * 100 / ACTIVE_S ))
CHAIR_PCT=$(( CHAIR_S * 100 / ACTIVE_S ))
FLOOR_PCT=$(( FLOOR_S * 100 / ACTIVE_S ))

if [ "$CHAIR_PCT" -gt 30 ]; then
    COLOR="$RED"
else
    COLOR="$GREEN"
fi

echo "🧍${STAND_PCT}% 🪑${CHAIR_PCT}% 🧎${FLOOR_PCT}% | color=${COLOR}"
echo "---"
echo "Standing ${STAND_PCT}% | color=${COLOR}"
echo "Chair ${CHAIR_PCT}% | color=${COLOR}"
echo "Floor ${FLOOR_PCT}% | color=${COLOR}"
echo "Currently: ${CURRENT}"
