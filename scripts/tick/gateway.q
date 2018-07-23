//////////////////////////////////////////////////////////////////////////////////////////////////////////
//	 GATEWAY INIT SCRIPT 										//
//////////////////////////////////////////////////////////////////////////////////////////////////////////

if[not "w"=first string .z.o;system "sleep 1"];
//init with config port
system "p ",getenv`GATEWAY_PORT;

/ load logging capability
system "l ",getenv[`SCRIPTS_DIR],"/log.q";

/ open handle to HDB and RDB
hdbHandle:hopen "J"$getenv `HDB_PORT;
/rdbHandle:hopen "J"$getenv `RDB_PORT;

/define .z.ws for websocket
.z.ws:{neg[.z.w] .j.j @[{value x};x;{`func`output!(`error;"failed to process ",x," due to ",y)}x]}

/sourceForSym
sourceForSym:{output:(hdbHandle "raze value flip 11#key desc select count i by sym from trade") except `$"BRK-A";
	`func`output!(`sourceForSym;" " sv string raze output)
 }

/selectFromTrade
selectFromTrade:{output:hdbHandle "select from trade where sym = ",x;
	`func`output!(`selectFromTrade;output)
 }
