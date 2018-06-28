import ctypes
_qpy = ctypes.CDLL('/home/limguanyu_08/advKDB/api/python/cpython.so')
_qpy.handle.argtypes = (ctypes.POINTER(ctypes.c_char),ctypes.c_int)

class kdbQ:
    global qpy

    def __init__(self,host,port):
        print("Opening Handle to q process {}:{}".format(host,port))
        self.host=host
        self.port=port
        self.h=self.handle()

    def handle(self):
        result = _qpy.handle(ctypes.c_char_p(self.host),ctypes.c_int(self.port))
        return int(result)


