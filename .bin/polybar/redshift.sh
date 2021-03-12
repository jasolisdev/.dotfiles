#!/bin/sh

case "$1" in
    --toggle)
        if [ "$(pgrep -x redshift)" ]; then
            pkill redshift
        else
            redshift-gtk &
        fi
        ;;
    *)
        if [ "$(pgrep -x redshift)" ]; then
            echo "󰌵"
        else
            echo "󰌶"
        fi
        ;;
esac
