#ifndef __drivers_timer_h
#define __drivers_timer_h

#include "kerneltypes.h"
#include "libs32/klib.h"



void init_timer();

uint32_t get_secs_time();


void timer_irq_handler(uint32_t errcode, uint32_t irq_num, void* esp);





extern volatile uint32_t timer_special_counter;
extern volatile uint32_t timer_sema;

extern volatile uint32_t system_time_in_secs;
extern volatile uint32_t period_val;
extern volatile uint32_t period_tenth_mus;

extern tm_t tm_base;







#endif

