#!/bin/bash

PREAMBLE="1E 02 01 1A 1A FF 4C 00 02"
UUID="E2 0A 39 F4 73 F5 4B C4 A1 2F 17 D1 AD 07 A9 61"
CAL="C8 00"

let major=0
let minor=0

echo "Init"

hciconfig hci0 up
hciconfig hci0 leadv
hciconfig hci0 noscan
hcitool -i hci0 cmd 0x08 0x0006 A0 00 A0 00 03 00 00 00 00 00 00 00 00 00 07 00
hcitool -i hci0 cmd 0x08 0x000a 01

while true 
do 
	let maj_h=$major/256
	echo "maj_h $maj_h"
	let maj_l=$major%256

	MAJOR=$(printf "%02X %02X" $maj_l $maj_h)
	let min_h=$minor/256
	let min_l=$minor%256

	MINOR=$(printf "%02X %02X" $min_l $min_h)
	
	echo "$MAJOR $MINOR"


	hcitool -i hci0 cmd 0x08 0x0008 $UUID $MAJOR $MINOR $CAL


	sleep 0.1

	let major=major+1
	let minor=minor+1
done

