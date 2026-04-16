#!/bin/bash

# Function to prompt user for display configuration
configure_display() {
	echo "Choose display configuration:"
	echo "1. Duplicate screens"
	echo "2. Extend screens"
	read -p "Enter your choice [1 or 2]: " choice
	case $choice in
	1) # Duplicate screens
		wlr-randr --output HDMI-A-1 --same-as eDP-1
		;;
	2) # Extend screens
		wlr-randr --output HDMI-A-1 --right-of eDP-1
		;;
	*) # Invalid choice
		echo "Invalid choice. Please enter 1 or 2."
		configure_display
		;;
	esac
}

# Check if HDMI cable is plugged in
HDMI_STATUS=$(cat /sys/class/drm/card1-HDMI-A-1/status)
if [ "$HDMI_STATUS" = "connected" ]; then
	# Prompt user for display configuration
	configure_display

	echo "HDMI connected. Display configured."
else
	echo "No monitor connected."
fi
