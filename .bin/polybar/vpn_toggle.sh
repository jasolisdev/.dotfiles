#!/bin/sh

case "$1" in
    --toggle)
        if [ "$(pgrep -x openvpn)" ]; then
            sudo cyberghostvpn --traffic --country-code US --city "Los Angeles" --server losangeles-s06-i12 --connect
        else
            sudo cyberghostvpn --stop
        fi
        ;;
    *)
        if [ "$(pgrep -x openvpn)" ]; then
            echo "🖧"
        else
            echo "off"
        fi
        ;;
esac
