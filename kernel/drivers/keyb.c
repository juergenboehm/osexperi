
#include "drivers/hardware.h"
#include "drivers/pic.h"
#include "drivers/vga.h"
#include "drivers/keyb.h"

#include "kernel32/mutex.h"


uint32_t keyb_special_counter;
uint32_t keyb_buf[NUM_SCREENS][KEYBUF_SIZE];

volatile uint32_t keyb_sema;


queue_contr_t keyb_queue[NUM_SCREENS];

uint32_t init_keyboard()
{
	int i;
	for(i = 0; i < NUM_SCREENS; ++i)
	{
		reset_queue(&keyb_queue[i], KEYBUF_SIZE, sizeof(uint32_t), (void*)(&keyb_buf[i]));
	}
	return 0;
}

uint32_t reset_keyboard()
{
	IRQ_CLI_SAVE(eflags);
	init_keyboard();
	IRQ_RESTORE(eflags);

	return 0;
}


uint32_t read_keyb_byte(int keyb)
{
	uint32_t key = 0;
	sema_down(&key_read_sema[keyb]);

	get_queue(&keyb_queue[keyb], &key);

	return key;
}

inline uint32_t key_avail(int keyb)
{
	return sema_get(&key_read_sema[keyb]) > 0;
//	return !is_empty_queue(&keyb_queue[keyb]);
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


		outb_0xe9( (uint8_t)( keyb_scan_code & 0x000000ff));

		sema_up(&key_read_sema[screen_current]);

		if (! is_full_queue(&keyb_queue[screen_current]))
		{
			put_queue(&keyb_queue[screen_current], &keyb_scan_code);
		}
	}
	// PIC port A is command port. used to acknowledge interrupt.
	// EOI as usual at end of interrupt routine

	outb(PIC1_COMMAND, PIC_EOI);
	io_wait();
}
