#!/bin/bash

if [ "$#" -lt 1 ]; then                       
    echo "Usage: processChecker.sh <PID1> <PID2> ..." 
    exit 2
else  
    echo "" #Make some space!

    spinstr='|/-\' #Array with markers for spinning wheel
    delay=1 #Time between checks
    args=("$@") #Array of all PIDS

    while kill -0 $(printf "%s " "${args[@]}") 2> /dev/null; do
	pos=0
	for i in ${args[@]}; do
	    if ! kill -0 $i 2> /dev/null ; then #Check if process still exists
		args=(${args[@]:0:$pos} ${args[@]:$(($pos + 1))}) #Remove element from array
		
		echo -ne "\r\033[K" #Clear the line
		current=$(date "+%F %H:%M:%S") #Get current time
		echo "PID $i finsihed/stopped @ $current"

	    else 
		((pos++)) #Position in array moves forward
    	    fi
	done
	temp=${spinstr#?}
	echo -ne "\r"
	printf "Process(es) $(printf "%s " "${args[@]}") still running [%c] " "$spinstr"
	
	spinstr=$temp${spinstr%"$temp"}
	sleep $delay
    done
    
    echo -ne "\r\033[K" #Clear the line

    for i in ${args[@]}; do #Report the last remainihng PID as well
	current=$(date "+%F %H:%M:%S") #Get current time
	echo "PID $i finsihed/stopped @ $current"
    done

    echo -e "\n\n* All processes done! *\n"
    exit 0
fi
