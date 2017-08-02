

#include "kernel32/process.h"
#include "kernel32/objects.h"

#include "libs32/klib.h"

#include "drivers/rtc.h"
#include "drivers/timer.h"
#include "drivers/hardware.h"
#include "drivers/pic.h"

volatile uint32_t timer_sema;

#define PROC_DBG 0

volatile uint32_t system_time_in_secs;
volatile uint32_t period_val;
volatile uint32_t period_tenth_mus;
volatile uint32_t system_ticks;

list_head_t* global_alarm_list;



tm_t tm_base;

void init_timer()
{
	system_time_in_secs = 0;
	period_val = 0;
	period_tenth_mus = 549254;

	get_rtc_clock(&tm_base);

	system_time_in_secs = mktime(&tm_base);

	system_ticks = 0;

	global_alarm_list = 0;

	mtx_init(&timer_sleep_mutex, 0, 0);

}

uint32_t get_secs_time()
{
	return system_time_in_secs;
}


#define ONE_MILLION	1000000

void timer_irq_handler(uint32_t errcode, uint32_t irq_num, void* esp)
{
	timer_sema = 1;

	// End of Interrupt (EOI) must be send at *end* of
	// interrupt routine

	//outb_0xe9( 'T');
	outb(PIC1_COMMAND, PIC_EOI);
	io_wait();

#if 0
	uint32_t esp_val = get_esp();
	outb_printf("\n\ntimer_irq_handler: esp = 0x%08x\n\n", esp_val);
#endif

	period_val += period_tenth_mus;
	if (period_val >= 10 * ONE_MILLION)
	{
		period_val -= 10 * ONE_MILLION;
		++system_time_in_secs;
	}
	++system_ticks;

	process_wakeups();

	schedule();

#if PROC_DBG
	outb_printf("before process_signals: current->pid = %d esp = %08x\n",
			current->proc_data.pid, get_esp());
#endif


#if PROC_DBG
	if (current && current->proc_data.pid == 5)
	{
		iret_blk_t* pir = (iret_blk_t*)(PROC_STACK_BEG(current)-sizeof(iret_blk_t));
		outb_printf("proc pid %d: current = %08x eip user = %08x esp user = %08x\n",
				current->proc_data.pid, (uint32_t)current,
				pir->eip, pir->esp);
	}
#endif

	process_signals((uint32_t) esp);


}

void process_wakeups()
{
	INIT_LISTVAR(p);

	int i = 0;

	while (p = global_alarm_list)
	{
		timer_node_t* ptnd = container_of(p, timer_node_t, link);
		if (ptnd->timeval <= system_ticks)
		{
			wq_free(ptnd->wq);
			delete_elem(&global_alarm_list, p);
			free_timer_node_t(ptnd);
		}
		else
		{
			break;
		}
	}

}



void sleep(uint32_t timeval)
{

	uint32_t goal_time = system_ticks + timeval;

	mtx_lock(&timer_sleep_mutex);

	INIT_LISTVAR(q);
	INIT_LISTVAR(p);

	q = 0;

	uint32_t p_time = 0;

	FORLIST(p, global_alarm_list)
	{
		timer_node_t * ptnd = container_of(p, timer_node_t, link);
		if (ptnd->timeval >= goal_time)
		{
			p_time = ptnd->timeval;
			break;
		}
		q = p;
		p = p->next;
	}
	END_FORLIST(p, global_alarm_list);

	timer_node_t* pnd = 0;
	int new_timer = 0;

	if (p_time == goal_time)
	{
		pnd = container_of(p, timer_node_t, link);
	}
	else
	{
		pnd = get_timer_node_t();
		pnd->timeval = goal_time;
		pnd->wq = get_wq_t();
		wq_init(pnd->wq);
		new_timer = 1;
	}

	if (new_timer)
	{
		if (!p)
		{
			// the list is empty: start a new list
			prepend_list(&global_alarm_list, &(pnd->link));
		}
		else if (p && p != global_alarm_list && q)
		{
			// goal_time is smaller than node time at p: insert before p
			insert_before(&global_alarm_list, &(pnd->link), p);
		}
		else if (p && p == global_alarm_list && q)
		{
			// goal_time is never smaller than node time: insert at end
			insert_after(&global_alarm_list, &(pnd->link), global_alarm_list->prev);
		}
		else if (p && !q)
		{
			// the first element node time is already greater than goal_time: insert before p
			insert_before(&global_alarm_list, &(pnd->link), p);
		}
	}

	mtx_unlock(&timer_sleep_mutex);

	wq_wait(pnd->wq);
}


