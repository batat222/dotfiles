#!/bin/bash
# Load wal colors properly (even if script runs before wal)
if [ ! -f "${HOME}/.cache/wal/colors.sh" ]; then
  wal --theme base16-default-dark >/dev/null 2>&1
fi
source "${HOME}/.cache/wal/colors.sh"

# Generate proper RGBA colors for yad
hex_to_rgba() {
  hex=$(echo "$1" | sed 's/^#//')
  r=$(printf "%d" "0x${hex:0:2}")
  g=$(printf "%d" "0x${hex:2:2}")
  b=$(printf "%d" "0x${hex:4:2}")
  echo "rgba($r,$g,$b,0.85)"
}

BG=$(hex_to_rgba "$background")
FG=$(hex_to_rgba "$foreground")
ACCENT=$(hex_to_rgba "$color2")

CSS="
window {
    background-color: $BG;
    border-radius: 12px;
    border: 1px solid $ACCENT;
    padding: 15px;
    box-shadow: 0 0 10px rgba(0,0,0,0.5);
}

* {
    color: $FG;
    font-family: 'Fira Code', monospace;
    font-size: 11pt;
}

h1 { color: $(hex_to_rgba "$color4"); font-size: 1.3em; margin: 15px 0 10px 0; }
h2 { color: $(hex_to_rgba "$color4"); font-size: 1.1em; margin: 12px 0 8px 0; }
code { background-color: $(hex_to_rgba "$color0"); color: $(hex_to_rgba "$color3"); padding: 2px 4px; border-radius: 3px; }
strong { color: $(hex_to_rgba "$color5"); }
"

# Convert markdown to HTML
md_to_html() {
  pandoc -f markdown -t html5 "${HOME}/.config/hypr/hotkeys.md" |
    sed "s/<body>/<body style=\"padding:10px\">/"
}

# Only show if enabled
yad --html \
  --title="Hyprland Hotkeys" \
  --width=700 \
  --height=900 \
  --center \
  --undecorated \
  --no-buttons \
  --mouse \
  --skip-taskbar \
  --sticky \
  --css="$CSS" \
  <<<"$(md_to_html)" &
