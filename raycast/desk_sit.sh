#!/usr/bin/env bash --norc --noprofile

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Desk to Sit
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Desk

# Documentation:
# @raycast.description Move the standing desk to chair-sitting height (1080mm).

export PATH="/opt/homebrew/bin:$PATH"
/opt/homebrew/bin/python3.14 /Users/dmitry.markushevich/workspace/nursery/desk.py --sit
