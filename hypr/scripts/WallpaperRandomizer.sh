#!/usr/bin/env bash

WALLPAPER_DIR="/home/batat/Pictures/Wallpapers/"
HYPRPAPER_CONFIG="$HOME/.config/hypr/hyprpaper.conf"

# Debug output
echo "Wallpaper directory: $WALLPAPER_DIR"
echo "Files in directory:"
ls -l "$WALLPAPER_DIR"

# Get current wallpaper (if any)
CURRENT_WALL=$(hyprctl hyprpaper listloaded 2>/dev/null | head -n 1 | awk -F "'" '{print $2}')
echo "Current wallpaper: $CURRENT_WALL"

# Get all suitable wallpapers
ALL_WALLPAPERS=($(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -print | sort))
echo "All suitable wallpapers:"
printf '%s\n' "${ALL_WALLPAPERS[@]}"

# Filter out current wallpaper if it exists
AVAILABLE_WALLPAPERS=()
for wp in "${ALL_WALLPAPERS[@]}"; do
  if [[ -z "$CURRENT_WALL" ]] || [[ "$(basename "$wp")" != "$(basename "$CURRENT_WALL")" ]]; then
    AVAILABLE_WALLPAPERS+=("$wp")
  fi
done

echo "Available wallpapers (excluding current):"
printf '%s\n' "${AVAILABLE_WALLPAPERS[@]}"

# Select random wallpaper if available
if [[ ${#AVAILABLE_WALLPAPERS[@]} -gt 0 ]]; then
  WALLPAPER=${AVAILABLE_WALLPAPERS[$RANDOM % ${#AVAILABLE_WALLPAPERS[@]}]}
  echo "Setting wallpaper: $WALLPAPER"

  # Apply wallpaper
  hyprctl hyprpaper preload "$WALLPAPER"
  for OUTPUT in $(hyprctl monitors | awk '/Monitor/ {print $2}'); do
    hyprctl hyprpaper wallpaper "$OUTPUT,$WALLPAPER"
  done
  hyprctl hyprpaper unload all
else
  echo "No suitable wallpapers found (all wallpapers are either current or not accessible)"
  exit 1
fi
