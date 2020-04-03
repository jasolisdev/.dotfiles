#!/bin/sh

userresources=$HOME/.Xresources

[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

dbus-update-activation-environment --systemd DISPLAY

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

xrandr --dpi 192
exec i3
xset dpms 0 0 0 && xset s noblank && xset s off
