#!/bin/bash

rofi_command="rofi"

### Options ###
screen="screen"
area="area/window"
# Variable passed to rofi
options="$screen\n$area"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 0)"
case $chosen in
    $screen)
        sleep 1; exec $HOME/.bin/screenshot
        ;;
    $area)
        exec $HOME/.bin/screenshot -s
        ;;
esac

