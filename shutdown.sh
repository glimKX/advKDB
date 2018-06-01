#!/bin/bash
##########################################################
# Script to stop all processes
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
printLines
info "Sourcing for running q"
printLines
runningQ=$(ps -ef | grep "5010"| grep -v grep)  
if [[ -z "$runningQ" ]]
then 
	info "No running q process found" 
	info "Shutdown not required"
	exit 0 
else
	info "Found running q processes"
	for PID in $(ps -ef | grep 5010 | grep -v grep | awk '{print $2}')
	do
		info "Shutting down [$PID]"
		ps -ef | grep -w $PID | head -1	
		kill $PID	
	done
	exit 0
fi
