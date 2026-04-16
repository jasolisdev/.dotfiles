#!/bin/bash

# Battery notification script
# Sends a notification when battery is below 10% or when plugged in

# Set up environment for notifications (needed when called from udev)
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

BATTERY_PATH="/sys/class/power_supply/BAT0"
BATTERY_LEVEL=$(cat "$BATTERY_PATH/capacity" 2>/dev/null)
BATTERY_STATUS=$(cat "$BATTERY_PATH/status" 2>/dev/null)
STATUS_FILE="/tmp/battery_status_prev"

# Exit if battery info not available
if [ -z "$BATTERY_LEVEL" ]; then
  exit 0
fi

# Read previous status
PREV_STATUS=""
if [ -f "$STATUS_FILE" ]; then
  PREV_STATUS=$(cat "$STATUS_FILE")
fi

# Check if laptop was just plugged in
if [ "$PREV_STATUS" = "Discharging" ] && [ "$BATTERY_STATUS" = "Charging" ]; then
  notify-send -u normal "Charger Connected" "Battery: ${BATTERY_LEVEL}%\nStatus: Charging"
fi

# Check if battery is low and discharging
if [ "$BATTERY_LEVEL" -le 10 ] && [ "$BATTERY_STATUS" = "Discharging" ]; then
  notify-send -u critical "Battery Low" "Battery level is ${BATTERY_LEVEL}%\nPlease plug in your charger!"
fi

# Save current status for next run
echo "$BATTERY_STATUS" >"$STATUS_FILE"
