//---------------------------------------------------------
// Infrared Remote driver header
// by teachop
//

#ifndef __INFRARED_H__
#define __INFRARED_H__

// Adafruit Mini IR Remote code map
#define IRED_VOL_DOWN 0x00
#define IRED_PAUSE    0x00
#define IRED_VOL_UP   0x00

#define IRED_SETUP    0x00
#define IRED_UP       0x00
#define IRED_STOP     0x00

#define IRED_LEFT     0x00
#define IRED_ENTER    0x00
#define IRED_RIGHT    0x00

#define IRED_0        0x00
#define IRED_DOWN     0x00
#define IRED_BACK     0x00

#define IRED_1        0x00
#define IRED_2        0x00
#define IRED_3        0x00

#define IRED_4        0x00
#define IRED_5        0x00
#define IRED_6        0x00

#define IRED_7        0x00
#define IRED_8        0x00
#define IRED_9        0x00


// driver interface
interface infrared_if {

    // notify client data available
    [[notification]] slave void codeReady(void);

    // read codes
    [[clears_notification]] uint32_t getCodes(uint8_t (&codes)[3]);
};

void infrared_task(in port sensor, interface infrared_if server remote);


#endif //__INFRARED_H__
