#!/bin/bash
# Pomodoro status from Emacs (org-pomodoro). Migrated from sketchybar org-clock.2s.sh.
V=$(/opt/homebrew/bin/emacsclient --eval "(jx/produce-pomodoro-string-for-menu-bar)" 2>/dev/null | sed 's/["()]//g')
echo "${V:+🍅 }${V:-🍅}"
