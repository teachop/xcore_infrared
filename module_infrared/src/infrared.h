//---------------------------------------------------------
// Infrared Remote driver header
// by teachop
//

#ifndef __INFRARED_H__
#define __INFRARED_H__

// Adafruit Mini IR Remote
#define IR_ADDR_LO 0x00
#define IR_ADDR_HI 0xbf
enum{
    IR_VOL_M, IR_PAUSE, IR_VOL_P, IR_NA1,
    IR_SETUP, IR_UP,    IR_STOP,  IR_NA2,
    IR_LEFT,  IR_ENTER, IR_RIGHT, IR_NA3,
    IR_0,     IR_DOWN,  IR_BACK,  IR_NA4,
    IR_1,     IR_2,     IR_3,     IR_NA5,
    IR_4,     IR_5,     IR_6,     IR_NA6,
    IR_7,     IR_8,     IR_9,     IR_NA7
};

// driver interface
interface infrared_if {

    // notify client data available
    [[notification]] slave void codeReady(void);

    // read codes: 0=code, 1=address low, 2=address high
    [[clears_notification]] uint32_t getCodes(uint8_t (&codes)[3]);
};

void infrared_task(in port sensor, interface infrared_if server remote);


#endif //__INFRARED_H__
