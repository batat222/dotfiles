#!/bin/bash

[ -f /tmp/last_brightness ] || exit 1

# Read saved value and convert to percentage
CUR=$(brightnessctl get)
MAX=$(brightnessctl max)
LAST=$(cat /tmp/last_brightness)
LAST_PERC=$((LAST * 100 / MAX))

~/.config/hypr/scripts/fade.sh "$LAST_PERC" &

dunstify "Welcome back" "Glad to see you again"
