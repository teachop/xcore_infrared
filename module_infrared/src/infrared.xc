//---------------------------------------------------------
// Infrared Remote driver
// by teachop
//

#include <xs1.h>
#include <stdint.h>
#include "infrared.h"


// ---------------------------------------------------------
// infrared_task - Infrared Remote driver
//
void infrared_task(in port sensor, interface infrared_if server remote) {
    uint32_t low_pulse = 0;
    uint8_t ir_codes[3] = {0,0,0};
    uint32_t fresh_codes = 0;
    uint32_t last_edge = 0;
    uint32_t buffer = 0;
    uint32_t buffer_count = 0;
    uint32_t can_repeat = 0;
    uint32_t preamble = 0;

    uint32_t tick_rate = 100*1000*100;
    timer tick;
    uint32_t next_tick;
    tick :> next_tick;

    while( 1 ) {
        select {
        case remote.getCodes(uint8_t (&codes)[3]) -> uint32_t return_val:
            return_val = fresh_codes;
            if ( fresh_codes ) {
                codes[0] = ir_codes[0]; // actual code
                codes[1] = ir_codes[1]; // address low
                codes[2] = ir_codes[2]; // address high
                fresh_codes = 0;
            }
            break;

        case tick when timerafter(next_tick) :> void:
            next_tick += tick_rate;
            can_repeat = buffer_count = preamble = 0;
            break;

        case sensor when pinsneq(low_pulse) :> low_pulse:
            uint32_t now;
            tick :> now;
            next_tick = now + tick_rate;
            uint32_t width = (now - last_edge)/100;
            last_edge = now;
            if ( !low_pulse ) { // look for preamble mark
                if ( (7200<width) && (10800>width) ) {
                    preamble = 1;
                    buffer_count = 0;
                }
            } else switch ( preamble ) {
            case 1:  // look for preamble space, or repeat code
                if ( (3600<width) && (5400>width) ) {
                    can_repeat = 0;
                    preamble = 2;
                    break;
                } else if ( (1800<width) && (2700>width) && can_repeat ) {
                    fresh_codes = 1;
                    remote.codeReady();
                }
                preamble = 0;
                break;
            case 2:  // look for 32 data bits
                buffer >>=1;
                if ( (1800<width) && (2700>width) ) {
                    buffer |= 0x80000000;
                } else if ( (900>=width) || (1350<=width) ) {
                    preamble = 0;
                    break;
                }
                if ( 32 <= ++buffer_count ) {
                    ir_codes[1] = buffer; // low address
                    buffer>>=8;
                    ir_codes[2] = buffer; // high address
                    buffer>>=8;
                    ir_codes[0] = buffer; // ir code
                    buffer>>=8;
                    uint8_t check = ~buffer;
                    can_repeat = fresh_codes = (check==ir_codes[0]);
                    if ( fresh_codes ) {
                        remote.codeReady();
                    }
                    preamble = 0;
                }
                break;
            }
            break;
        }
    }

}
