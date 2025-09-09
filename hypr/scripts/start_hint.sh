#!/bin/bash
# Get current toggle state
CONFIG_FILE="${HOME}/.config/hypr/hotkeys.conf"
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE" || echo "show_on_startup=true" >"$CONFIG_FILE"

if [ "$show_on_startup" = "true" ]; then
  sleep 2 # Wait for wal to load colors
  ~/.config/hypr/scripts/hint.sh
fi
