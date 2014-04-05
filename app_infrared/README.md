##Adafruit IR Mini Remote Example Application
TBD.

###Required Modules
For an xCore xC application, the required modules are listed in the Makefile:
- USED_MODULES = module_seven_seg module_infrared

###Wiring
The SparkFun display unit offers several serial interface choices includng I2C, SPI and UART.  For the driver UART was used, and thus only the one **RX** signal needs connected (in addition to the display power).  My breadboard used the LSB of a 4 bit XCore port, the other 3 bits of 4C being unused.  A 1 bit port would normally be selected for such a use.  The IR sensor is wired to 1 bit port P1N.
- **J7.5**  Transmit serial data (wire to display **RX** input).
- **J7.17**  Receive IR data (wire to **OUT** of sensor);

