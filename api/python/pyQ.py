import ctypes
_qpy = ctypes.CDLL('/home/limguanyu_08/advKDB/api/python/cpython.so')
_qpy.handle.argtypes = (ctypes.POINTER(ctypes.c_char),ctypes.c_int)
_qpy.sendTradeList.argtypes = (ctypes.c_int,ctypes.c_longlong,ctypes.POINTER(ctypes.c_char),ctypes.c_int,ctypes.c_float)

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
        result = _qpy.sendTradeList(ctypes.c_int(self.h),ctypes.c_longlong(time),ctypes.c_char_p(sym),ctypes.c_int(size),ctypes.c_float(price))
        print (int(result))
