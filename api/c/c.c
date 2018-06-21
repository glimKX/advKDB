// q trade.q -p 5001
// l32: gcc ../c/c/c.c c.o -lpthread
// s32: /usr/local/gcc-3.3.2/bin/gcc ../c/c/c.c c.o -lsocket -lnsl -lpthread
// w32: cl  ../c/c/c.c c.lib ws2_32.lib
#include"k.h"
#include <stdio.h>

int EXIT_FAILURE=1;
int EXIT_SUCCESS=0;

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

int handle(char *host,int port){
        int c=khp(host,port);
	//k(-c,"a+:2",(K)0);
        return c;}

int main(void){
	printf("Initialisation of C to KDB API\n");
	char i[20];
	char host[20];
	int port;
	printf("Enter host:");
	gets(host);
	printf("Enter port:");
	gets(i) ;
	port = atoi(i);

	int h = handle(host,port);
	if(!handleOK(h))
		return EXIT_FAILURE;
	printf("Handle %d opened to port %d\n",h,port);
	printf("Ready to perform functions on q session\n");

	kclose(h);
	printf("Done\n");
	return EXIT_SUCCESS;
}
