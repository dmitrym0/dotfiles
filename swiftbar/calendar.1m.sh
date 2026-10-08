#!/usr/bin/env bash

# Menu bar: next timed meeting today with a countdown until it starts.
# Dropdown: all of today's timed meetings, each with time left (or "in progress").
# "Next" = soonest event today whose END is still in the future. All-day events
# are skipped: icalBuddy prints them without a "HH:MM - HH:MM" prefix.

ICALBUDDY=/opt/homebrew/bin/icalBuddy
CALS="Dmitry Markushevich (VT),Dmitry's Calendar 123,Nikaxu"

GREEN="#8ec07c"  # >15m away
YELLOW="#fabd2f" # 5-15m
RED="#fb4934"    # <5m or in progress
GREY="#928374"   # already over

NOW=$(/bin/date "+%s")
TODAY=$(/bin/date "+%Y-%m-%d")

EVENTS=$($ICALBUDDY -nc -nrd -b "" -ic "$CALS" -ps "|@@|" \
         -iep "title,datetime" -po "datetime,title" -tf "%H:%M" eventsToday 2>/dev/null)

# countdown string + color for a given start/end pair.
fmt() {
    local start_epoch=$1 end_epoch=$2
    local diff=$(( start_epoch - NOW ))
    if [ "$end_epoch" -le "$NOW" ]; then
        echo "over|$GREY"; return
    fi
    if [ "$diff" -lt 60 ]; then
        echo "now|$RED"; return
    fi
    local mins=$(( diff / 60 )) label color
    if [ "$mins" -ge 60 ]; then
        label="$(( mins / 60 ))h$(( mins % 60 ))m"
    else
        label="${mins}m"
    fi
    if   [ "$diff" -le 300 ]; then color=$RED
    elif [ "$diff" -le 900 ]; then color=$YELLOW
    else color=$GREEN
    fi
    echo "${label}|${color}"
}

best_start=""
best_title=""
best_count=""
best_color=""
DROPDOWN=""

while IFS= read -r line; do
    # requires "start - end"; point events and midnight-crossing events skipped.
    [[ "$line" =~ ^([0-9]{2}:[0-9]{2})\ -\ ([0-9]{2}:[0-9]{2})@@(.*)$ ]] || continue
    start="${BASH_REMATCH[1]}"
    end="${BASH_REMATCH[2]}"
    title="${BASH_REMATCH[3]}"

    start_epoch=$(/bin/date -j -f "%Y-%m-%d %H:%M" "$TODAY $start" "+%s" 2>/dev/null) || continue
    end_epoch=$(/bin/date -j -f "%Y-%m-%d %H:%M" "$TODAY $end" "+%s" 2>/dev/null) || continue

    IFS='|' read -r count color <<< "$(fmt "$start_epoch" "$end_epoch")"
    DROPDOWN+="$(printf '%6s' "$count")  ${start}  ${title} | color=${color} font=Menlo"$'\n'

    [ "$end_epoch" -le "$NOW" ] && continue   # don't pick a finished meeting as "next"
    if [ -z "$best_start" ] || [ "$start_epoch" -lt "$best_start" ]; then
        best_start="$start_epoch"
        best_title="$title"
        best_count="$count"
        best_color="$color"
    fi
done <<< "$EVENTS"

# Menu bar.
if [ -z "$best_start" ]; then
    echo "📅"
else
    DISPLAY_TITLE="$best_title"
    [ "${#DISPLAY_TITLE}" -gt 25 ] && DISPLAY_TITLE="${DISPLAY_TITLE:0:24}…"
    echo "📅 ${DISPLAY_TITLE} · ${best_count} | color=${best_color}"
fi

echo "---"
if [ -n "$DROPDOWN" ]; then
    printf '%s' "$DROPDOWN"
else
    echo "No meetings today"
fi
