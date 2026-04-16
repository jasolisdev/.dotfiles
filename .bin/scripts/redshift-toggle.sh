#!/bin/sh
# ~/.config/waybar/scripts/redshift-toggle.sh

STATUS=$(hyprshade current | grep blue-light-filter | tr -d ' ' | cut -d ':' -f2)

if [ "$STATUS" = "blue-light-filter" ]; then
  # Disable
  hyprshade disable blue-light-filter
else
  # Enable
  hyprshade enable blue-light-filter
fi
