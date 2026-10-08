#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pause Treadmill
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ⏸️
# @raycast.packageName Treadmill

exec /opt/homebrew/bin/uv run /Users/dmitry.markushevich/workspace/nursery/egofit-control/treadmill_pyftms.py pause
