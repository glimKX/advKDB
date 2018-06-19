#api python script
import sys
import csv
import os.path
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
					print(";".join(row))
				i+=1
	else:
		err ("Input file is cannot be found")
		exit(1)
######################
#start of script
######################

printDouble()
print ("Python Api script")
printDouble()
print ("Argument = {}".format(sys.argv[1]))
validateArg(sys.argv[1])
openCSV(sys.argv[1])
