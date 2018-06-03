//////////////////////////////////////////////////////////////////////////////////////////////////
//	log.q script which loads up with all tick templates											//
//	q script will define functions in .z.po .z.pc and some .log functions						//
//////////////////////////////////////////////////////////////////////////////////////////////////

/init connection schema
.log.connections:flip `dateTime`user`host`ipAddress`connection`handle`duration!"ZSS*SIV"$\:();

/when connection is opened, collect from handle the following information
/datetime username hostname ipaddress connection duration
/collect data from .z.po
.z.po:{[w] `.log.connections insert ("z"$.z.P),w["(.z.u;.Q.host .z.a;\".\" sv string \"h\"$0x0 vs .z.a)"],`opened,w,0Nv};

/when connection is closed, update connection to closed
.z.pc:{[w] update connection:`closed,duration:"v"$("z"$.z.P)-dateTime from `.log.connections where handle = w};

/need unique name for each log file
.log.file:`;
.log.processName:"";

.log.string:{.log.processName," ## ",string[.z.P]," ## ",x," \n"};
/capture initalised time
.log.time:.z.T;
/declare log output function
.log.out:{.log.file "INFO: ",.log.string x};
.log.err:{.log.file "ERROR: ",.log.string x};
 
 
 