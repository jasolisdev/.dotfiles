#!/usr/bin/env bash

icon_screenshot="$HOME/.local/bin/icons/notifications/screenshot.png"

case "$1" in
	area)
		slurp -b 00000080 -c 00000080 | grim -t jpeg -q 100 -g - - | wl-copy --type image/png
		# notify-send -r 999 -i "$icon_screenshot" "Screenshot copied to clipboard"
		;;
	window)
		active_window="$(hyprctl activewindow -j |  jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')"
		grim -g "$active_window" -t jpeg -q 100 - | wl-copy --type image/png
		# notify-send -r 999 -i "$icon_screenshot" "Screenshot copied to clipboard"
		;;
	screen)
		grim -t jpeg -q 100 - | wl-copy --type image/png
		# notify-send -r 999 -i "$icon_screenshot" "Screenshot copied to clipboard"
		;;
esac
