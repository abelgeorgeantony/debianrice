#!/bin/bash

outstring=$(brightnessctl -l)
declare -a devices
for (( i=0; i<50 ; i++ ));
do
	devices[$i]=${outstring#*"Device '"}
	devices[$i]=${devices[$i]%%"' of"*}
	outstring=${outstring#*"Device '"}
	if [ $i -gt 0 ];
	then
		if [ ${devices[$i]} == ${devices[$i-1]} ];
		then
			unset devices[$i]
			break
		fi
	fi
done

i=0
declare -a scrlckdevices #array to store scrolllock device names only
for device in ${devices[@]}; 
do
	if [ ${device#*"::"} == "scrolllock" ];
	then
		scrlckdevices[$i]=$device
		#echo ${scrlckdevices[$i]}
		i=$i+1
	fi
	echo ${device}
done

scrlck_index=0
for device in ${scrlckdevices[@]};
do
	bright=$(brightnessctl get -d "${device}")
	if [ $bright == 0 ]
        then
                brightnessctl -d "${device}" set 1
		echo "Did the keyboard led turn-on/blink-for-a-second? y/n:"
		read lightconfirmation
		if [ "$lightconfirmation" == "y" ]
		then
      echo -e "Keyboard LED device confirmed!\nIf accidentally chose another device, stop this process and start another one!"
			break
		fi
  fi
  scrlck_index=$scrlck_index+1
done
keyboardled=${scrlckdevices[$scrlck_index]}
while [ 1 ]
do
	bright=$(brightnessctl get -d "${keyboardled}")
	if [ $bright == 0 ]
	then
		brightnessctl -d "${keyboardled}" set 1
	fi
  sleep 0.1
done
exit 0
