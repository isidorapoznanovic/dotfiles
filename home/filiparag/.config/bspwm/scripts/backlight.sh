#! /bin/bash

MAXVAL=$(cat /sys/class/backlight/intel_backlight/max_brightness)
CURVAL=$(cat /sys/class/backlight/intel_backlight/brightness)

STEP=$(expr $MAXVAL / 100)

ACTION=$1
USRVAL=$2

NEWVAL=$CURVAL

if [[ $ACTION == "=" ]]
then	
	NEWVAL=$(expr $STEP \* $USRVAL)
else
	NEWVAL=$(expr $CURVAL $ACTION $STEP \* $USRVAL)
fi

if [ $NEWVAL -gt $MAXVAL ]
then
	NEWVAL=$MAXVAL
elif [ $NEWVAL -lt 0 ]
then
	NEWVAL=0
fi

sudo su -c "echo $NEWVAL > /sys/class/backlight/intel_backlight/brightness"


