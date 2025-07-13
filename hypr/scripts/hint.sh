#!/bin/bash
# ~/.config/scripts/show-hotkeys.sh

SHOW_ON_STARTUP=true
HOTKEY_MD="$HOME/.config/hypr/hotkeys.md"
EWW_CONFIG="$HOME/.config/eww"
EWW_YUCK="$EWW_CONFIG/eww.yuck"
EWW_SCSS="$EWW_CONFIG/eww.scss"

# Exit if disabled
[ "$SHOW_ON_STARTUP" = false ] && exit 0

# Check if eww is installed
if ! command -v eww >/dev/null; then
  notify-send "Error" "eww (Elkowar's Wacky Widgets) is not installed!"
  exit 1
fi

# Create eww config directory if it doesn't exist
mkdir -p "$EWW_CONFIG"

# Generate eww configuration files
generate_eww_config() {
  # Generate YUCK file
  cat >"$EWW_YUCK" <<EOF
(defwindow hotkeys
  :monitor 0
  :geometry (geometry
    :width 700
    :height 700
    :x "50%"
    :y "50%"
    :anchor "center center")
  :stacking "overlay"
  :focusable true
  :reserve (struts :side "top" :distance 40)
  (box
    :orientation "vertical"
    :class "hotkeys-window"
    (markdown
      :content (include "$HOTKEY_MD")
      :class "hotkeys-content")))
EOF

  # Generate SCSS file
  cat >"$EWW_SCSS" <<'EOF'
.hotkeys-window {
  background-color: transparent;
  padding: 20px;
}

.hotkeys-content {
  background-color: rgba(30, 30, 46, 0.8);
  color: #cdd6f4;
  font-family: "Fira Code", monospace;
  padding: 20px;
  border-radius: 10px;
  border: 1px solid #585b70;
  box-shadow: 0 0 10px 0 rgba(0, 0, 0, 0.5);
  
  h1, h2, h3 {
    color: #89b4fa;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    margin: 1em 0;
  }

  th, td {
    border: 1px solid #585b70;
    padding: 8px;
  }

  th {
    background-color: #313244;
  }

  tr:nth-child(even) {
    background-color: rgba(49, 50, 68, 0.5);
  }

  code {
    background-color: #313244;
    color: #f5c2e7;
    padding: 2px 4px;
    border-radius: 3px;
  }
}
EOF
}

# Generate initial config
generate_eww_config

# Kill any existing eww daemon and windows
eww kill 2>/dev/null

# Start eww daemon
eww daemon

# Wait for daemon to start
sleep 0.5

# Open the window
eww open hotkeys

# Watch for changes and reload
while inotifywait -qe modify "$HOTKEY_MD"; do
  eww reload
done &
