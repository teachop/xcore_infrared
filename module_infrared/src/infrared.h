//---------------------------------------------------------
// Infrared Remote driver header
// by teachop
//

#ifndef __INFRARED_H__
#define __INFRARED_H__

// driver interface
interface infrared_if {

    // notify client data available
    [[notification]] slave void codeReady(void);

    // read codes
    [[clears_notification]] uint32_t getCodes(uint8_t (&codes)[3]);
};

void infrared_task(in port sensor, interface infrared_if server remote);


#endif //__INFRARED_H__
