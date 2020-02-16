#!/bin/sh

userresources=$HOME/.Xresources

[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

xrandr --dpi 192
exec i3

xset dpms 0 0 0 && xset s noblank && xset s off
