#!/bin/sh
# ~/.config/waybar/scripts/wlsun-status.sh
if pgrep -x wlsunset >/dev/null 2>&1; then
  printf "󰔡 " # on
else
  printf "󰨙 " # off
fi
