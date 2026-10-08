#!/usr/bin/env bash --norc --noprofile

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Desk to Stand
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Desk

# Documentation:
# @raycast.description Move the standing desk to standing height (1140mm).

export PATH="/opt/homebrew/bin:$PATH"
/opt/homebrew/bin/python3.14 /Users/dmitry.markushevich/workspace/nursery/desk.py --stand
