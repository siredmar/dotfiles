#!/bin/bash

usage() { (
	printf "`basename $0` rotates between two defined keyboard layouts on every call of the script\n"
	printf "Usage: `basename $0` layout1 layout2\n"
	printf "Where\n"
	printf "\tlayout1 - primary layout\n"
	printf "\tlayout2 - initial secondary layout\n"
	printf "Example:\n"
	printf "`basename $0` us de - switches between 'us' and 'de'\n"
)>&2 ; }



if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters. See --help."
    exit 1
fi

if [ "$1" == "--help" ]; then
    usage
    exit 0
fi

LAYOUTS=("$@")

CURRENT=$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}')

for layout in "${LAYOUTS[@]}"; do
  echo "$CURRENT -> $layout"
  if [ $CURRENT != $layout ]; then
    setxkbmap $layout
    echo $layout > /tmp/xkblayout
    exit 0
  fi
done


trap "pkill -P $$; exit" SIGINT
trap "pkill -P $$; exit" SIGTERM
trap "pkill -P $$; exit" EXIT
