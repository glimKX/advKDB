#api python script
import sys
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
printDouble()
print ("Python Api script")
printDouble()
print ("Argument = {}".format(sys.argv[1]))
validateArg(sys.argv[1])
