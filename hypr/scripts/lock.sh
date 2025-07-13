#!/bin/bash
# Save current brightness
BRIGHTNESS=$(brightnessctl get)
echo "$BRIGHTNESS" >/tmp/last_brightness

# Dim screen smoothly
~/.config/hypr/scripts/fade.sh 0 &&
  # Lock screen
  hyprlock
