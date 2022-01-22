dir="~/.config/rofi"
uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi -theme $dir/powermenu.rasi"

# Options
shutdown="󰐥 shutdown"
reboot="󰦛 restart"
lock="󰌾 lock"
suspend="󰤄 sleep"
logout="󰍃 logout"

# Confirmation
confirm_exit() {
	rofi -dmenu\
		-i\
		-no-fixed-num-lines\
		-p "Are You Sure? : "\
		-theme $dir/confirm.rasi
}

# Message
msg() {
	rofi -theme "$dir/message.rasi" -e "Available Options  -  yes / y / no / n"
}

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
      exec ~/.bin/rofi/scripts/promptmenu.sh --yes-command "systemctl poweroff" --query "Poweroff?" & ;;
    $reboot)
      exec ~/.bin/rofi/scripts/promptmenu.sh --yes-command "systemctl reboot" --query "Reboot?" & ;;
    $lock)
      exec ~/.bin/i3/scripts/lock  ;;
    $suspend)
      exec ~/.bin/rofi/scripts/promptmenu.sh --yes-command "systemctl suspend" --query "Suspend?" & 
			mpc -q pause
			amixer set Master mute
			systemctl suspend
      ;;
    $logout)
      exec ~/.bin/rofi/scripts/promptmenu.sh --yes-command "i3-msg exit" & ;;
esac
