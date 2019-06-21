#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

MONITORS=`xrandr --query | grep " connected" | cut -d " " -f 1 | sort`
CUSTOM=`find $DIR/custom -type f -printf "%P\n" | sed "s/.sh//" | sort`
LIST="$CUSTOM\n$MONITORS\n"

if [ -z $1 ]; then

	ROFI="rofi -dmenu -i -theme Arc-Dark -width 20 -lines `printf "$LIST" | wc -l`"
	SELECTED=`printf "$CUSTOM\n$MONITORS" | $ROFI -p "Monitor layout"`
	
elif [[ $LIST == *"$1"* ]]; then

	SELECTED="$1"

else

	echo "'$1' is not connected"
	exit

fi

if [ -z $SELECTED ]; then

	exit

elif [[ $CUSTOM == *"$SELECTED"* ]]; then

	$DIR/custom/$SELECTED.sh

else

	OUTPUT="xrandr"

	for M in $MONITORS; do

		if [[ $SELECTED == $M ]]; then
			RES=`xrandr --query | grep -A 1 $M | tail -n 1 | egrep -o "[0-9]+x[0-9]+"`
			OUTPUT="$OUTPUT --output $M --primary --mode $RES --pos 0x0 --rotate normal"
		else
			OUTPUT="$OUTPUT --output $M --off"
		fi

	done

	$OUTPUT
fi

$HOME/.config/bspwm/scripts/monitors.sh &
$HOME/.config/bspwm/scripts/polybar.sh &
$HOME/.screen/wallpaper/set.sh &