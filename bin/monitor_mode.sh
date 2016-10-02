#!/bin/bash

internal_monitor="eDP1"
external_monitor="DP1"

tmp_file=/tmp/monitor_mode.txt

if [ ! -f $tmp_file ]; then
	echo "EXTERNAL" > $tmp_file
fi

contents=$(cat $tmp_file)

if [ $contents == "INTERNAL" ]; then
	notify-send "MIRROR Monitor Mode"
	xrandr --output $internal_monitor --auto
	xrandr --output $external_monitor --auto --same-as $internal_monitor
	echo "MIRROR" > $tmp_file

elif [ $contents == "MIRROR" ]; then
	notify-send "EXTEND Monitor Mode"
	xrandr --output $internal_monitor --auto
	xrandr --output $external_monitor --auto --left-of $internal_monitor
	echo "EXTEND" > $tmp_file

elif [ $contents == "EXTEND" ]; then
	notify-send "EXTERNAL Monitor Mode"
	xrandr --output $internal_monitor --off
	xrandr --output $external_monitor --auto
	echo "EXTERNAL" > $tmp_file

else
	notify-send "INTERNAL Monitor Mode"
	xrandr --output $internal_monitor --auto
	xrandr --output $external_monitor --off
	echo "INTERNAL" > $tmp_file
fi

#Update background
sh ~/.fehbg




