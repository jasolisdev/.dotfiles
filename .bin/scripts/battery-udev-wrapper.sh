#!/bin/bash
# Wrapper for udev to run battery-notify as user with proper environment

# Run as the user with their environment
su jose -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u jose)/bus /home/jose/.bin/scripts/battery-notify.sh"
