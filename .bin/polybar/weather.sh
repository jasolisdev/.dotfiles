#!/bin/env bash

# Original source - https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/openweathermap-detailed

get_icon() {
    case $1 in
        01d) icon="";;
        01n) icon="";;
        02d) icon="";;
        02n) icon="";;
        03*) icon="";;
        04*) icon="";;
        09d) icon="";;
        09n) icon="";;
        10d) icon="";;
        10n) icon="";;
        11d) icon="";;
        11n) icon="";;
        13d) icon="";;
        13n) icon="";;
        50d) icon="";;
        50n) icon="";;
        *) icon="";
    esac

   # echo $ICON
}

# Global settings
KEY="6165837fe4ac9e20213752dd0fba908e"
CITY="Huntington Beach"
UNITS="metric"
SYMBOL="°C"
API="https://api.openweathermap.org/data/2.5"

# Get weather
WEATHER=$(curl -sf "$API/weather?APPID=$KEY&q=$CITY&units=$UNITS")

# Get condition, temp and icon
WEATHER_MAIN=$(echo $WEATHER | jq -r ".weather[0].main")
WEATHER_ICON=$(echo $WEATHER | jq -r ".weather[0].icon")
WEATHER_TEMP=$(echo $WEATHER | jq -r ".main.temp" | cut -d "." -f 1)

# Print weather
echo "$(get_icon $WEATHER_ICON)$WEATHER_MAIN $WEATHER_TEMP$SYMBOL "
