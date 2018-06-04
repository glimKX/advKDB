//////////////////////////////////////////////////////////////////////////////////////////////////
//	log.q script which loads up with all tick templates											//
//	q script will define functions in .z.po .z.pc and some .log functions						//
//////////////////////////////////////////////////////////////////////////////////////////////////

/init connection schema
.log.connections:flip `dateTime`user`host`ipAddress`connection`handle`duration!"ZSS*SIV"$\:();

/when connection is opened, collect from handle the following information
/datetime username hostname ipaddress connection duration
/collect data from .z.po
.z.po:{`.log.connections insert .z.Z,.z.u,(.Q.host .z.a;"." sv string "h"$0x0 vs .z.a),`opened,.z.w,0Nv;.log.out .log.co .z.w};

/when connection is closed, update connection to closed
.z.pc:{update connection:`closed,duration:"v"$80000*.z.Z-dateTime from `.log.connections where handle = .z.w;.log.out .log.cc .z.w};

/need unique name for each log file
.log.AllProcessName:(5010;5011;5013;5020)!`tickerPlant`RDB1`RDB2`FeedHandler;
.log.processName:.log.AllProcessName system"p";
.log.file:hopen `$":log/",string[.log.processName],".log";

.log.string:{string[.log.processName]," ## ",string[.z.P]," ## ",x," \n"};
/capture initalised time
.log.time:.z.T;
/declare log output function
.log.out:{.log.file "INFO: ",.log.string x};
.log.err:{.log.file "ERROR: ",.log.string x};
 
\c 200 200

.log.cc:{[w] "Connection closed \n",.Q.s select from .log.connections where handle = w};
.log.co:{[w] "Connection opened \n",.Q.s select from .log.connections where handle = w}; 
