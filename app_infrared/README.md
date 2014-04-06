##Adafruit IR Mini Remote Example Application
The example application waits for IR codes from the driver and displays them on a [SparkFun Serial 7 Segment Display](https://github.com/teachop/xcore_seven_seg).  These are mapped to a one character (7 segment version!) name for each key, and also the codes are display in hex.  In order for repeat codes to be visible, an activity indicator toggles.

###Required Modules
For an xCore xC application, the required modules are listed in the Makefile:
- USED_MODULES = module_seven_seg module_infrared

###Wiring
The IR sensor is wired to the 1 bit port 1N.  Note the signal is inverted, and an XC library call is used to set up inversion in the processor input.  It comes to the software in the expected polarity.  The display driver needs one UART data signal at 9600 baud.  My breadboard used the LSB of a 4 bit XCore port, the other 3 bits of 4C being unused.  A 1 bit port would normally be better for such a use.  For brightness the display is on 5V and seems to accept the 3.3V data well enough for a breadboard test.
- **J7.5**  Transmit serial data (wire to display **RX** input).
- **J7.17**  Receive IR data (wire to **OUT** of sensor);

