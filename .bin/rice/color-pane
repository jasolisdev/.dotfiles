#!/usr/bin/env bash
#
# This script is written by https://gitlab.com/YOUR-WORST-TACO
# source: https://gitlab.com/YOUR-WORST-TACO/dots/blob/hecate/bin/colorpane
#

# Define Color Variables
trap ctrl_c EXIT

# hide cursor
tput civis

function ctrl_c() {
	clear

    # Show cursor again 
    tput cnorm
}

initColors()
{
	esc=""

	f1="${esc}[30m";	f2="${esc}[31m";	f3="${esc}[32m"
	f4="${esc}[33m";	f5="${esc}[34m"; 	f6="${esc}[35m"
	f7="${esc}[36m"; 	f8="${esc}[37m"

	b1="${esc}[90m";	b2="${esc}[91m";	b3="${esc}[92m"
	b4="${esc}[93m";	b5="${esc}[94m"; 	b6="${esc}[95m"
	b7="${esc}[96m"; 	b8="${esc}[97m"

	bon="${esc}[22m";    boff="${esc}[22m"
	ion="${esc}[3m"; 	ioff="${esc}[23m"
	ulon="${esc}[4m";   uloff="${esc}[24m"
	invon="${esc}[7m";  invoff="${esc}[27m"

	reset="${esc}[0m"

	f=("" "${f1}" "${f2}" "${f3}" "${f4}" "${f5}" "${f6}" "${f7}" "${f8}")
	b=("" "${b1}" "${b2}" "${b3}" "${b4}" "${b5}" "${b6}" "${b7}" "${b8}")
}

initColors # Call initColors to generate color codes f1-f8/b1-b8

O_LINES=0
O_COLS=0

while true; do

	# Get Size of Current Terminal
	S_LINES=`(tput lines)` 		#AKA HEIGHT
	S_COLS=`(tput cols)` 		#AKA WIDTH

	if [ -n "$O_LINES" ] && [ -n "$O_COLS" ] && [ -n "$S_LINES" ] && [ -n "$S_COLS" ]; then 

		if [ "$O_LINES" -ne "$S_LINES" ] || [ "$O_COLS" -ne "$S_COLS" ]; then
			echo "${reset}"
			clear

			O_LINES=$S_LINES
			O_COLS=$S_COLS

			# Cacl Full Width
			F_WIDTH=`(expr $S_COLS - 7)`
			F_WIDTH=`(expr $F_WIDTH / 8)`

			# Calc Edge
			EDGE=`(expr $F_WIDTH / 4)`

			# Calc Partial Width
			P_WIDTH=`(expr $F_WIDTH - $EDGE)`

			# Calc Full Height
			F_HEIGHT=`expr $S_LINES - 4`

			# Calc Partial Height
			P_HEIGHT=`expr $F_HEIGHT - $EDGE`

			# Calc extra Padding
			PADDING=`expr $F_WIDTH \* 8`
			PADDING=`expr $PADDING + 7`

			PADDING=`expr $S_COLS - $PADDING`
			PADDING=`expr $PADDING / 2`

			PAD=""
			for i in `seq 1 $PADDING`; do
				PAD="$PAD "
			done

			# Character
			char=█
			spc=" "

			echo ""
			echo ""

			top=""
			middle=""
			bottom=""
			for i in `seq 1 3`; do
				for s in `seq 1 8`; do
					for w in `seq 1 $F_WIDTH`; do
						case "$i" in
							1)
								top="$top${f[$s]}"
								if [ $w -lt `expr $P_WIDTH + 1` ]; then
									top="$top$char"
								elif [ $w -lt `expr $F_WIDTH + 1` ]; then
									top="$top$spc"
								fi
							;;
							2)
								if [ $w -lt `expr $EDGE + 1` ]; then
									middle="$middle${reset}${f[$s]}$char"
								else
									middle="$middle${reset}${b[$s]}$char"
								fi
							;;
							3)
								if [ $w -gt $EDGE ]; then
									bottom="$bottom${b[$s]}$char"
								else
									bottom="$bottom$spc"
								fi
							;;
							*) echo ERROR!
						esac		
					done
					case "$i" in
						1)
						if [ $s -lt 8 ]; then # Create Spaces Between Panes
							top="$top$spc"
						fi
						;;
						2)
						if [ $s -lt 8 ]; then # Create Spaces Between Panes
							middle="$middle$spc"
						fi
						;;
						3)
						if [ $s -lt 8 ]; then # Create Spaces Between Panes
							bottom="$bottom$spc"
						fi
						;;
						*)

					esac	
				done
			done

			for i in `seq 1 $F_HEIGHT`; do
				if [ $i -lt `expr $EDGE + 1` ]; then # it is top
					echo "$PAD$top"
				elif [ `expr $i + 0` -gt $P_HEIGHT ]; then
					echo "$PAD$bottom"
				else
					echo "$PAD$middle"
				fi
			done

		fi
	fi

    read -t 0.25 -N 1 input
    if [ ! "$input" = "" ]; then
        exit 0
    fi
done
