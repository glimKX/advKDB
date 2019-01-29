import ctypes
import time
import os
sharedLib=os.environ['PY_API_DIR']+"/cpython.so"
_qpy = ctypes.CDLL(sharedLib)
_qpy.handle.argtypes = (ctypes.POINTER(ctypes.c_char),ctypes.c_int)
_qpy.sendTradeList.argtypes = (ctypes.c_int,ctypes.c_longlong,ctypes.POINTER(ctypes.c_char),ctypes.c_int,ctypes.c_float)
_qpy.sendQuoteList.argtypes = (ctypes.c_int,ctypes.c_longlong,ctypes.POINTER(ctypes.c_char),ctypes.c_int,ctypes.c_float,ctypes.c_int,ctypes.c_float)

class kdbQ:
    global qpy

    def __init__(self,host,port):
        '''
        Initalisation of python to q handle
        kdbQ class stores the host, port and the handle made
        ----------------------------------------------------
        Error trap might be needed but most of the exceptions are handled by c library
        '''
        print("Opening Handle to q process {}:{}".format(host,port))
        self.host=host
        self.port=port
        self.h=self.handle()

    def handle(self):
        '''
        Open handle to kdb process
        Returns handle number
        '''
        result = _qpy.handle(ctypes.c_char_p(self.host),ctypes.c_int(self.port))
        return int(result)

    def sendTradeMsg(self,time,sym,size,price):
        '''
        Send trade messages to tickerplant taking the following arguement of specific type
        time - long
        sym - string
        size - int
        price - float
        '''
        result = _qpy.sendTradeList(ctypes.c_int(self.h),ctypes.c_longlong(self.kdbTime),ctypes.c_char_p(sym),ctypes.c_int(size),ctypes.c_float(price))
        print (int(result))

    def sendQuoteMsg(self,time,sym,bidSize,bidPrice,askSize,askPrice):
        '''
        Send quote messages to tickerplant taking the following arguement of specific type
        time - long
        sym - string
        bidSize - int
        bidPrice - float
        askSize - int
        askPrice - float
        '''
        result = _qpy.sendQuoteList(ctypes.c_int(self.h),ctypes.c_longlong(self.kdbTime),ctypes.c_char_p(sym),ctypes.c_int(bidSize),ctypes.c_float(bidPrice),ctypes.c_int(askSize),ctypes.c_float(askPrice))
        print (int(result))

    def castTime(self,timeStr):
        '''
        Given a time string HH:MM:SS
        it gets converted into a kdb long int
        '''
        self.timeObj=time.strptime(timeStr, "%H:%M:%S")
        #time.struct_time(tm_year=1900, tm_mon=1, tm_mday=1, tm_hour=8, tm_min=59, tm_sec=47, tm_wday=0, tm_yday=1, tm_isdst=-1)
        self.kdbTime=((60*self.timeObj.tm_hour+self.timeObj.tm_min)*60+self.timeObj.tm_sec)*1000000000
        #print("tuple: {}".format(self.kdbTime))
