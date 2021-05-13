# Write your code here :-)
import board
import digitalio
import time
import touchio
import neopixel

#from adafruit_circuitplayground import cp
from adafruit_ble import BLERadio
from adafruit_ble.advertising.standard import ProvideServicesAdvertisement
from adafruit_ble.services.nordic import UARTService
from adafruit_bluefruit_connect.packet import Packet # no .to_bytes()?

pixels = neopixel.NeoPixel(board.NEOPIXEL, 110, brightness=0.1, auto_write=True)
rainbow = True

# Setup BLE connection
ble = BLERadio()
uart_server = UARTService()
advertisement = ProvideServicesAdvertisement(uart_server)
touch_A2 = touchio.TouchIn(board.A2)
SEND_RATE = 1
while True:
    ble.start_advertising(advertisement)  # Start advertising.
    was_connected = False
    last_send = time.monotonic()
    while not was_connected or ble.connected:
        if rainbow:
            pixels.fill((0,155,155))
        if ble.connected:  # If BLE is connected...
            if not was_connected:
                print('connected')
                ble.stop_advertising()
                was_connected = True
                #flag = 0
            if touch_A2.value and time.monotonic() - last_send > SEND_RATE:
                print(touch_A2.value)
                print("A2 touched")
                uart_server.write('Checked-in!')
                #touch_A1.deinit()
                #touch_A1 = touchio.TouchIn(board.A1)
                last_send = time.monotonic()
                pixels.fill((255,0,255))
                rainbow = False
                print(last_send)
                time.sleep(0.1)
            #print("Outside loop")
        #uart_server.write('Checked-in!')
                    #flag = 1
            # receive
            if uart_server.in_waiting:
                print("Inside uart_server")
                    # note that the reading won't stop until buffer's full
                pkt = uart_server.read(20) # adjust buffer size as needed
                if pkt == b'doingwell':
                    pixels.fill((0,255,0))
                elif pkt == b'doingokay':
                    pixels.fill((150,150,0))
                elif pkt == b'pleasevisit':
                    pixels.fill((150,0,0))
                rainbow = False
                print(pkt)
            #time.sleep(0.5)
        else:
            #led.value = True
            rainbow = True
            time.sleep(0.0)
            #led.value = False
            #time.sleep(0.5)
            #print('is the REPL working?')
