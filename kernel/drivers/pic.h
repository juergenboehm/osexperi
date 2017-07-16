#ifndef __drivers_pic_h
#define __drivers_pic_h


#include "kerneltypes.h"
#include "libs/utils.h"

/* PIC functions */

#define	PIC1_COMMAND		0x20
#define PIC1_DATA				0x21

#define PIC2_COMMAND		0xa0
#define PIC2_DATA				0xa1

// the PIC IRQ numbers

#define PIC_TIMER_IRQ   0
#define PIC_KEYB_IRQ    1
#define PIC_PIC2_IRQ    2

#define PIC_PIC2_BASE_IRQ  8

#define PIC_IDE_IRQ     PIC_PIC2_BASE_IRQ + 6

// the index in the IDT table

#define PIC1_IRQ_BASE				0x20
#define PIC2_IRQ_BASE				0x28

#define PIC_MASK(i)  ((uint8_t)(~(1<<i)))


#define PIC_EOI 0x20

#define PIC_INIT_CMD 0x11

void set_irq(uint8_t irq_num, uint32_t enable);
void enable_irq(uint8_t irq_num);
void disable_irq(uint8_t irq_num);

uint8_t pic_get_in_service(uint8_t is_master);


void init_pic();
void init_pic_alt();








#endif
