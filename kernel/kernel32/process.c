

#include "mem/paging.h"
#include "mem/gdt32.h"

#include "drivers/hardware.h"
#include "drivers/timer.h"
#include "drivers/vga.h"

#include "libs32/kalloc.h"
#include "libs32/klib.h"

#include "libs/structs.h"
#include "libs/utils.h"

#include "fs/gendrivers.h"

#include "kernel32/objects.h"
#include "kernel32/process.h"

uint32_t _usercode_phys;

tss_t *global_tss;

//process_t* process_table[NUM_PROCESSES];

struct list_head* global_proc_list;
struct list_head* global_free_proc_list;


process_t* current;
process_t* next;

process_node_t* current_node;
process_node_t* next_node;


void* p_tss_current;
void* p_tss_next;

void* p_new_esp0;

uint32_t proc_switch_count;

volatile uint32_t schedule_off;
uint32_t num_procs;


// experimental switch with register saving and loading from
// kernel stack (eax ecx edx are non-preserved)

#define SWITCH_XP(cur_tss,next_tss) asm __volatile__ ( \
	/*	"movb $'F', %%al \n\t" */ \
	/*	"outb %%al, $0xe9 \n\t"  */ \
						"movl " #cur_tss  ", %%edx \n\t" \
						"popl %%ecx \n\t" /* ebp */ \
						"movl %%ecx, " XSTR(OFFSET_EBP) "(%%edx) \n\t" \
						"popl %%ecx \n\t" /* ret eip */ \
						"movl %%ecx, " XSTR(OFFSET_EIP) "(%%edx) \n\t" \
						\
						/* "pushl %%eax \n\t" */ \
						"pushl %%ebx \n\t" \
						"pushl %%ecx \n\t" \
						/* "pushl %%edx \n\t" */ \
						"pushl %%esi \n\t" \
						"pushl %%edi \n\t" \
						\
						"pushfl \n\t" \
						\
						"movl %%cr3, %%eax \n\t" \
						"pushl %%eax \n\t" \
						\
						\
						"pushw %%fs \n\t" \
						"pushw %%gs \n\t" \
						"pushw %%es \n\t" \
						"pushw %%ss \n\t" \
						"pushw %%cs \n\t" \
						"pushw %%ds \n\t" \
						\
						/* "movb $'G', %%al \n\t" */ \
						/* "outb %%al, $0xe9 \n\t" */ \
						\
						\
						"movl %%esp, " XSTR(OFFSET_ESP) "(%%edx) \n\t"  /* save old esp last */ \
						\
						"movl " #next_tss ", %%edx \n\t"  /* here heart of task-switch: new esp loaded */ \
						"movl " XSTR(OFFSET_ESP) "(%%edx), %%eax \n\t" \
						"movl %%eax, %%esp \n\t" \
						\
						/* "movb $'H', %%al \n\t" */ \
						/* "outb %%al, $0xe9 \n\t" */ \
						\
						"movl " #next_tss ", %%edx \n\t" \
						"movl " XSTR(OFFSET_ESP0) "(%%edx), %%eax \n\t" \
						"movl global_tss, %%edx \n\t" \
						"movl %%eax, " XSTR(OFFSET_ESP0) "(%%edx) \n\t" \
						"movl " #next_tss ", %%edx \n\t" \
						"movw " XSTR(OFFSET_SS0) "(%%edx), %%ax \n\t" \
						"movl global_tss, %%edx \n\t" \
						"movw %%ax, " XSTR(OFFSET_SS0) "(%%edx) \n\t" \
						"movl " #next_tss ", %%edx \n\t" \
						\
						/* "movb $'I', %%al \n\t" */ \
						/* "outb %%al, $0xe9 \n\t" */ \
						\
						"popw %%ax \n\t movw %%ax, %%ds \n\t" \
						"popw %%ax \n\t" /* cs skipped, can not be loaded, only by far ret */ \
						"popw %%ax \n\t movw %%ax, %%ss \n\t" \
						"popw %%ax \n\t movw %%ax, %%es \n\t" \
						"popw %%ax \n\t movw %%ax, %%gs \n\t" \
						"popw %%ax \n\t movw %%ax, %%fs \n\t" \
					  \
						\
						/* "movb $'J', %%al \n\t" */ \
						/* "outb %%al, $0xe9 \n\t" */ \
						\
						"popl %%eax \n\t" \
						"movl %%eax, %%cr3 \n\t" \
						\
						"popfl \n\t" \
						\
						"movl " XSTR(OFFSET_EBP) "(%%edx), %%eax \n\t " \
						"movl %%eax, %%ebp \n\t" \
						\
						"movl next, %%eax \n\t" \
						"movl %%eax, current \n\t" \
						\
						\
						"popl %%edi \n\t" \
						"popl %%esi \n\t" \
						/* "popl %%edx \n\t" */ \
						"popl %%ecx \n\t" \
						"popl %%ebx \n\t" \
						/* "popl %%eax \n\t" */ \
						\
						"movl " XSTR(OFFSET_EIP) "(%%edx), %%eax \n\t" \
						"pushl %%eax \n\t" \
						/* "movb $'F', %%al \n\t" */ \
						/* "outb %%al, $0xe9 \n\t" */ \
						\
						"ret \n\t" \
: )


// current is dead, do not save or use it

#define SWITCH_XP2(next_tss) asm __volatile__ ( \
	/*	"movb $'F', %%al \n\t" */ \
	/*	"outb %%al, $0xe9 \n\t"  */ \
						\
						"movl " #next_tss ", %%edx \n\t"  /* here heart of task-switch: new esp loaded */ \
						"movl " XSTR(OFFSET_ESP) "(%%edx), %%eax \n\t" \
						"movl %%eax, %%esp \n\t" \
						\
						/* "movb $'H', %%al \n\t" */ \
						/* "outb %%al, $0xe9 \n\t" */ \
						\
						"movl " #next_tss ", %%edx \n\t" \
						"movl " XSTR(OFFSET_ESP0) "(%%edx), %%eax \n\t" \
						"movl global_tss, %%edx \n\t" \
						"movl %%eax, " XSTR(OFFSET_ESP0) "(%%edx) \n\t" \
						"movl " #next_tss ", %%edx \n\t" \
						"movw " XSTR(OFFSET_SS0) "(%%edx), %%ax \n\t" \
						"movl global_tss, %%edx \n\t" \
						"movw %%ax, " XSTR(OFFSET_SS0) "(%%edx) \n\t" \
						"movl " #next_tss ", %%edx \n\t" \
						\
						/* "movb $'I', %%al \n\t" */ \
						/* "outb %%al, $0xe9 \n\t" */ \
						\
						"popw %%ax \n\t movw %%ax, %%ds \n\t" \
						"popw %%ax \n\t" /* cs skipped, can not be loaded, only by far ret */ \
						"popw %%ax \n\t movw %%ax, %%ss \n\t" \
						"popw %%ax \n\t movw %%ax, %%es \n\t" \
						"popw %%ax \n\t movw %%ax, %%gs \n\t" \
						"popw %%ax \n\t movw %%ax, %%fs \n\t" \
					  \
						\
						/* "movb $'J', %%al \n\t" */ \
						/* "outb %%al, $0xe9 \n\t" */ \
						\
						"popl %%eax \n\t" \
						"movl %%eax, %%cr3 \n\t" \
						\
						"popfl \n\t" \
						\
						"movl " XSTR(OFFSET_EBP) "(%%edx), %%eax \n\t " \
						"movl %%eax, %%ebp \n\t" \
						\
						"movl next, %%eax \n\t" \
						"movl %%eax, current \n\t" \
						\
						\
						"popl %%edi \n\t" \
						"popl %%esi \n\t" \
						/* "popl %%edx \n\t" */ \
						"popl %%ecx \n\t" \
						"popl %%ebx \n\t" \
						/* "popl %%eax \n\t" */ \
						\
						"movl " XSTR(OFFSET_EIP) "(%%edx), %%eax \n\t" \
						"pushl %%eax \n\t" \
						/* "movb $'F', %%al \n\t" */ \
						/* "outb %%al, $0xe9 \n\t" */ \
						\
						"ret \n\t" \
: )




#if 0
// old context-swich code

// remember stack of current before switching:
// no remember stack

#define SWITCH(cur_tss,next_tss) asm __volatile__ ( \
																						"pushl %%ebx \n\t" \
																						"movl " #cur_tss  ", %%ebx \n\t" \
																						SAVEREG(EAX) \
																						SAVEREG(ECX) \
																						SAVEREG(EDX) \
																						"popl %%edx \n\t" /* ebx */ \
																						"movl %%edx, " XSTR(OFFSET_EBX) "(%%ebx) \n\t" \
																						"popl %%edx \n\t" /* ebp */ \
																						"movl %%edx, " XSTR(OFFSET_EBP) "(%%ebx) \n\t" \
																						"popl %%ecx \n\t" /* ret eip */ \
																						"movl %%ecx, " XSTR(OFFSET_EIP) "(%%ebx) \n\t" \
																						"pushfl \n\t" \
																						"popl %%eax \n\t" \
																						"movl %%eax," XSTR(OFFSET_EFLAGS) "(%%ebx) \n\t" \
																						SAVEREG(ESI) \
																						SAVEREG(EDI) \
																						SAVEREG(ESP) \
																						"movl %%cr3, %%eax \n\t" \
																						"movl %%eax, " XSTR(OFFSET_CR3) "(%%ebx) \n\t" \
																						SAVEREG_SEG(FS) \
																						SAVEREG_SEG(GS) \
																						SAVEREG_SEG(ES) \
																						SAVEREG_SEG(SS) \
																						SAVEREG_SEG(CS) \
																						SAVEREG_SEG(DS) \
																						"movl " #next_tss ", %%ebx \n\t" \
																						"movl " XSTR(OFFSET_ESP0) "(%%ebx), %%eax \n\t" \
																						"movl global_tss, %%ebx \n\t" \
																						"movl %%eax, " XSTR(OFFSET_ESP0) "(%%ebx) \n\t" \
																						"movl " #next_tss ", %%ebx \n\t" \
																						"movw " XSTR(OFFSET_SS0) "(%%ebx), %%ax \n\t" \
																						"movl global_tss, %%ebx \n\t" \
																						"movw %%ax, " XSTR(OFFSET_SS0) "(%%ebx) \n\t" \
																						"movl " #next_tss ", %%ebx \n\t" \
																						LOADREG(ECX) \
																						LOADREG(EDX) \
																						LOADREG(ESI) \
																						LOADREG(EDI) \
																						LOADREG(EBP) \
																						"movl " XSTR(OFFSET_CR3) "(%%ebx), %%eax \n\t" \
																						"movl %%eax, %%cr3 \n\t" \
																						LOADREG_SEG(FS) \
																						LOADREG_SEG(GS) \
																						LOADREG_SEG(ES) \
																						"movw " XSTR(OFFSET_SS) "(%%ebx), %%ax \n\t" \
																						"movw %%ax, %%ss \n\t" /* ss */ \
																						"movl " XSTR(OFFSET_ESP) "(%%ebx), %%eax \n\t" \
																						"movl %%eax, %%esp \n\t" /* esp */ \
																						"movl " XSTR(OFFSET_EFLAGS) "(%%ebx), %%eax \n\t" \
																						"pushl %%eax \n\t" \
																						"movw $0, %%ax \n\t" \
																						"pushw %%ax \n\t" \
																						"movw " XSTR(OFFSET_CS) "(%%ebx), %%ax \n\t" \
																						"pushw %%ax \n\t" /* ss */ \
																						"movl next, %%eax \n\t" \
																						"movl %%eax, current \n\t" \
																						"movl " XSTR(OFFSET_EIP) "(%%ebx), %%eax \n\t" \
																						"pushl %%eax \n\t" /* eip */ \
																						"movl " XSTR(OFFSET_EAX) "(%%ebx), %%eax \n\t" \
																						"pushl %%eax \n\t" /* eax */\
																						"movl " XSTR(OFFSET_EBX) "(%%ebx), %%eax \n\t" \
																						"pushl %%eax \n\t" /* ebx */ \
																						"movw " XSTR(OFFSET_DS) "(%%ebx), %%ax \n\t" \
																						"movw %%ax, %%ds \n\t" \
																						"popl %%ebx \n\t" \
																						"popl %%eax \n\t" \
																						"iretl" : )

#define SWITCH_TO_USER(cur_tss,next_tss) asm __volatile__ ( \
																						"pushl %%ebx \n\t" \
																						"movl " #cur_tss  ", %%ebx \n\t" \
																						SAVEREG(EAX) \
																						SAVEREG(ECX) \
																						SAVEREG(EDX) \
																						"popl %%edx \n\t" /* ebx */ \
																						"movl %%edx, " XSTR(OFFSET_EBX) "(%%ebx) \n\t" \
																						"popl %%edx \n\t" /* ebp */ \
																						"movl %%edx, " XSTR(OFFSET_EBP) "(%%ebx) \n\t" \
																						"popl %%ecx \n\t" /* ret eip */ \
																						"movl %%ecx, " XSTR(OFFSET_EIP) "(%%ebx) \n\t" \
																						"pushfl \n\t" \
																						"popl %%eax \n\t" \
																						"movl %%eax," XSTR(OFFSET_EFLAGS) "(%%ebx) \n\t" \
																						SAVEREG(ESI) \
																						SAVEREG(EDI) \
																						SAVEREG(ESP) \
																						"movl %%cr3, %%eax \n\t" \
																						"movl %%eax, " XSTR(OFFSET_CR3) "(%%ebx) \n\t" \
																						SAVEREG_SEG(FS) \
																						SAVEREG_SEG(GS) \
																						SAVEREG_SEG(ES) \
																						SAVEREG_SEG(SS) \
																						SAVEREG_SEG(CS) \
																						SAVEREG_SEG(DS) \
																						"movl " #next_tss ", %%ebx \n\t" \
																						"movl " XSTR(OFFSET_ESP0) "(%%ebx), %%eax \n\t" \
																						"movl global_tss, %%ebx \n\t" \
																						"movl %%eax, " XSTR(OFFSET_ESP0) "(%%ebx) \n\t" \
																						"movl " #next_tss ", %%ebx \n\t" \
																						"movw " XSTR(OFFSET_SS0) "(%%ebx), %%ax \n\t" \
																						"movl global_tss, %%ebx \n\t" \
																						"movw %%ax, " XSTR(OFFSET_SS0) "(%%ebx) \n\t" \
																						"movl " #next_tss ", %%ebx \n\t" \
																						LOADREG(ECX) \
																						LOADREG(EDX) \
																						LOADREG(ESI) \
																						LOADREG(EDI) \
																						LOADREG(EBP) \
																						"movl " XSTR(OFFSET_CR3) "(%%ebx), %%eax \n\t" \
																						"movl %%eax, %%cr3 \n\t" \
																						LOADREG_SEG(FS) \
																						LOADREG_SEG(GS) \
																						LOADREG_SEG(ES) \
																						"movw " XSTR(OFFSET_CS) "(%%ebx), %%ax \n\t" \
																						"andw $0x00003, %%ax \n\t" \
																						"cmpw $0x00003, %%ax \n\t" \
																						"je lower_privilege \n\t" \
																						"movw " XSTR(OFFSET_SS) "(%%ebx), %%ax \n\t" \
																						"movw %%ax, %%ss \n\t" /* ss */ \
																						"movl " XSTR(OFFSET_ESP) "(%%ebx), %%eax \n\t" \
																						"movl %%eax, %%esp \n\t" \
																						"jmp do_eflags \n\t" \
																						"lower_privilege: \n\t " \
																						"movw $0, %%ax \n\t" \
																						"pushw %%ax \n\t" \
																						"movw " XSTR(OFFSET_SS) "(%%ebx), %%ax \n\t" \
																						"pushw %%ax \n\t" /* ss */ \
																						"movl " XSTR(OFFSET_ESP) "(%%ebx), %%eax \n\t" \
																						"pushl %%eax \n\t" \
																						"do_eflags: \n\t" \
																						"movl " XSTR(OFFSET_EFLAGS) "(%%ebx), %%eax \n\t" \
																						"pushl %%eax \n\t" \
																						"movw $0, %%ax \n\t" \
																						"pushw %%ax \n\t" \
																						"movw " XSTR(OFFSET_CS) "(%%ebx), %%ax \n\t" \
																						"pushw %%ax \n\t" /* ss */ \
																						"movl next, %%eax \n\t" \
																						"movl %%eax, current \n\t" \
																						"movl " XSTR(OFFSET_EIP) "(%%ebx), %%eax \n\t" \
																						"pushl %%eax \n\t" /* eip */ \
																						"movl " XSTR(OFFSET_EAX) "(%%ebx), %%eax \n\t" \
																						"pushl %%eax \n\t" /* eax */\
																						"movl " XSTR(OFFSET_EBX) "(%%ebx), %%eax \n\t" \
																						"pushl %%eax \n\t" /* ebx */ \
																						"movw " XSTR(OFFSET_DS) "(%%ebx), %%ax \n\t" \
																						"movw %%ax, %%ds \n\t" \
																						"popl %%ebx \n\t" \
																						"popl %%eax \n\t" \
																						"iretl" : )

#endif

int init_global_tss()
{
	DEBUGOUT(0, "sizeof(tss_t) = %d\n", sizeof(tss_t));
	DEBUGOUT(0, "sizeof(process_t) = %d\n", sizeof(process_t));

	global_tss = get_tss_t();

	DESCRIPTOR_SET_SEG_ZERO(gdt_table_32[TSS_GDT_INDEX]);
	DESCRIPTOR_SET_GD_P_DPL_S_TYPX(gdt_table_32[TSS_GDT_INDEX], global_tss, 8191, 0, 0, 1, 0, 0, TSS_GDT_TYPX);


	asm __volatile__ ("movw %0, %%ax \n\t ltr %%ax" : : "g"(TSS_GDT_INDEX * 8): "%ax", "memory");

	DEBUGOUT(0, "End of init_global_tss.\n");

	return 0;
}


/*
 the following functions are very critical
 better not insert other code, so that
 the expected stack discipline remains intact.
 this means: ... | ret_addr | old_bp | as top of stack
 inserting for example 'printf' statements
 caused the stack to be not in right condition
 for SWITCH_XP
*/

void __NOINLINE schedule_1()
{
	p_tss_current = &current->proc_data.tss;
	p_tss_next = &next->proc_data.tss;

	SWITCH_XP(p_tss_current, p_tss_next);

}

// this is for scheduling when current has died
// so no saving of context can and must be done.
// instead only next is put to run.
void __NOINLINE schedule_2()
{
	//p_tss_current = &current->proc_data.tss;
	p_tss_next = &next->proc_data.tss;

	SWITCH_XP2(p_tss_next);

}


//
// schedule()
// current_node is the wandering pointer along the process_node_t list
//
void schedule()
{
	uint32_t status_next;

	if (schedule_off)
		return;

	uint32_t eflags = irq_cli_save();

	//printf("esp = %08x\ncs = %08x\nds = %08x\n", get_esp(), get_cs(), get_ds());

	if (!current)
	{
		outb_printf("schedule: current is 0.\n");
		current_node = container_of(global_proc_list->next, process_node_t, link);
	}
	else
	{
		current = current_node->proc;
		++current->proc_data.ticks;
	}

	//outb_printf("schedule: current node pid = %d\n", current_node->proc->proc_data.pid);


	do
	{
		next = (container_of((current_node->link.next), process_node_t, link))->proc;
		current_node = container_of(current_node->link.next, process_node_t, link);

		status_next = next->proc_data.status;
	}
	while (status_next != PROC_READY && status_next != PROC_RUNNING );

	//outb_printf("schedule: next pid = %d\n", next->proc_data.pid);

	if (current)
	{
		if (current->proc_data.status == PROC_RUNNING)
		{
			current->proc_data.status = PROC_READY;
		}
	}
	next->proc_data.status = PROC_RUNNING;

	++proc_switch_count;

	//printf("current = %08x next = %08x\n", (uint32_t) current, (uint32_t) next );


	outb(0xe9, 'H');
	outb(0xe9, 'H');

	if (current)
	{
		schedule_1();
	}
	else
	{
		schedule_2();
	}


	irq_restore(eflags);
}


void process_signals(uint32_t esp)
{
	if (current)
	{
		if (current->proc_data.signal_pending)
		{
			if (current->proc_data.handler_arg == 999)
			{
				exit_process(current);
			}
			else if (current->proc_data.handler)
			{
				call_user_handler(esp, current->proc_data.handler, current->proc_data.handler_arg);
			}
		}
	}
}


void print_iret_blk(iret_blk_t* pir)
{
	outb_printf("pir = %08x\n", (uint32_t) pir);
	outb_printf("pir->ss = %08x\n", (uint32_t) pir->ss);
	outb_printf("pir->esp = %08x\n", (uint32_t) pir->esp);
	outb_printf("pir->eflags = %08x\n", (uint32_t) pir->eflags);
	outb_printf("pir->cs = %08x\n", (uint32_t) pir->cs);
	outb_printf("pir->eip = %08x\n", (uint32_t) pir->eip);

}


void call_user_handler(uint32_t esp, uint32_t handler, uint32_t arg)
{

	outb_printf("\n");
	outb_printf("call_user_handler: esp = %08x\n", esp);

	iret_blk_t* pir = (iret_blk_t*) (esp + 36);
	print_iret_blk(pir);

	bool in_kernel_code = !(pir->cs & 0x03); // DPL is zero

	if (in_kernel_code)
	{
		return;
	}

	current->proc_data.signal_pending = 0;

	uint32_t *old_esp = (uint32_t*) pir->esp;

	*--old_esp = arg;
	*--old_esp = pir->eip;

	pir->esp = (uint32_t) old_esp;
	pir->eip = handler;

}

void exit_process()
{
	destroy_process(current);
}

void free_user_memory(process_t *proc)
{
	page_table_entry_t *page_dir_proc = __VADDR(proc->proc_data.tss.cr3);

	int i;
	for(i = 0; i < PG_PAGE_DIR_USER_ENTRIES; ++i)
	{
		free_page_table(&page_dir_proc[i]);
	}
	free_page_directory(page_dir_proc);
	proc->proc_data.tss.cr3 = get_cr3();

}


void destroy_io_data(process_t *proc)
{
	free_proc_io_block_t(proc->proc_data.io_block);
}

void take_out_of_global_proc_list(process_t *proc)
{
	INIT_LISTVAR(p);

	FORLIST(p, global_proc_list)
	{
		process_node_t *pnd = container_of(p, process_node_t, link);

		if (pnd->proc == proc)
		{
				DEBUGOUT1(0, "takes proc %08x out of global proc list.\n", (uint32_t) pnd->proc);
				//next_node_aux = container_of(pnd->link.next, process_node_t, link);

				delete_elem(&global_proc_list, &pnd->link);
				free_process_node_t(pnd);
				break;
		}

		p = p->next;

	}
	END_FORLIST(p, global_proc_list);

	int ncnt = 0;
	FORLIST(p, global_proc_list)
	{
			process_node_t *pnd = container_of(p, process_node_t, link);

			DEBUGOUT1(0, "take_out: pid = %d\n", pnd->proc->proc_data.pid);
			p = p->next;

			++ncnt;

	} while (ncnt < 8 || p != global_proc_list); }

}


void free_process_block(process_t *proc)
{
	process_node_t* pnd = get_process_node_t();
	pnd->proc = proc;
	prepend_list(&global_free_proc_list, &pnd->link);
}

void destroy_process(process_t* proc)
{

	proc->proc_data.status = PROC_EXIT;

	free_user_memory(proc);
	destroy_io_data(proc);
	take_out_of_global_proc_list(proc);
	remove_from_wait_queues(proc);
	release_sync_primitives(proc);
	free_process_block(proc);

	current = 0;

	sti();
	// start the dying loop. when next
	// timer hits then process is finished.
	while (1)
	{
		outb(0xe9, 'D');
		WAIT(1 << 15);
	}

}


