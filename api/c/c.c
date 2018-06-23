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
		fprintf(stderr, "Authentication error %d\n", handle);
	else if(handle == -1)
		fprintf(stderr, "Connection error %d\n", handle);
	else if(handle == -2)
		fprintf(stderr, "Time out error %d\n", handle);
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

J castTime(struct tm *x) {
 return (J)((60 * x->tm_hour + x->tm_min) * 60 + x->tm_sec) * 1000000000;
}

int parseTradeCSV(char *csv,int h){
	//parse CSV, have to run push to feedhandler inbetween each line, this is not done yet
	if (access(csv, F_OK) != -1){
		FILE* stream = fopen(csv,"r");

		char line[1024];
		struct tradeData{
			struct tm *time;
			char *sym;
			int size;
			float price;
		}tradeTmp;
		int j = 0;
		char *tmp;
		char timeTmp[6];
		K result, singleRow;
				
		while (fgets(line, 1024, stream)){
			
			if(line!=NULL){
				tmp = line;
				//timeTmp = strsep(&tmp,","); / - for debug
				strptime(strsep(&tmp,","),"%X",&tradeTmp.time);
				tradeTmp.sym = strsep(&tmp,",");
				tradeTmp.size = atoi(strsep(&tmp,","));
				tradeTmp.price = atof(strsep(&tmp,","));
				
				free(tmp);
				/*if(j!=0){
					singleRow = knk(4,kt(castTime(tradeTmp.time)), ks((S) tradeTmp.sym), kj(tradeTmp.size), kf(tradeTmp.price));
					result = k(h,".u.upd", ks((S) "trade"), singleRow, (K) 0);
					if(isRemoteErr(result)) {
						return EXIT_FAILURE;
					}
					r0(result);
				}*/
				// - for debug
				if(j!=0){
					printf("time: %d:%d:%d, sym: %s, size: %d, price: %f\n",tradeTmp.time->tm_hour,tradeTmp.time->tm_min,tradeTmp.time->tm_sec,tradeTmp.sym,tradeTmp.size,tradeTmp.price);
					//free(timeTmp);
				}
				j++;
			}
			
		}
		fclose(stream);
		return NULL;
	} else {
		fprintf(stderr, "File is missing \n");
	}
}

int parseQuoteCSV(char *csv,int h){
	//parse CSV, have to run push to feedhandler inbetween each line, this is not done yet
	if (access(csv, F_OK) != -1){
		FILE* stream = fopen(csv,"r");

		char line[1024];
		while (fgets(line, 1024, stream)){
			if(line!=NULL){
				puts(line);
			}
		}
		fclose(stream);
		return NULL;
	} else {
		fprintf(stderr, "File is missing \n");
	}
}

/*const int pushToQHandle(char *line,int h){
	//use existing handle to push to tickerplant
	
}*/

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
	//parseCSV(csv,h);
	parseTradeCSV(csv,h);
	kclose(h);
	printf("Done\n");
	return EXIT_SUCCESS;
}
