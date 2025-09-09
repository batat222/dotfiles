#!/usr/bin/env bash

whoami >/tmp/rofi-user.txt
id >>/tmp/rofi-user.txt
env >>/tmp/rofi-user.txt
# Generate Rofi colors from wal
[[ -x "${HOME}/.config/waybar/scripts/power-menu/wal-to-rofi.sh" ]] &&
  "${HOME}/.config/waybar/scripts/power-menu/wal-to-rofi.sh"

# Theme and script directory
dir="$HOME/.config/waybar/scripts/power-menu"
theme="${dir}/style.rasi"

# Import pywal colors
source "${HOME}/.cache/wal/colors.sh" 2>/dev/null

# Uptime info
uptime="$(uptime -p | sed -e 's/up //g')"

# Icons (Nerd Fonts)
shutdown='󰐥'
reboot='󰜉'
lock='󰌾'
suspend='󰤄'
logout='󰍃'
yes='✓'
no='x'

# Main rofi menu
rofi_cmd() {
  rofi -dmenu \
    -p "Uptime: $uptime" \
    -mesg "Uptime: $uptime" \
    -theme "$theme"
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
    -theme "$theme"
}

confirm_exit() {
  echo -e "$yes\n$no" | confirm_cmd
}

# Run main menu
run_rofi() {
  echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Handle command execution with confirmation
run_cmd() {
  selected="$(confirm_exit)"
  [[ -z "$selected" || "$selected" == "$no" ]] && exit 0

  case "$1" in
  --shutdown)
    systemctl poweroff
    ;;
  --reboot)
    systemctl reboot
    ;;
  --suspend)
    mpc -q pause
    amixer set Master mute
    systemctl suspend
    ;;
  --logout)
    case "$DESKTOP_SESSION" in
    hyprland) hyprctl dispatch exit ;;
    i3) i3-msg exit ;;
    bspwm) bspc quit ;;
    *) dunstify "Unsupported session: $DESKTOP_SESSION" ;;
    esac
    ;;
  esac
}

# Main logic
chosen="$(run_rofi)"
[[ -z "$chosen" ]] && exit 0

case "$chosen" in
$shutdown) run_cmd --shutdown ;;
$reboot) run_cmd --reboot ;;
$lock)
  if command -v hyprlock &>/dev/null; then
    hyprlock
  else
    dunstify "hyprlock not found"
  fi
  ;;
$suspend) run_cmd --suspend ;;
$logout) run_cmd --logout ;;
esac
