#!/bin/sh
# ~/.config/waybar/scripts/redshift-status.sh

STATUS=$(hyprshade current | grep blue-light-filter | tr -d ' ' | cut -d ':' -f2)

if [ "$STATUS" = "blue-light-filter" ]; then
  echo "󰔡 " # enabled
else
  echo "󰨙 " # disabled
fi
