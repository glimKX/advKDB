// to compile gcc -shared -m64 -DKXVER=3 cpython.c c.o -o cpython.so -fPIC
#include"k.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <errno.h>
#include <libgen.h>
#include <sys/utsname.h>

#define EXIT_FAILURE 1
#define EXIT_SUCCESS 0

int printLines(){
	printf ("+-------------------------------------+\n");
	return 0;
}

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
    r0(x);
    return 1;
  } else if(-128 == xt) {
    fprintf(stderr, "Error message returned : %s\n", x->s);
    r0(x);
    return 1;
  }
  r0(x);
  return 0;
}

J castTime(int hour,int min,int sec) {
 return (J)((60 * hour + min) * 60 + sec) * 1000000000;
}

int handle(char *host,int port){
	printf("C lib: Host %s Port %d\n",host,port);
        int c=khp(host,port);
	handleOK(c);
        return c;}

int sendTradeList(int h,J time,char *sym,int size, float price){
	K result, singleRow;
	printf("handle: %d, time: %lld, sym: %s, size: %d, price: %f",h,time,sym,size,price);
	singleRow = knk (4,ktj(-KN,time),ks((S) sym), kj(size),kf(price));
	result = k (h,".u.upd",ks((S) "trade"),singleRow,(K)0);
	return isRemoteErr(result);
}
