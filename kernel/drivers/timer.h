#ifndef __drivers_timer_h
#define __drivers_timer_h

#include "kerneltypes.h"
#include "libs32/klib.h"

#include "kernel32/mutex.h"

#include "libs/lists.h"


typedef struct timer_node_s {

	uint32_t timeval;
	list_head_t link;
	wq_t* wq;

} timer_node_t;



void init_timer();

uint32_t get_secs_time();


void timer_irq_handler(uint32_t errcode, uint32_t irq_num, void* esp);


void sleep(uint32_t timeval);

void process_wakeups();



extern volatile uint32_t timer_sema;

extern volatile uint32_t system_time_in_secs;
extern volatile uint32_t period_val;
extern volatile uint32_t period_tenth_mus;

extern volatile uint32_t system_ticks;


extern tm_t tm_base;

extern list_head_t* global_alarm_list;







#endif

