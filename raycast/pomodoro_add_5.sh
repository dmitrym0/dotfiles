#!/usr/bin/env bash --norc --noprofile

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pomodoro +5 min
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Pomodoro

# Documentation:
# @raycast.description Add 5 minutes to the running org-pomodoro.

/opt/homebrew/bin/emacsclient -e '(if (org-pomodoro-active-p)
    (setq org-pomodoro-end-time (time-add org-pomodoro-end-time (* 5 60)))
  (message "No active pomodoro"))'
