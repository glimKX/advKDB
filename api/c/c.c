// to compile gcc c.c c.o -m32 -DKXVER=3 -lpthread
#include"k.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#define EXIT_FAILURE 1
#define EXIT_SUCCESS 0

int handleOK(int handle){
	//handleOK function taken from c_api_for_KDB.pdf
	if(handle > 0)
		return 1;
	if(handle == 0)
		fprintf(stderr, "Authentication error %d\n", handle);
	else if(handle == -1)
		fprintf(stderr, "Connection error %d\n", handle);
	else if(handle == -2)
		fprintf(stderr, "Time out error %d\n", handle);
	return 0;
}

char *str_replace(char *orig, char *rep, char *with) {
    	//adapted from "https://stackoverflow.com/questions/779875/what-is-the-function-to-replace-string-in-c"
	char *result; // the return string
    	char *ins;    // the next insert point
    	char *tmp;    // varies
    	int len_rep;  // length of rep (the string to remove)
    	int len_with; // length of with (the string to replace rep with)
    	int len_front; // distance between rep and end of last rep
    	int count;    // number of replacements

    	// sanity checks and initialization
    	if (!orig || !rep)
        	return NULL;
    	len_rep = strlen(rep);
    	if (len_rep == 0)
        	return NULL; // empty rep causes infinite loop during count
    	if (!with)
        	with = "";
    	len_with = strlen(with);

    	// count the number of replacements needed
    	ins = orig;
    	for (count = 0; tmp = strstr(ins, rep); ++count) {
        	ins = tmp + len_rep;
    	}

    	tmp = result = malloc(strlen(orig) + (len_with - len_rep) * count + 1);

    	if (!result)
        	return NULL;

	// first time through the loop, all the variable are set correctly
	// from here on,
    	// tmp points to the end of the result string
    	// ins points to the next occurrence of rep in orig
    	// orig points to the remainder of orig after "end of rep"
    	while (count--) {
        	ins = strstr(orig, rep);
        	len_front = ins - orig;
        	tmp = strncpy(tmp, orig, len_front) + len_front;
        	tmp = strcpy(tmp, with) + len_with;
        	orig += len_front + len_rep; // move to next "end of rep"
    	}
    	strcpy(tmp, orig);
    	return result;
}

const char* parseCSV(char *csv,int h){
	//parse CSV, have to run push to feedhandler inbetween each line, this is not done yet
	if (access(csv, F_OK) != -1){
		FILE* stream = fopen(csv,"r");

		char line[1024];
		while (fgets(line, 1024, stream)){
			if(line!=NULL){
				if(NULL !=str_replace(line,",",";")){
				puts(str_replace(line,",",";"));
				}
			}
		}
		return NULL;
	} else {
		fprintf(stderr, "File is missing \n");
	}
}

int handle(char *host,int port){
        int c=khp(host,port);
	//k(-c,"a+:2",(K)0);
        return c;}

int main(void){
	printf("Initialisation of C to KDB API\n");
	char i[20];
	char host[20];
	int port;
	char csv[100];

	printf("Enter host:");
	gets(host);
	printf("Enter port:");
	gets(i) ;
	port = atoi(i);
	printf("Example of paths\n %s/advKDB/csvFiles/csvQuote.csv \n %s/advKDB/csvFiles/csvTrade.csv \n",getenv("HOME"),getenv("HOME"));
	printf("Enter full CSV Path:");
	gets(csv);

	int h = handle(host,port);
	if(!handleOK(h))
		return EXIT_FAILURE;
	printf("Handle %d opened to port %d\n",h,port);
	printf("Ready to perform functions on q session\n");
	//k(-h,"a+:2",(K)0);
	//run declared functions on h
	parseCSV(csv,h);
	kclose(h);
	printf("Done\n");
	return EXIT_SUCCESS;
}
