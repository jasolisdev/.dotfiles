#!/bin/python

import urllib.request, json

city = "huntington beach"
api_key = "6165837fe4ac9e20213752dd0fba908e"
units = "metric"
unit_key = "C"

weather = eval(str(urllib.request.urlopen("http://api.openweathermap.org/data/2.5/weather?q={}&APPID={}&units={}".format(city, api_key, units)).read())[2:-1])

info = weather["weather"][0]["description"].capitalize()
temp = int(float(weather["main"]["temp"]))

print("%s, %i°%s" % (info, temp, unit_key))
# print("%i°%s" % (temp, unit_key))
