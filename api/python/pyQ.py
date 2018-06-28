import ctypes
_qpy = ctypes.CDLL('/home/limguanyu_08/advKDB/api/python/cpython.so')
_qpy.handle.argtypes = (ctypes.POINTER(ctypes.c_char),ctypes.c_int)

def handle(host,port):
    global qpy
    result = _qpy.handle(ctypes.c_char_p(host),ctypes.c_int(port))
    return int(result)


