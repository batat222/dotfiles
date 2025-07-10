#!/bin/bash

text=$(playerctl metadata --format '{{artist}} - {{title}}')
maxlength=35

# if the text is longer than the max length, truncate it and add "..."
if [ ${#text} -gt $maxlength ]; then
  text=${text:0:$maxlength-3}"..."
fi

tooltip=$(playerctl metadata --format '{{playerName}} : {{artist}} - {{title}}')

# Output properly escaped JSON
printf '{"text": "%s", "tooltip": "%s"}\n' "$text" "$tooltip"
