#!/usr/bin/env bash --norc --noprofile

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Desk to Floor
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Desk

# Documentation:
# @raycast.description Lower the standing desk to its minimum height for floor sitting.

export PATH="/opt/homebrew/bin:$PATH"
/opt/homebrew/bin/python3.14 /Users/dmitry.markushevich/workspace/nursery/desk.py --floor
