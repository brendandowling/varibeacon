#!/bin/bash

PREAMBLE="1E 02 01 1A 1A FF 4C 00 02 15"

# random uuid formatted for hciconfig
UUID=$(uuidgen | sed -e 's/-//g' | tr 'a-f' 'A-F' | sed 's/\(..\)/\1 /g')

# or hard-coded.
#UUID="E2 0A 39 F4 73 F5 4B C4 A1 2F 17 D1 AD 07 A9 61"

# MAJOR and MINOR
MAJOR="00 00"
MINOR="00 00"

# Calibration value
CAL="C8 00"

let major=0
let minor=0

echo "Init"

hciconfig hci0 up
hciconfig hci0 noscan
hciconfig hci0 noleadv
#hciconfig hci0 leadv 3
#hcitool -i hci0 cmd 0x08 0x0006 A0 00 A0 00 03 00 00 00 00 00 00 00 00 00 07 00
#hcitool -i hci0 cmd 0x08 0x000a 01

hcitool -i hci0 cmd 0x08 0x0006 A0 00 A0 00 03 00 00 00 00 00 00 00 00 00 07 00

hcitool -i hci0 cmd 0x08 0x0006 A0 00 A0 00 03 00 00 00 00 00 00 00 00 00 07 00
# set advertise enable
hcitool -i hci0 cmd 0x08 0x000a 01



hcitool -i hci0 cmd 0x08 0x0008 $PREAMBLE $UUID $MAJOR $MINOR $CAL

echo "Init Complete"



while true 
do 
	let maj_h=$major/256
	let maj_l=$major%256

	MAJOR=$(printf "%02X %02X" $maj_h $maj_l)
	let min_h=$minor/256
	let min_l=$minor%256

	MINOR=$(printf "%02X %02X" $min_h $min_l)

	echo "pre:   $PREAMBLE"
	echo "uuid:  $UUID"
	echo "major: $MAJOR"
	echo "minor: $MINOR"
	echo "cal:   $CAL"

	echo "hcitool -i hci0 cmd 0x08 0x0008 $PREAMBLE $UUID $MAJOR $MINOR $CAL"
	hcitool -i hci0 cmd 0x08 0x0008 $PREAMBLE $UUID $MAJOR $MINOR $CAL

	# set advertise parameters. 
	# note A0 = 160 = 160*0.625us = 100ms, the fastest for non-connectable advertising.
	#hcitool -i hci0 cmd 0x08 0x0006 A0 00 A0 00 03 00 00 00 00 00 00 00 00 00 07 00
	# set advertise enable
	#hcitool -i hci0 cmd 0x08 0x000a 01

	#
	#sleep 0.125

	let major=major+1
	let minor=minor+1
done

