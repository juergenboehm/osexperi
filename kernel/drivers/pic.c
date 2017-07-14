
#include "kerneltypes.h"
#include "drivers/hardware.h"
#include "drivers/pic.h"






/* PIC functions */

#define INIT_SIZE_LEN	4

void init_pic_single(uint8_t* iw_pic_list, uint16_t* port_list)
{
		int i = 0;

		for(i = 0; i < INIT_SIZE_LEN; ++i )
		{
				outb(port_list[(i == 0) ? 0 : 1], iw_pic_list[i] );
				io_wait();
		}
}


#define	PIC1_ICW_SEQ	PIC_INIT_CMD, PIC1_IRQ_BASE, 0x04, 0x01

#define	PIC2_ICW_SEQ	PIC_INIT_CMD, PIC2_IRQ_BASE, 0x02, 0x01

// timer: 0 keyboard: 1 : cascade PIC2: 2
#define PIC1_START_MASK (PIC_MASK(0) & PIC_MASK(1) & PIC_MASK(2))

// ide: 6
#define PIC2_START_MASK (PIC_MASK(6))


void init_pic()
{
		int i = 0;

		uint8_t iw_pic1_list[INIT_SIZE_LEN] = {PIC1_ICW_SEQ};

		uint16_t port_pic1[2] = {PIC1_COMMAND, PIC1_DATA};

		init_pic_single(iw_pic1_list, port_pic1);

		outb(PIC1_DATA, 0xff); // disable all interrupt lines
		io_wait();

		uint8_t iw_pic2_list[INIT_SIZE_LEN] = {PIC2_ICW_SEQ};

		uint16_t port_pic2[2] = {PIC2_COMMAND, PIC2_DATA};

		init_pic_single(iw_pic2_list, port_pic2);

		outb(PIC2_DATA, 0xff); // disable all interrupt lines
		io_wait();

		enable_irq(PIC_TIMER_IRQ);
		enable_irq(PIC_KEYB_IRQ);
		enable_irq(PIC_PIC2_IRQ);

		enable_irq(PIC_IDE_IRQ);


}

void init_pic_alt()
{
		outb(PIC1_COMMAND, PIC_INIT_CMD);  // starts the initialization sequence (in cascade mode)
		io_wait();
		outb(PIC2_COMMAND, PIC_INIT_CMD);
		io_wait();
		outb(PIC1_DATA, PIC1_IRQ_BASE);                 // ICW2: Master PIC vector offset
		io_wait();
		outb(PIC2_DATA, PIC2_IRQ_BASE);                 // ICW2: Slave PIC vector offset
		io_wait();
		outb(PIC1_DATA, 4);                       // ICW3: tell Master PIC that there is a slave PIC at IRQ2 (0000 0100)
		io_wait();
		outb(PIC2_DATA, 2);                       // ICW3: tell Slave PIC its cascade identity (0000 0010)
		io_wait();

		outb(PIC1_DATA, 0x01);
		io_wait();
		outb(PIC2_DATA, 0x01);
		io_wait();

		outb(PIC1_DATA, 0xff); // disable all interrupt lines
		io_wait();

		outb(PIC2_DATA, 0xff); // disable all interrupt lines
		io_wait();

		outb(PIC1_DATA, 0xff);   // initialize irq masks to all disable
		outb(PIC2_DATA, 0xff);

		enable_irq(PIC_TIMER_IRQ);
		enable_irq(PIC_KEYB_IRQ);
		enable_irq(PIC_PIC2_IRQ);

		enable_irq(PIC_IDE_IRQ);


}


// port B, respectively port data is for setting and getting the mask

void set_irq(uint8_t irq_num, uint32_t enable)
{
  uint8_t port = irq_num < 8 ? PIC1_DATA : PIC2_DATA;
  uint8_t val = inb(port);
  io_wait();
  uint8_t i = irq_num % 8;
  val = enable ? val & PIC_MASK(i) : val | ~PIC_MASK(i);
  outb(port, val);
  io_wait();
}

void enable_irq(uint8_t irq_num)
{
  set_irq(irq_num, 1);
}

void disable_irq(uint8_t irq_num)
{
  set_irq(irq_num, 0);
}

