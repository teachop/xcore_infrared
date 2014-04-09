##XCore Driver for Adafruit Mini IR Remote
This repository provides an xCore driver module for the Adafruit [Mini IR Remote](http://www.adafruit.com/products/389).  An example app is included that uses an [XMOS xCore startKIT](http://www.xmos.com/startkit) with the [SparkFun 7 Segment Serial](https://github.com/teachop/xcore_seven_seg) display to display IR codes.

###Introduction
The Adafruit remote used is an [NEC-protocol-style](http://techdocs.altium.com/display/ADRR/NEC+Infrared+Transmission+Protocol) unit with 21 buttons.  An [IR Sensor](https://www.adafruit.com/products/157) was used that detects the IR signals and leaves the decoding to the CPU software.  This driver does the decoding.  It is an XCore XC task function that processes events coming from the change in state of the sensor signal.  This is measured for high / low pulse widths that are then translated into remote codes.

###Decoding
Pulse widths from the sensor are accepted within a tolerance of + / - 20% to accomodate the expected variations.  Timings are mapped within that range into preamble (9000uS high), space (4500 low), zero (562.5 low), one (1687.5 low), or repeat (2250 low) pulses.

A [timer resource](https://www.xmos.com/node/17091?page=3) is used to rescue the situation and clean up things when broken IR codes are partially received.  It implements a timeout that resets code reception on idle line from the sensor greater than 120 milliseconds - no valid data stream will have a gap larger than that (115 milliseconds is the maximum valid idle time, using 20% slow timing for the gap between repeat codes).

Four bytes are received:  address-low | address-high | command | command-inverted.

Note that the NEC protocol used in this remote is an extended version with 16 bit address = 0xbf00.  The address is passed on to the application by the driver no matter the value.

The NEC protocol includes an inverted code byte for validity checking.  This check is done in the driver and input is discarded silently if this fails.

The button mapping specific to this model remote is given in the infrared.h header as an enum.  Mappings would need revised for a different remote model.

###Driver API
Application clients use the driver by means of an XC [interface](https://www.xmos.com/support/documentation/xtools?subcategory=Programming%20in%20C%20and%20XC&component=app_interfaces_example) API.  This is an XCore message passing inter-task communication feature.  An interface feature called **notification** is used to generate a data-read event for the client application when a valid IR code has been detected.
- **codeReady()** - notification event indicating to the client that a valid code is available.
- **getCodes(codes)** - returns 1 and copies a waiting IR code in the **codes** buffer, or returns 0 if there isn't one.  This call also clears notification.  The code buffering is 1 level deep.  If a second IR code were to become available before the prior one is read, it will replace the unread code.  The codes array maps as follows.
- **codes[0]** IR Code (for example, the digit "2" is 0x11, see infrared.h)
- **codes[1]** Low byte of Address, expected to 0x00 here.
- **codes[2]** High byte of Address, expected to be 0xBF here.

