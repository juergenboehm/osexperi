#ifndef __drivers_rtc_h
#define __drivers_rtc_h

#include "kerneltypes.h"
#include "libs32/klib.h"

#define CMOS_ADDRESS 	0x70
#define CMOS_DATA 		0x71


uint32_t get_rtc_clock_in_sec();

int get_rtc_clock(tm_t *ptime);




#endif
