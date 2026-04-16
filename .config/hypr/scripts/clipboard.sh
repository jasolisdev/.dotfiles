#!/usr/bin/env bash

icon_bell="$HOME/.local/bin/icons/notifications/bell-notification.png"
rofi_theme="$HOME/.config/rofi/config.rasi"

send_notify() {
	notify-send -r 72 -i "$icon_bell" "Clipboard cleared"
}

case "$1" in
show)
	cliphist list | rofi -dmenu -display-columns 2 -no-show-icons -theme "$rofi_theme" | cliphist decode | wl-copy
	;;
clean)
	cliphist wipe
	send_notify
	;;
esac
