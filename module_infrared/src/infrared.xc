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
    uint32_t pin_state = 0;
    uint8_t ir_codes[3] = {0,0,0};
    uint32_t fresh_codes = 0;

    uint32_t tick_rate = 50*1000*100;
    timer tick;
    uint32_t next_tick;
    tick :> next_tick;

    while( 1 ) {
        select {
        case tick when timerafter(next_tick) :> void:
            next_tick += tick_rate;
            if ( fresh_codes ) {
                remote.codeReady();
            }
            break;
        case sensor when pinsneq(pin_state) :> pin_state:
            uint32_t now;
            tick :> now;
            if ( pin_state ) {
                // input pulse went high
                ir_codes[0]++;
            } else {
                // input pulse is low
                ir_codes[1] = 0xaa; // pulse decoding TBD!
            }
            fresh_codes = 1;
            break;
        case remote.getCodes(uint8_t (&codes)[3]) -> uint32_t return_val:
            codes[0] = ir_codes[0]; // actual code
            codes[1] = ir_codes[1]; // address low
            codes[2] = ir_codes[2]; // address high
            return_val = fresh_codes;
            fresh_codes = 0;
            break;
        }
    }

}
