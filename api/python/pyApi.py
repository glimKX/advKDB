#api python script
import sys
import csv
import os.path
import kdb
######################
# function: printLines
# description: printLines
######################
def printLines():
	print ("+-------------------+")

######################
# function: printDouble
# description: printDoubleLines
######################
def printDouble():
        print ("=====================")

######################
# function: info 
# description: stdout
######################
def info(x):
        print ("INFO: {}".format(x))

######################
# function: err 
# description: stderr
######################
def err(x):
        print ("ERROR: {}".format(x))

######################
# function: validateArg 
# description: validate arugement in cmd to be a csv
######################
def validateArg(x):
	chk=x[-3:]
	if chk == "csv":
		info ("Input file is a valid csv, proceeding to ingest csv") 
	else:
		err ("Input file is not a valid csv")
		exit(1)
######################
# function: openCSV 
# description: opens csv file and parse through it, while performing actions 
# assumes that first row is header 
######################
def openCSV(x):
	i = 0
	if os.path.isfile(x):	
		with open(x, "rb") as csvfile:
			csvReader=csv.reader(csvfile,delimiter=",")
			for row in csvReader:
				if i > 0:
                                        #need to make message into format below
                                        #"value (`upd;`trade;(01:00:00;`abc;100;100))"
					print(";".join(row))
				i+=1
	else:
		err ("Input file cannot be found")
		exit(1)
######################
#start of script
######################

printDouble()
print ("Initialisation of Python Api script")
print ("---Courtesy of qPy: Matt Warren---")
printDouble()
print ("List of CSV\n {}/advKDB/csvFiles/csvTrade.csv\n {}/advKDB/csvFiles/csvQuote.csv".format(os.getenv("HOME"),os.getenv("HOME")))
csvFile = raw_input('Enter CSV Path: ')
validateArg(csvFile)
printLines()
#need to obtain host and port env
info("Attempt to open handle to port {} on hostname {}".format(5016,"localhost"))
try:
    h=kdb.q("localhost",5014,"pythonAPI")
    info("Handle opened with q-python instance {}".format(h))
except:
    err("Unable to connect to q process")
    exit(1)
openCSV(csvFile)
