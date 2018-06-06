#!/bin/bash
##########################################################
# Script to check all processes
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
# Function: printHeader
# Description: print Double Lines
###########################################################
printHeader()
{
	printf "=======================================\n"
	return 0
}
###########################################################
# Function: printLines 
# Description: print Single Lines 
###########################################################
printLines()
{
        printf "+-------------------------------------+\n"
        return 0
}
###########################################################
# Function: choices 
# Description: print choices
###########################################################
printChoices()
{
        printf "These are the followings choices for start mode\n	1.	ALL\n	2.	tickerplant\n	3.	rdb\n	4.	feed\n	5.	cep\n"
        return 0
}
###########################################################
# Function: sourceQ
# Description: source for Q
###########################################################
 sourceQ()
{
        printLines
        info "Sourcing for q"
        printLines
        export q=$(find ~ -name q | grep l32)
		if [[ ! -z "$q" ]]
		then
            info "Found q app $q"
		else
            err "q app cannot be found, unable to start"
			exit 1
		fi
}
###########################################################

clear
printHeader
printf "Main Script for TickerPlant\n"
printHeader
printf "Script has 3 modes\n	1. Start:		To start processes\n	2. Shutdown:		To stop processes\n	3. Test:		To check on processes\n	4. LoadCSV:		To load csv into TickerPlant\n	5. reIngestTPLog:	To parse for IBM entries\n"
read -p 'Please input mode choice: ' choice
printf "Choice is: %s \n" "$choice"
printLines
if [ "$choice" = "Start" ] || [ "$choice" = "1" ]
then
	echo "Start Mode"
	printLines
	printChoices
	read -p 'Please input start mode choice: ' mode
	case "$mode" in
	ALL|1)
	./start.sh ALL
	;;
	tickerplant|2)
	./start.sh tickerplant
	;;
	rdb|3)
	./start.sh rdb
	;;
	feed|4)
	./start.sh feed
	;;
	cep|5)
	./start.sh cep
	;;
	*)
	err "No such choice exiting script"
	exit 1
	;;
	esac
elif [ "$choice" = "Shutdown" ] || [ "$choice" = "2" ]
then
	echo "Shutdown Mode"
	printLines
	printChoices
	read -p 'Please input start mode choice: ' mode
	case "$mode" in
	'ALL'|'1')
	./shutdown.sh ALL
	;;
	'tickerplant'|'2')
	./shutdown.sh tickerplant
	;;
	'rdb'|'3')
	./shutdown.sh rdb
	;;
	'feed'|'4')
	./shutdown.sh feed
	;;
	'cep'|'5')
	./shutdown.sh cep
	;;
	*)
	err "No such choice exiting script"
	exit 1
	;;
	esac
elif [ "$choice" = "Test" ] || [ "$choice" = "3" ]
then
	echo "Test Mode"
	printLines
	info "Checking for running processes"
	echo "QPROCESS	PID	STIME	ARGUMENTS		PORT"
#glim     31516 13606  0 01:51 pts/3    00:00:00 /home/glim/q/l32/q tick.q sym tplog -p 5010 -t 1000
#glim     31681 13606  0 02:05 pts/3    00:00:00 /home/glim/q/l32/q tick/r.q :5010 -table trade;quote  5011
	ps -ef | grep "\.q" | grep -v grep | grep tick.q | awk '{printf ("%-8s\t%5s\t%4s\t%4s\t%-15s\t%4s\t\n",$9, $2, $5, "-tpDir", $11, $13)}'
	ps -ef | grep "\.q" | grep -v grep | grep -v tick.q | awk -F"-p" -v OFS='\t' '{print $1,$2}' | awk {'printf ("%-8s\t%5s\t%4s\t%4s\t%-15s\t%4s\t\n",$9, $2, $5, $11, $12, $NF)'}
	exit 0
elif [ "$choice" = "LoadCSV" ] || [ "$choice" = "4" ]
then
	echo "Load CSV Mode"
	printLines
	read -p 'Please input csvPath: ' csvInput
	info "Checking for running tickerplant"
	runStatus=$(ps -ef | grep "\.q" | grep -v grep | grep tick.q | awk '{print $13}')
	if [[ -z $runStatus ]]
	then 
		err "Tickerplant is not up, unable to push csv"
		exit 1
	else
		sourceQ
		info "Pushing csv to tickerplant"
		printf "\n"
		$q csvLoad.q :$runStatus -csv $csvInput
	fi
elif [ "$choice" = "reIngestTPLog" ] || [ "$choice" = "5" ]
then
	echo "reIngestTPLog Mode"
	printLines
	read -p 'Please input tpFile name (do not input path): ' tpInput
	info "Creating new tplogFile for $tpInput"
	sourceQ
	printf "\n"
	$q tplogIBM.q -tplogFile $tpInput
else
	err "Mode is not present exiting script"
	printLines
	exit 1
fi
