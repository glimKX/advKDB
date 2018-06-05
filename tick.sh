#!/bin/bash
##########################################################
# Script to run TickerPlant processes from the template
# TickerPlant starts with 5010 port
###########################################################

###########################################################
# Function: err
# Description: log error message
###########################################################
err()
{
	local TEXT=${1}
	printf "ERROR: %s\n" "${TEXT}"
	return 1
}
###########################################################
# Function: log
# Description: log message
###########################################################
info()
{
	local TEXT=${1}
	printf "INFO: %s\n" "${TEXT}"
	return 0
}
###########################################################
# Function: printLines
# Description: print Double Lines
###########################################################
printLines()
{
	printf "=======================================\n"
	return 0
}
###########################################################
info "Initialising TickerPlant with predefined schemas"
nohup $q tick.q sym tplog -p 5010 -t 1000 > /dev/null 2>&1 &
sleep 2
if [[ ! -z $(ps -ef | grep 5010 | grep tick.q) ]]
then
	info "TickerPlant started on port 5010"
else
	err "TIckerPlant failed to start"	
fi
