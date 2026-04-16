#!/bin/sh
player_status=$(playerctl status 2>/dev/null)
if [ "$player_status" = "Playing" ]; then
	echo "$(playerctl -p spotify metadata artist) - $(playerctl -p spotify metadata title)"
elif [ "$player_status" = "Paused" ]; then
	echo "$(playerctl -p spotify metadata artist) - $(playerctl -p spotify metadata title)"
fi
