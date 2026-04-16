#!/bin/bash

entries="\t Logout\n\t Reboot\n\t⏻ Shutdown\n\t Suspend"

selected=$(echo -e $entries | wofi --width 250 --height 249 --dmenu --height=25% --style ~/.config/wofi/themes/gruvbox-dark.css --hide_search=true --hide-scroll --cache-file /dev/null | awk '{print tolower($2)}')

case $selected in
logout)
	exec hyprctl dispatch exit NOW
	;;
suspend)
	exec systemctl suspend
	;;
reboot)
	exec systemctl reboot
	;;
shutdown)
	exec systemctl poweroff -i
	;;
esac
