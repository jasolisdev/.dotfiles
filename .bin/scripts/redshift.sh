#!/bin/sh

STATUS=$(hyprshade current | grep blue-light-filter | tr -d ' ' | cut -d ':' -f2)

if [ "$STATUS" = "blue-light-filter" ]; then
  echo "󰔡 "
else
  echo "󰨙 "
fi
