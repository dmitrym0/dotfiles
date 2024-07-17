#!/usr/bin/env bash --norc --noprofile

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Focus Next in Stack
# @raycast.mode silent

# Optional parameters:
# @raycast.icon /Users/denis.isidoro/Pictures/Icons/yabai_64.png
# @raycast.packageName Yabai

# Documentation:
# @raycast.description Focus Next in Stack
# @raycast.author Denis Isidoro
# @raycast.authorURL https://denisidoro.github.io

yabai() {
   /opt/homebrew/bin/yabai "$@"
}

yabai -m window --focus stack.next 2>/dev/null || yabai -m window --focus stack.first
