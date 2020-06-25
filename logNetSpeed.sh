#!/bin/bash

logfile=$1
app=$(find /usr/local/bin/ -name "speedtest_cli.py" 2> /dev/null)

date >> $logfile
echo "Server: Bahnhof AB (Stockholm, Sweden)" >> $logfile
python $app --server 5620 --simple >> $logfile
echo "" >> $logfile
