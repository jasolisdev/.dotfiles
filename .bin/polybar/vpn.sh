#!/bin/bash

icon_enabled=""
icon_disabled="林"
status=`cyberghostvpn --status | grep "VPN connections found."`

if [ "$status" == "VPN connections found." ];
then
    echo "$icon_enabled"
else 
    echo "$icon_disabled"
fi
