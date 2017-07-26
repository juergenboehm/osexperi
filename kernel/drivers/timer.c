

#include "kernel32/process.h"

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


tm_t tm_base;

void init_timer()
{
	system_time_in_secs = 0;
	period_val = 0;
	period_tenth_mus = 549254;

	get_rtc_clock(&tm_base);

	system_time_in_secs = mktime(&tm_base);

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

	uint32_t esp_val = get_esp();

#if 0
	outb_printf("\n\ntimer_irq_handler: esp = 0x%08x\n\n", esp_val);
#endif

	period_val += period_tenth_mus;
	if (period_val >= 10 * ONE_MILLION)
	{
		period_val -= 10 * ONE_MILLION;
		++system_time_in_secs;
	}

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



