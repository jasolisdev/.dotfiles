#!/bin/bash
case "$3" in
    close)
        # Check if Hyprland is running (handled by its own bindl)
        if ! pgrep -x Hyprland > /dev/null; then
            # TTY: turn off display via DPMS
            setterm --blank force --term linux < /dev/tty1 > /dev/tty1
        fi
        ;;
    open)
        if ! pgrep -x Hyprland > /dev/null; then
            setterm --blank poke --term linux < /dev/tty1 > /dev/tty1
        fi
        ;;
esac
