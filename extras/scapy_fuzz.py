from scapy.all import *
from scapy.layers.can import *

class testFrame(SignalPacket):
    fields_desc = [
        LEUnsignedSignalField("usig", 0, start=0, size=9, scaling=2),
        BESignedSignalField("ssig", 0, start=9, size=8,   scaling=0.5),
        LEFloatSignalField("fsig", 0, start=32)]

bind_layers(SignalHeader, testFrame, identifier=0x19B)

interface = 'socketcan'
channel = 'vcan0'

load_layer("can")
load_contrib('cansocket')

socket = CANSocket(channel='can0')

cases = 0
start = time.time()
print("Start fuzzing CAN Bus")
while True:
    p = SignalHeader()/fuzz(testFrame())
    # p = RawVal(fuzz(CAN()))

    try:
        socket.send(p)
        cases += 1
        if cases % 5000 == 0:
            p.show()
            print(str(cases) + " | " + str(int(cases/(time.time() - start))) + " per second")
    except Exception as e:
        print("Exception : " + str(e))
        print(str(cases) + " | " + str(int(cases/(time.time() - start))) + " per second")
        p.show()
        raise e