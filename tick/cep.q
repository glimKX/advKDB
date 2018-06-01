//////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Modify r.q template to become a cep 								//
//	Input of table format must be string, this can be handled in the bash script that init this	//
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/q tick/cep.q [host]:port[:usr:pwd] [host]:port[:usr:pwd] -func specialFunction 
/2008.09.09 .k ->.q

if[not "w"=first string .z.o;system "sleep 1"];


/ get the ticker plant and history ports, defaults are 5010,5012
.u.x:.z.x,(count .z.x)_enlist ":5010";
/ tables to subscribe to and defining AggregFunction
if["aggregration"~.Q.opt[.u.x]`func;
	.u.tSub:"`trade`quote";
	cep:{if[0=type x;
		x:x 1;
 		aggreg:(select sym,maxPrice:max price,minPrice:min price,tradedVol:sum size by sym from trade where sym in x) lj 
		select sym,maxBid:bidPrice,minAsk:askPrice by sym from quote where sym in x;
		] 	
	}
 ];	

/ end of day: save, clear, hdb reload
.u.end:{t:tables`.;t@:where `g=attr each t@\:`sym;.Q.hdpf[`$":",.u.x 1;`:.;x;`sym];@[;`sym;`g#] each t;};

/ init schema and sync up from log file;cd to hdb(so client save can run)
upd:{[t;x] if[t in value .u.tSub;$[t=`aggreg;t upsert x;t insert x;]];cep[x]};
.u.rep:{if[any 2<>count each x;x:enlist x];(.[;();:;].)each x;if[null first y;:()];-11!y;system "cd ",1_-10_string first reverse y};
/ HARDCODE \cd if other than logdir/db

/ connect to ticker plant for (schema;(logcount;log))
/ this changes such that the rdb is able to choose what it subscribes to

.u.rep .(hopen `$":",.u.x 0)"(.u.sub[;`] each ",.u.tSub,";`.u `i`L)";

