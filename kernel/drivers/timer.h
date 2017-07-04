#ifndef __drivers_timer_h
#define __drivers_timer_h

#include "kerneltypes.h"

extern volatile uint32_t timer_special_counter;
extern volatile uint32_t timer_sema;


void timer_irq_handler(uint32_t errcode, uint32_t irq_num, void* esp);



#endif

