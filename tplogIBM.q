///////////////////////////////////////////////////////////
// Tickerplant log reader 
// Starts a q session which attempts to read in the latest logFile or one specificed by the user
// q tplogIBM.q -tplogFile FilePath
///////////////////////////////////////////////////////////

\d .tpr
dir: @[.Q.opt;.z.x;""];
dir: $[count dir;first dir `tplogFile;"sym",string .z.D];
/dir: raze @[system;"find . -name \"",dir,"\"*";{-2"Cannot find tplogFile: ",.Q.s x;exit 1}];
/dir: `$":",2_dir;
filter:{x:`func`table`data!x;.debug.x:x;x:@[x;`data;:;x[`data][;where `IBM=x[`data] 1]];if[sum count each x`data;.tpr.write enlist value x];};
file:"/" vs string[dir];
file[1]:"IBM.",file[1];
write:hopen ` sv `$file;
\d .


