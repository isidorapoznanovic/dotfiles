#! /bin/bash

WARN_LEVEL=20
CHECK_FREQ=30
NOTIFY_DELAY=10
NOTIFY_TIME=5
NOTIFY_TPREV=0


while true; do

	CURR_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
	CURR_STATUS=$(cat /sys/class/power_supply/BAT0/status)
	CURR_TIMEST=$(date +%s)

	if [ $CURR_LEVEL -le $WARN_LEVEL ] && \
	   [ $CURR_TIMEST -ge $(( $NOTIFY_TPREV + $NOTIFY_DELAY )) ] && \
	   [ $CURR_STATUS == "Discharging" ]; then

		NOTIFY_TPREV=$CURR_TIMEST
		notify-send -u critical -t $(( $NOTIFY_TIME * 1000 )) "WARNING: Low battery level"
		sleep $NOTIFY_DELAY

	else
		
		sleep $CHECK_FREQ

	fi

done