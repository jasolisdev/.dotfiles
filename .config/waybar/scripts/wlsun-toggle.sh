#!/bin/sh
# ~/.config/waybar/scripts/wlsun-toggle.sh
# Toggle wlsunset at ~4500K (correct value; 45000 is invalid).

if pgrep -x wlsunset >/dev/null 2>&1; then
  pkill -x wlsunset
else
  # start detached so Waybar doesn't hang
  nohup wlsunset -t 4500 -T 6500 -l 34.0 -L -118.2 >/dev/null 2>&1 &
fi
