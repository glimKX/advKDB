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
printLines
info "Sourcing for q"
printLines
q=$(find ~ -name q | grep l32)
if [[ ! -z "$q" ]]
then 
	info "Found q app $q" 
	info "Initialising FeedHandler with predefined timer" 
	nohup $q feed.q :5010 -p 5020 -t 1000 > /dev/null 2>&1 &
	info "FeedHandler started on port 5020"
else
	err "q is missing"
	exit 1
fi
