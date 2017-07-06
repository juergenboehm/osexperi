

#include "kernel32/process.h"

#include "drivers/timer.h"
#include "drivers/hardware.h"
#include "drivers/pic.h"

volatile uint32_t timer_special_counter;
volatile uint32_t timer_sema;



void timer_irq_handler(uint32_t errcode, uint32_t irq_num, void* esp)
{
	timer_sema = 1;
	timer_special_counter++;

	// End of Interrupt (EOI) must be send at *end* of
	// interrupt routine

	outb(0xe9, 'T');
	outb(PIC1_COMMAND, PIC_EOI);
	io_wait();

	uint32_t esp_val = get_esp();
	if (timer_special_counter % 100 == 0) {
		//printf("\n\ntimer_irq_handler: esp = 0x%08x\n\n", esp_val);
	}

	schedule();

	process_signals((uint32_t) esp);


}



