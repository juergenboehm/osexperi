

#include "kernel32/process.h"

#include "drivers/timer.h"
#include "drivers/hardware.h"
#include "drivers/pic.h"

volatile uint32_t timer_special_counter;
volatile uint32_t timer_sema;

#define PROC_DBG 0

void timer_irq_handler(uint32_t errcode, uint32_t irq_num, void* esp)
{
	timer_sema = 1;
	timer_special_counter++;

	// End of Interrupt (EOI) must be send at *end* of
	// interrupt routine

	//outb_0xe9( 'T');
	outb(PIC1_COMMAND, PIC_EOI);
	io_wait();

	uint32_t esp_val = get_esp();
/*
	if (timer_special_counter % 100 == 0) {
		printf("\n\ntimer_irq_handler: esp = 0x%08x\n\n", esp_val);
	}
*/

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



