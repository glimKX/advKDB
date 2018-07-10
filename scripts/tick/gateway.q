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
.z.ws:{neg[.z.w] .j.j value x}

/sourceForSym
sourceForSym:{output:hdbHandle "10#'distinct value flip select sym from trade";
	`func`output!(`sourceForSym;" " sv string raze output)
 }

/selectFromTrade
selectFromTrade:{output:hdbHandle "select from trade where sym = ",x;
	`func`output!(`selectFromTrade;output)
 }
