#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
LAST_WALLPAPER_FILE="/tmp/swww_last_wallpaper"

# Ensure swww daemon is running
if ! pgrep -x "swww-daemon" >/dev/null; then
  echo "Starting swww-daemon..."
  swww-daemon &
  sleep 1
fi

echo "Wallpaper directory: $WALLPAPER_DIR"
echo "Files in directory:"
ls -l "$WALLPAPER_DIR"

CURRENT_WALL=$(swww query | grep 'image:' | awk -F'image: ' '{print $2}')
echo "Current wallpaper: $CURRENT_WALL"

LAST_WALLPAPER=""
if [[ -f "$LAST_WALLPAPER_FILE" ]]; then
  LAST_WALLPAPER=$(cat "$LAST_WALLPAPER_FILE")
  echo "Last wallpaper: $LAST_WALLPAPER"
fi

mapfile -t ALL_WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) | sort)
echo "Found ${#ALL_WALLPAPERS[@]} wallpapers total"

AVAILABLE_WALLPAPERS=()
for wp in "${ALL_WALLPAPERS[@]}"; do
  if [[ "$wp" != "$CURRENT_WALL" && "$wp" != "$LAST_WALLPAPER" ]]; then
    AVAILABLE_WALLPAPERS+=("$wp")
  fi
done

if [[ ${#AVAILABLE_WALLPAPERS[@]} -eq 0 ]]; then
  echo "No available wallpapers after filtering, using all"
  AVAILABLE_WALLPAPERS=("${ALL_WALLPAPERS[@]}")
fi

WALLPAPER=$(printf '%s\n' "${AVAILABLE_WALLPAPERS[@]}" | shuf -n 1)

if [[ -z "$WALLPAPER" ]]; then
  echo "Error: No wallpaper selected!"
  exit 1
fi

echo "Setting wallpaper: $WALLPAPER"
echo "$WALLPAPER" >"$LAST_WALLPAPER_FILE"

swww img "$WALLPAPER" --transition-type any --transition-fps 60 --transition-duration 0.5
pywal-discord -t default
wal -i "$WALLPAPER" -n -e --saturate 0.5
