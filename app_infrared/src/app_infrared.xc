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
    // 7-segment representations of Adafruit Mini button names
    const uint8_t key[] = "dpu-SUS-LEr-0db-123-456-789";
    uint32_t toggle = 0; // toggle indicator so repeat codes are visible

    display.setText("----");
    uint32_t display_busy = 1;

    while (1) {
        select {
        case display.written():
            display_busy = 0;
            break;
        case remote.codeReady():
            uint8_t buf[3];
            uint32_t codes_ready = remote.getCodes(buf);
            if ( codes_ready && (IR_ADDR_LO==buf[1]) && (IR_ADDR_HI==buf[2])) {
                // new codes and address matches
                uint8_t text[4];
                text[0] = (sizeof(key)>buf[0])? key[buf[0]] : '-';
                text[1] = (++toggle&1)? '-' : '_';
                text[2] = hex[buf[0]>>4]; // code in hex
                text[3] = hex[buf[0]&15];
                if ( !display_busy ) {
                    // should always be ready, faster than the remote
                    display.setText( text );
                    display_busy = 1;
                }
            }
            break;
        }
    }
}


// ---------------------------------------------------------
// main - infrared remote driver test
//
in port sensor_pin = XS1_PORT_1N; // j7.17
port txd_pin       = XS1_PORT_4C; // j7.5 [6, 7, 8]

int main() {
    interface seven_seg_if display;
    interface infrared_if remote;

    set_port_inv(sensor_pin); // sensor is inverted

    par {
        show_code_task(remote, display);
        infrared_task(sensor_pin, remote);
        seven_seg_task(txd_pin, 9600, display);
    }

    return 0;
}

