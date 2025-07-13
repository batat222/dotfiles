#!/usr/bin/env bash

# Generate rofi colors from wal
"${HOME}/.config/waybar/scripts/power-menu/wal-to-rofi.sh"

# Now import the generated colors
dir="$HOME/.config/waybar/scripts/power-menu"
theme="style" # This will use colors from ~/.cache/wal/colors-rofi.rasi

[... rest of your script ...]

# Get Wal colors (for theming)
source "${HOME}/.cache/wal/colors.sh"

# CMDs
uptime="$(uptime -p | sed -e 's/up //g')"

# Icons (Nerd Font)
shutdown='󰐥'
reboot='󰜉'
lock='󰌾'
suspend='󰤄'
logout='󰍃'
powersave='󰾆'
balanced='󰾅'
performance='󰓅'
yes='✓'
no='x'

# Rofi command
rofi_cmd() {
  rofi -dmenu \
    -p "Uptime: $uptime" \
    -mesg "Uptime: $uptime" \
    -theme ~/.config/waybar/scripts/power-menu/style.rasi
}

# Power mode selection
set_powermode() {
  case "$1" in
  "󰾆 PowerSave")
    sudo cpupower frequency-set -g powersave
    notify-send "Power Mode: Powersave"
    ;;
  "󰾅 Balanced")
    sudo cpupower frequency-set -g balanced
    notify-send "Power Mode: Balanced"
    ;;
  "󰓅 Performance")
    sudo cpupower frequency-set -g performance
    notify-send "Power Mode: Performance"
    ;;
  esac
}

# Confirmation dialog
confirm_cmd() {
  rofi -theme-str 'window {location: center; anchor: center; width: 350px;}' \
    -theme-str 'mainbox {children: [ "listview" ];}' \
    -theme-str 'listview {columns: 2; lines: 1;}' \
    -theme-str 'element-text {horizontal-align: 0.5;}' \
    -theme-str 'textbox {horizontal-align: 0.5;}' \
    -dmenu \
    -p 'Confirmation' \
    -theme ${dir}/${theme}.rasi
}

confirm_exit() {
  echo -e "$yes\n$no" | confirm_cmd
}

# Main menu
run_rofi() {
  echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown\n$powersave\n$balanced\n$performance" | rofi_cmd
}

# Execute command
run_cmd() {
  selected="$(confirm_exit)"
  if [[ "$selected" == "$yes" ]]; then
    if [[ $1 == '--shutdown' ]]; then
      systemctl poweroff
    elif [[ $1 == '--reboot' ]]; then
      systemctl reboot
    elif [[ $1 == '--suspend' ]]; then
      mpc -q pause
      amixer set Master mute
      systemctl suspend
    elif [[ $1 == '--logout' ]]; then
      if [[ "$DESKTOP_SESSION" == 'hyprland' ]]; then
        hyprctl dispatch exit
      elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
        i3-msg exit
      elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
        bspc quit
      fi
    fi
  else
    exit 0
  fi
}

# Handle selection
chosen="$(run_rofi)"
case ${chosen} in
$shutdown)
  run_cmd --shutdown
  ;;
$reboot)
  run_cmd --reboot
  ;;
$lock)
  if [[ -x '/usr/bin/betterlockscreen' ]]; then
    betterlockscreen -l
  elif [[ -x '/usr/bin/i3lock' ]]; then
    i3lock
  fi
  ;;
$suspend)
  run_cmd --suspend
  ;;
$logout)
  run_cmd --logout
  ;;
$powersave | $balanced | $performance)
  set_powermode "$chosen"
  ;;
esac
