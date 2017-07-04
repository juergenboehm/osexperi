
#include "drivers/hardware.h"
#include "drivers/pic.h"
#include "drivers/vga.h"
#include "drivers/keyb.h"




uint32_t keyb_special_counter;
uint32_t keyb_buf[KEYBUF_SIZE];

volatile uint32_t keyb_sema;


queue_contr_t keyb_queue;

uint32_t init_keyboard()
{
	reset_queue(&keyb_queue, KEYBUF_SIZE, sizeof(uint32_t), (void*)keyb_buf);
	return 0;
}

uint32_t reset_keyboard()
{
	uint32_t eflags = irq_cli_save();
	init_keyboard();
	irq_restore(eflags);
}


uint32_t read_keyb_byte()
{
	uint32_t key = 0;
	if (key_avail())
	{
	  get_queue(&keyb_queue, &key);
	}

	return key;
}

inline uint32_t key_avail()
{
	return !is_empty_queue(&keyb_queue);
}

#define MK_F1	0x3b
#define MK_F2	0x3c
#define MK_F3	0x3d
#define MK_F4	0x3e



void keyb_irq_handler(uint32_t errcode, uint32_t irq_num, void* esp)
{
	keyb_special_counter++;
	uint32_t keyb_scan_code = inb(0x60);

	uint8_t kst = (uint8_t)(keyb_scan_code & 0x000000ff);

	if (kst >= MK_F1 && kst <= MK_F4) {
		screen_current_old = screen_current;
		screen_current = kst - MK_F1;

		// these keys are never queued

	} else {


		outb(0xe9, (uint8_t)( keyb_scan_code & 0x000000ff));

		keyb_sema = 1;
		if (! is_full_queue(&keyb_queue))
		{
			put_queue(&keyb_queue, &keyb_scan_code);
		}
	}
	// PIC port A is command port. used to acknowledge interrupt.
	// EOI as usual at end of interrupt routine

	outb(PIC1_COMMAND, PIC_EOI);
	io_wait();
}
