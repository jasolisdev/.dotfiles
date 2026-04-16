#!/bin/bash
_getHeader "$name" "$author"

if gum confirm "Do you want to update the SDDM background image with the current wallpaper?"; then

	cache_file="$HOME/.cache/current_wallpaper"

	if [ ! -d /etc/sddm.conf.d/ ]; then
		sudo mkdir /etc/sddm.conf.d
		echo "Folder /etc/sddm.conf.d created."
	fi

	sudo cp ~/.config/sddm/sddm.conf /etc/sddm.conf.d/
	echo "File /etc/sddm.conf.d/sddm.conf updated."

	current_wallpaper=$(cat "$cache_file")
	extension="${current_wallpaper##*.}"

	sudo cp $current_wallpaper /usr/share/sddm/themes/chili/assets/current_wallpaper.$extension
	echo "Current wallpaper copied into /usr/share/sddm/themes/chili/assets/"
	new_wall=$(echo $current_wallpaper | sed "s|$HOME/.wallpaper/||g")
	sudo cp ~/.config/sddm/theme.conf /usr/share/sddm/themes/chili/

	sudo sed -i 's/CURRENTWALLPAPER/'"current_wallpaper.$extension"'/' /usr/share/sddm/themes/chili/theme.conf

	echo ""
	echo "SDDM background successfully updated!"
	sleep 2
fi
_goBack
