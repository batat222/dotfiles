#!/bin/bash
TARGET=$1 # target brightness value (0-100)
STEP=5
DELAY=0.01

CUR=$(brightnessctl get)
MAX=$(brightnessctl max)
CUR_PERC=$((CUR * 100 / MAX))
TGT=$TARGET

if [ "$CUR_PERC" -gt "$TGT" ]; then
  for ((i = CUR_PERC; i >= TGT; i -= STEP)); do
    brightnessctl set "${i}%"
    sleep $DELAY
  done
else
  for ((i = CUR_PERC; i <= TGT; i += STEP)); do
    brightnessctl set "${i}%"
    sleep $DELAY
  done
fi
