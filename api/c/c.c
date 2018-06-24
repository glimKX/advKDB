// to compile gcc c.c c.o -m32 -DKXVER=3 -lpthread
#include"k.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <errno.h>

#define EXIT_FAILURE 1
#define EXIT_SUCCESS 0

int handleOK(int handle){
	//handleOK function taken from c_api_for_KDB.pdf
	if(handle > 0)
		return 1;
	if(handle == 0)
		fprintf(stderr, "ERROR: Authentication error %d\n", handle);
	else if(handle == -1)
		fprintf(stderr, "ERROR: Connection error %d\n", handle);
	else if(handle == -2)
		fprintf(stderr, "ERROR: Time out error %d\n", handle);
	return 0;
}


// check result of remote call
// it can be either 0(network error) or K object
// if type of the object is -128(error) print error and release object.
// K objects with type -128 exist only when calling from standalone C API and
// not valid for shared objects
I isRemoteErr(K x) {
  if(!x) {
    fprintf(stderr, "Network error: %s\n", strerror(errno));
    return 1;
  } else if(-128 == xt) {
    fprintf(stderr, "Error message returned : %s\n", x->s);
    r0(x);
    return 1;
  }
  return 0;
}

J castTime(int hour,int min,int sec) {
 return (J)((60 * hour + min) * 60 + sec) * 1000000000;
}

int parseTradeCSV(char *csv,int h){
	//parse CSV, feedhandling is perform between the lines
	if (access(csv, F_OK) != -1){
		FILE* stream = fopen(csv,"r");
		printf("INFO: %s file has been opened and ready to be parsed\n",csv);
		char line[1024];
		struct tradeData{
			int timeHH, timeMM, timeSS;
			char sym[9];
			int size;
			int price;
		}tradeTmp;
		int j = 0;
		char *tmp;
		char *timeTmp;
		K result, singleRow;
		const char delimiters[] = ":,";
				
		while (fgets(line, 1024, stream)){
			
			if(line!=NULL){
				//strtok might be a better choice but this was easier to understand coming from q
				sscanf( line, "%d:%d:%d,%[^,],%d,%d", &tradeTmp.timeHH,&tradeTmp.timeMM,&tradeTmp.timeSS, tradeTmp.sym,&tradeTmp.size,&tradeTmp.price);
				
				
				if(j!=0){
					singleRow = knk(4,ktj(-KN,castTime(tradeTmp.timeHH,tradeTmp.timeMM,tradeTmp.timeSS)), ks((S) tradeTmp.sym), kj(tradeTmp.size), kf(tradeTmp.price));
					result = k(h,".u.upd", ks((S) "trade"), singleRow, (K) 0);
					if(isRemoteErr(result)) {
						return EXIT_FAILURE;
					}
					//printf("%s\n",result->s);
					r0(result);
				}
				
				// - for debug
				/*if(j!=0){
					//printf("timeInt: %lld\n",  castTime(tradeTmp.timeHH,tradeTmp.timeMM,tradeTmp.timeSS));
					//printf("test: %s\n",tradeTmp.sym);
					//printf("time: %d:%d:%d, sym: %s, size: %d, price: %d\n",tradeTmp.time.tm_hour,tradeTmp.time.tm_min,tradeTmp.time.tm_sec,tradeTmp.sym,tradeTmp.size,tradeTmp.price);
					//printf("time: %s, sym: %s, size: %d, price: %f\n",tradeTmp.timeHH,tradeTmp.sym,tradeTmp.size,tradeTmp.price);
					printf("time: %d:%d:%d, sym: %s , size: %d price: %d  \n",tradeTmp.timeHH,tradeTmp.timeMM,tradeTmp.timeSS,tradeTmp.sym,tradeTmp.size,tradeTmp.price);//tradeTmp.sym,tradeTmp.size,tradeTmp.price);
					//free(timeTmp);
				}*/
				j++;
			}
			
		}
		fclose(stream);
		printf("INFO: CSV parsed and sent to handle %d \n",h);
		return EXIT_SUCCESS;
	} else {
		fprintf(stderr, "INFO: File is missing \n");
		return EXIT_FAILURE;
	}
}

int parseQuoteCSV(char *csv,int h){
	//parse CSV, push to feed
	if (access(csv, F_OK) != -1){
		FILE* stream = fopen(csv,"r");
		printf("INFO: %s file has been opened and ready to be parsed\n",csv);
		char line[1024];
		struct quoteData{
			int timeHH, timeMM, timeSS;
			char sym[9];
			int bidSize,bidPrice,askSize,askPrice;
		}quoteTmp;
		int j = 0;
		char *tmp;
		char *timeTmp;
		K result, singleRow;
		const char delimiters[] = ":,";
				
		while (fgets(line, 1024, stream)){
			
			if(line!=NULL){
				//strtok might be a better choice but this was easier to understand coming from q
				sscanf( line, "%d:%d:%d,%[^,],%d,%d,%d,%d", &quoteTmp.timeHH,&quoteTmp.timeMM,&quoteTmp.timeSS, quoteTmp.sym,&quoteTmp.bidSize,&quoteTmp.bidPrice,&quoteTmp.askSize,&quoteTmp.askPrice);
				
				if(j!=0){
					singleRow = knk(6,ktj(-KN,castTime(quoteTmp.timeHH,quoteTmp.timeMM,quoteTmp.timeSS)), ks((S) quoteTmp.sym), kj(quoteTmp.bidSize), kf(quoteTmp.bidPrice), kj(quoteTmp.askSize), kf(quoteTmp.askPrice));
					result = k(h,".u.upd", ks((S) "quote"), singleRow, (K) 0);
					if(isRemoteErr(result)) {
						return EXIT_FAILURE;
					}
					//printf("%s\n",result->s);
					r0(result);
				}
				
				j++;
			}
			
		}
		fclose(stream);
		printf("INFO: CSV parsed and sent to handle %d \n",h);
		return EXIT_SUCCESS;
	} else {
		fprintf(stderr, "INFO: File is missing \n");
		return EXIT_FAILURE;
	}
}

int handle(char *host,int port){
        int c=khp(host,port);
        return c;}

int main(void){
	//add print of line here//
	printf("Initialisation of C to KDB API\n");
	//add print of line here//
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
	printf("INFO: Handle %d opened to port %d\n",h,port);
	printf("INFO: Ready to perform functions on q session\n");
	//run declared functions on h
	//require an if statement to read input to ensure that right function is applied to the right csv
	//parseTradeCSV(csv,h);
	parseQuoteCSV(csv,h);
	kclose(h);
	printf("INFO: Complete\n");
	return EXIT_SUCCESS;
}
