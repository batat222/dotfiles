#!/bin/bash

WALLPAPER_DIR="/home/batat/Pictures/Wallpapers/"
HYPRPAPER_CONFIG="$HOME/.config/hypr/hyprpaper.conf"
LAST_WALLPAPER_FILE="/tmp/hyprpaper_last_wallpaper"

# Debug output
echo "Wallpaper directory: $WALLPAPER_DIR"
echo "Files in directory:"
ls -l "$WALLPAPER_DIR"

# Get current wallpaper (if any)
CURRENT_WALL=$(hyprctl hyprpaper listloaded 2>/dev/null | head -n 1 | awk -F "'" '{print $2}')
echo "Current wallpaper: $CURRENT_WALL"

# Get last set wallpaper (to prevent immediate repeats)
LAST_WALLPAPER=""
if [[ -f "$LAST_WALLPAPER_FILE" ]]; then
  LAST_WALLPAPER=$(cat "$LAST_WALLPAPER_FILE")
  echo "Last wallpaper: $LAST_WALLPAPER"
fi

# Get all suitable wallpapers
mapfile -t ALL_WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -print | sort)
echo "Found ${#ALL_WALLPAPERS[@]} wallpapers total"

# Filter out current and last wallpapers
AVAILABLE_WALLPAPERS=()
for wp in "${ALL_WALLPAPERS[@]}"; do
  wp_basename=$(basename "$wp")
  if [[ -z "$CURRENT_WALL" || "$wp" != "$CURRENT_WALL" ]] &&
    [[ -z "$LAST_WALLPAPER" || "$wp" != "$LAST_WALLPAPER" ]]; then
    AVAILABLE_WALLPAPERS+=("$wp")
  fi
done

echo "Available wallpapers (excluding current and last): ${#AVAILABLE_WALLPAPERS[@]}"

# If no wallpapers available after filtering, fall back to all wallpapers
if [[ ${#AVAILABLE_WALLPAPERS[@]} -eq 0 ]]; then
  echo "No available wallpapers after filtering, using all wallpapers"
  AVAILABLE_WALLPAPERS=("${ALL_WALLPAPERS[@]}")
fi

# Select random wallpaper using shuf for better randomness
WALLPAPER=$(printf '%s\n' "${AVAILABLE_WALLPAPERS[@]}" | shuf -n 1)

if [[ -z "$WALLPAPER" ]]; then
  echo "Error: No wallpaper selected!"
  exit 1
fi

echo "Setting wallpaper: $WALLPAPER"

# Remember this wallpaper for next time
echo "$WALLPAPER" >"$LAST_WALLPAPER_FILE"

# Apply wallpaper
hyprctl hyprpaper preload "$WALLPAPER"
for OUTPUT in $(hyprctl monitors | awk '/Monitor/ {print $2}'); do
  hyprctl hyprpaper wallpaper "$OUTPUT,$WALLPAPER"
done
hyprctl hyprpaper unload all
