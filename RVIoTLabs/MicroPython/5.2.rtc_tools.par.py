# rtc_tools.py
import machine
import ustruct

rtc = machine.RTC()
# Function to store four integer/float values in RTC memory
def rtc_store_param(cycle, delta, kpack):
    data = rtc.memory()
    s,c,d,k,n = ustruct.unpack('fif2i', data); data = ustruct.pack('fif2i',s,cycle,delta,kpack,n)
    rtc.memory(data)
    
def rtc_store_sensor(sensor):
    data = rtc.memory()
    s,c,d,k,n = ustruct.unpack('fif2i', data); s=sensor
    data = ustruct.pack('fif2i',s,c,d,k,n)
    rtc.memory(data)
    
def rtc_store_counter(counter):
    data = rtc.memory()
    s,c,d,k,n = ustruct.unpack('fif2i', data); n=counter
    data = ustruct.pack('fif2i',s,c,d,k,n)
    rtc.memory(data)
    
def rtc_load_sensor():
    s=20.0; c=10; d=0.1; k=10; n=1
    data = rtc.memory()
    if not data:
        data = ustruct.pack('fif2i',s,c,d,k,n)
        rtc.memory(data)
    s,c,d,k,n = ustruct.unpack('fif2i', data)
    return s

def rtc_load_counter():
    s=20.0; c=10; d=0.1; k=10; n=1
    data = rtc.memory()
    if not data:
        data = ustruct.pack('fif2i',s,c,d,k,n)
        rtc.memory(data)
    s,c,d,k,n = ustruct.unpack('fif2i', data)
    return n

def rtc_load_param():
    # Retrieve the packed data from RTC memory
    s=20.0; c=10; d=0.1; k=10; n=1
    data = rtc.memory()
    # Ensure data is not empty
    if not data:
        data = ustruct.pack('fif2i',s,c,d,k,n)
        rtc.memory(data)
    # Unpack the integers from the byte array
    s, c, d, k, n = ustruct.unpack('fif2i', data)
    return c, d, k

# test to be commented 
c=0
while c<10:
    sens=rtc_load_sensor(); sens=sens+1
    rtc_store_sensor(sens); count=rtc_load_counter()
    count=count+1; rtc_store_counter(count)
    cycle,delta,kpack=rtc_load_param()
    cycle=cycle+2; delta=delta+0.01; kpack=kpack+1
    rtc_store_param(cycle,delta,kpack)
    c=c+1
    print(sens,count,cycle,delta,kpack)