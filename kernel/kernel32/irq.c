
#include "libs/kerneldefs.h"
#include "libs/generaldefs.h"
#include "libs/utils.h"

#include "libs32/klib.h"
#include "kernel32/irq.h"
#include "drivers/hardware.h"
#include "drivers/pic.h"
#include "drivers/ide.h"
#include "drivers/keyb.h"
#include "drivers/timer.h"

#include "syscalls/syscalls.h"

#include "kernel32/process.h"

#include "mem/paging.h"


idt_entry* idt_table;

__volatile__ lim_addr_ptr idt_ptr;

irq_fun_type_ptr irq_disp_table[NUM_IRQS];

volatile uint32_t syscall_parm;


void irq_dispatcher(uint32_t errcode, uint32_t irq_num, void* esp)
{
/*
 * just to see if errcode is correctly transferred
 * showed error in code first.
	if (errcode != 0)
	{
		printf("errcode != 0: irq_num = %d\n", irq_num);
		while (1);
	}
*/
	(*irq_disp_table[irq_num])(errcode, irq_num, esp);
}

// makes entries in the IDT for interrupts without error code
// the default code at irq_no_errcode + irq_num * IRQ_JUMP_TABLE_ALIGN
// pushes a 0x0L onto the stack in place of errcode
// then it jumps to the corresponding code of the irq_main jump table
// for routines where an errorcode on the stack is assumed.

void idt_set(int irq_num, irq_fun_type_ptr irq_handler)
{

	uint32_t offset_in_irq_no_errcode =
			BASE_PLUS_IDX_TIMES_MULT_TYP(irq_no_errcode, irq_num, IRQ_JUMP_TABLE_ALIGN, uint32_t);

	IDT_ENTRY_SET_P_DPL_IRQ(idt_table[irq_num], KERNEL32_CS, offset_in_irq_no_errcode, 1, KPL);

	irq_disp_table[irq_num] = irq_handler;

}

void idt_set_trap(int irq_num, irq_fun_type_ptr irq_handler)
{

	uint32_t offset_in_irq_no_errcode =
			BASE_PLUS_IDX_TIMES_MULT_TYP(irq_no_errcode, irq_num, IRQ_JUMP_TABLE_ALIGN, uint32_t);

	IDT_ENTRY_SET_P_DPL_TRAP(idt_table[irq_num], KERNEL32_CS, offset_in_irq_no_errcode, 1, KPL);

	irq_disp_table[irq_num] = irq_handler;

}

void idt_set_trap_user(int irq_num, irq_fun_type_ptr irq_handler)
{

	uint32_t offset_in_irq_no_errcode =
			BASE_PLUS_IDX_TIMES_MULT_TYP(irq_no_errcode, irq_num, IRQ_JUMP_TABLE_ALIGN, uint32_t);

	IDT_ENTRY_SET_P_DPL_TRAP(idt_table[irq_num], KERNEL32_CS, offset_in_irq_no_errcode, 1, UPL);

	irq_disp_table[irq_num] = irq_handler;

}

// make entries in the IDT for interrupts that produce an error code
// this is the default

void idt_set_err(int irq_num, irq_fun_type_ptr irq_handler)
{

	uint32_t offset_in_irq_main = BASE_PLUS_IDX_TIMES_MULT_TYP(irq_main, irq_num, IRQ_JUMP_TABLE_ALIGN, uint32_t);

	IDT_ENTRY_SET_P_DPL_IRQ(idt_table[irq_num], KERNEL32_CS, offset_in_irq_main, 1, KPL);

	irq_disp_table[irq_num] = irq_handler;
}

void idt_set_err_trap(int irq_num, irq_fun_type_ptr irq_handler)
{

	uint32_t offset_in_irq_main = BASE_PLUS_IDX_TIMES_MULT_TYP(irq_main, irq_num, IRQ_JUMP_TABLE_ALIGN, uint32_t);

	IDT_ENTRY_SET_P_DPL_TRAP(idt_table[irq_num], KERNEL32_CS, offset_in_irq_main, 1, KPL);

	irq_disp_table[irq_num] = irq_handler;
}

void dummy_handler(uint32_t errcode, uint32_t irq_num, void* esp)
{
	if (irq_num == 39)
	{
	  printf("Spurious interrupt: errcode = %d irq_num = %d.\n", errcode, irq_num);
	}
	else
	{
	  printf("Dummy interrupt: errcode = %d irq_num = %d.\n", errcode, irq_num);
	  while (1) {};
	}
}

void stack_fault_handler(uint32_t errcode, uint32_t irq_num, void* esp)
{
	printf("Stack fault: errcode = %d irq_num = %d.\n", errcode, irq_num);
	outb_printf("Stack fault: errcode = %d irq_num = %d.\n", errcode, irq_num);
	while (1) {}
}

void segment_not_present_handler(uint32_t errcode, uint32_t irq_num, void* esp)
{
	outb_printf("Segment not present: errcode = %d irq_num = %d.\n", errcode, irq_num);
	while (1) {}
}

void gpf_handler(uint32_t errcode, uint32_t irq_num, void* esp)
{
	printf("General Protection Fault: errcode = %d irq_num = %d.\n", errcode, irq_num);
	outb_printf("General Protection Fault: errcode = %d irq_num = %d.\n", errcode, irq_num);
	while (1) {}
}

void illegal_opcode_handler(uint32_t errcode, uint32_t irq_num, void* esp)
{
	printf("Illegal opcode: errcode = %d irq_num = %d.\n", errcode, irq_num);
	outb_printf("Illegal opcode: errcode = %d irq_num = %d.\n", errcode, irq_num);
	while (1) {}
}


void init_idt_table()
{

	int irq_num = 0;

	for(irq_num = 0; irq_num < 8; ++irq_num)
	{
		idt_set(irq_num, dummy_handler);
	}

	idt_set(6, illegal_opcode_handler);

	for(irq_num = 8; irq_num < 16; ++irq_num)
	{
		idt_set_err(irq_num, dummy_handler);
	}

	idt_set_err_trap(11, segment_not_present_handler);
	idt_set_err_trap(12, stack_fault_handler);
	idt_set_err_trap(13, gpf_handler);
	idt_set_err(14, page_fault_handler);

	idt_set(16, dummy_handler);
	idt_set_err(17, dummy_handler);

	for(irq_num = 18; irq_num < 32; ++irq_num)
	{
		idt_set(irq_num, dummy_handler);
	};

	for(irq_num = 32; irq_num < 256; ++irq_num)
	{
		idt_set(irq_num, dummy_handler);
	};

	idt_set_trap_user(128, syscall_handler);

	idt_set(PIC1_IRQ_BASE + 0x00, timer_irq_handler );
	idt_set(PIC1_IRQ_BASE + 0x01, keyb_irq_handler );

	idt_set(PIC2_IRQ_BASE + 0x06, ide_irq_handler );


}
