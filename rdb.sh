#!/bin/bash
##########################################################
# Script to run both of the RDB processes from the template
# RDB 1 will only subscribe to trade and quote 
# RDB 2 will only subscribe to aggreg
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
#	if [ $# -eq 0 ]
#	then 
#		err "Missing Argument, choose which RDB to start"
#		exit 1
#	fi
#	if [[ $1 == "RDB1" ]]
#	then
		info "Initialising RDB1 and subscribing to trade and quote"
		($q tick/r.q :5010 -table "trade;quote" -p 5011 > /dev/null 2>&1 &)
		sleep 1
		if [[ ! -z $(ps -ef|grep 5010|grep 5011|grep r.q) ]]
		then 
		info "RDB1 started on port 5011"
		else
		err "RDB1 failed to start"
		fi
#	fi
#	if [[ $1 == "RDB2" ]]
#	then 
		info "Initialising RDB2 and subscribing to aggregrate"
		($q tick/r.q :5010 -table "aggreg" -p 5013 > /dev/null 2>&1 &)
		sleep 1
		if [[ ! -z $(ps -ef|grep 5010|grep 5013|grep r.q) ]]
		then
		info "RDB2 started on port 5013"
		else
                err "RDB2 failed to start"
                fi
#	fi
else
	err "q is missing"
	exit 1
fi
