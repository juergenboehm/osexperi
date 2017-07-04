#ifndef __kernel32_irq_h
#define __kernel32_irq_h

#include "kerneltypes.h"
#include "libs/kerneldefs.h"
#include "libs/structs.h"
#include "libs/idt.h"


#define NUM_IRQS	256
#define	IDT_TABLE_SIZE	256

// offsets to the registers in irq register save block on stack

#define IRQ_REG_OFFSET_AX		28
#define IRQ_REG_OFFSET_BX		24
#define IRQ_REG_OFFSET_CX		20
#define IRQ_REG_OFFSET_DX		16
#define IRQ_REG_OFFSET_SI		12
#define IRQ_REG_OFFSET_DI		8




// the following are imported symbols from .S

extern void irq_main();
extern void irq_no_errcode();




extern idt_entry* idt_table;
extern __volatile__ lim_addr_ptr idt_ptr;

typedef void (*irq_fun_type_ptr)(uint32_t errcode, uint32_t irq_num, void* esp);

extern volatile uint32_t syscall_parm;


void idt_set(int irq_num, irq_fun_type_ptr irq_handler);
void idt_set_trap(int irq_num, irq_fun_type_ptr irq_handler);

void idt_set_err(int irq_num, irq_fun_type_ptr irq_handler);
void idt_set_err_trap(int irq_num, irq_fun_type_ptr irq_handler);

void init_idt_table();

void irq_dispatcher(uint32_t errcode, uint32_t irq_num, void* esp);


#endif
