#!/bin/bash
CONFIG_FILE="${HOME}/.config/hypr/hotkeys.conf"
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE" || echo "show_on_startup=true" >"$CONFIG_FILE"

# Toggle state
if [ "$show_on_startup" = "true" ]; then
  new_state="false"
  pkill -f "yad.*Hyprland Hotkeys"
else
  new_state="true"
fi

# Update config
echo "show_on_startup=$new_state" >"$CONFIG_FILE"

# Show notification
dunstify -a "Hotkeys" -i "keyboard" -h "string:x-dunst-stack-tag:hotkeys" \
  "Hotkeys Helper" "Hotkeys window is $([ "$new_state" = "true" ] && echo "ENABLED" || echo "DISABLED")"

# If enabling, show window
if [ "$new_state" = "true" ]; then
  ~/.config/hypr/scripts/yad_hotkeys.sh &
fi
