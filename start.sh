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
# Function: warn 
# Description: warn message
###########################################################
warn()
{
        local TEXT=${1}
        printf "WARN: %s\n" "${TEXT}"
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
info "Starting q processes"
printLines
info "Check for existing tickerPlant"
if [[ -z $(ps -ef | grep "\.q" | grep tick.q|grep -v grep) ]]
then
	info "No Existing tickerPlant found"
	info "Starting tickerPlant"
	bash tick.sh
else 
	warn "Existing Tickerplant found, not starting tickerPlant"
fi
printLines
info "Check for existing rdb"
printLines
if [[ -z $(ps -ef | grep "\.q" | grep rdb.q|grep -v grep) ]]
then
	info "No Existing RDB found"
	info "Starting RDB"
	bash rdb.sh
else
	warn "Existing RDB found, not starting RDBs"
fi
printLines
info "Check for existing feedHandler"
printLines
if [[ -z $(ps -ef | grep "\.q" | grep feed.q|grep -v grep) ]]
then
	info "No Existing FeedHandler found"
	info "Starting FeedHandler"
	bash feed.sh
else
	warn "Existing FeedHandler found, not starting FeedHandler"
fi
