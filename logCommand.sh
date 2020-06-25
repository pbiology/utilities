#!/bin/bash

#########################################################
## Will take the last executed command and place it in ##
## the closest doCommands.sh file it can find.         ##
## If there are several in the closest folder, it will ##
## complain. Also one can directly specify which file  ##
## to print to.                                        ##
#########################################################

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$1" == "h" ] || [ "$1" == "-help" ]; then
    echo "Usage: logCommand.sh [optional: file to log to]"
    exit 0

elif ! [ -e $1 ]; then
    echo "File $1 does not exist"
    exit 0

elif [ -d "$1" ]; then
    echo "Please specify a file, not a folder"
    exit 0

elif [ -n "$1" ]; then #If file is specified, log to this
    echo $(!!) >> $1

else

    current_dir=$(pwd)
    #Recursive function to look for a doCommands file
    find_doCom()
    {
        current_dir=$1
	sub_dir=$(dirname $current_dir)

	if [[ $sub_dir == '/' ]]; then #doCommands.sh is not allowed at root
	    echo "No doCommands file found, please create one first, or specify one with the script"; exit 0
	fi

       	for f in $current_dir/do*.sh; do
	    if [ -e "$f" ]; then  #If doCommands file is found
		files+=( $f )
	    else
		find_doCom $sub_dir #Start over from new directory
	    fi
	done

	if [ ${#files[@]} -gt 1 ]; then
	    echo "Found multiple files in ${current_dir}/. Please specify which to use"
	    echo "Usage: logCommand.sh [optional: file to log to]"
	    exit 0
	
	else
	    echo "FOUND THIS GUY: ${files[0]}"
	    doComFile=${files[0]}; return
	fi
	    
	    #find_doCom $sub_dir #Start over from new directory
    }

    #Start looking for files in the current dir
    #echo "$(pwd)"
    find_doCom $(pwd)

fi
