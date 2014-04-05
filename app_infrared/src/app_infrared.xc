//-----------------------------------------------------------
// XCore InfraRed Remote Test Application
// by teachop
//
// Display IR codes to demonstrate driver interface.
//

#include <xs1.h>
#include <timer.h>
#include <stdint.h>
#include "infrared.h"
#include "seven_seg.h"


// ---------------------------------------------------------
// show_code_task - show codes on sparkfun 4 digit 7-segment display
//
void show_code_task(interface infrared_if client remote, interface seven_seg_if client display) {
    const uint8_t hex[] = "0123456789ABCDEF";
    uint32_t display_busy = 0;
    uint8_t codeBuffer[3] = {0,0,0};
    uint8_t text[] = "----";
    uint32_t codes_ready = 0;

    while (1) {
        select {
        case display.written():
            display_busy = 0;
            break;
        case remote.codeReady():
            codes_ready = remote.getCodes(codeBuffer);
            if ( codes_ready && !display_busy ) {
                text[0] = hex[codeBuffer[1]>>4]; // address lsb
                text[1] = hex[codeBuffer[1]&15];
                text[2] = hex[codeBuffer[0]>>4]; // code
                text[3] = hex[codeBuffer[0]&15];
                display_busy = 1;
                display.setText( text );
                codes_ready = 0;
            }
            break;
        }
    }
}


// ---------------------------------------------------------
// main - xCore ping sensor test
//
in port sensor_pin = XS1_PORT_1N; // j7.17
port txd_pin = XS1_PORT_4C; // j7.5 [6, 7, 8]

int main() {
    interface seven_seg_if display;
    interface infrared_if remote;

    par {
        show_code_task(remote, display);
        infrared_task(sensor_pin, remote);
        seven_seg_task(txd_pin, display);
    }

    return 0;
}

