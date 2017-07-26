

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
#include "kernel32/proclife.h"
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

uint8_t pidbuf[NUM_PROCESSES/8];

static uint32_t pid_index = 0;

uint32_t get_new_pid()
{
	int cnt = 0;
	while (TESTBIT(pidbuf, pid_index))
	{
		++pid_index;
		++cnt;
		if (pid_index == NUM_PROCESSES)
		{
			pid_index = 1;
		}
		if (cnt >= NUM_PROCESSES)
		{
			break;
		}
	}
	if (cnt >= NUM_PROCESSES)
	{
		printf("error: can not get new pid. all slots full.\n");
		while(1) {};
	}
	SETBIT(pidbuf, pid_index);

	outb_printf("get_new_pid: pidbuf = %08x pid_index = %d\n", *((uint32_t*)&pidbuf[0]), pid_index);
	return pid_index;

}

void release_pid(uint32_t pid)
{
	CLRBIT(pidbuf, pid);
}


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
: : :  )


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
: : : )




#if 0
// old context-switch code

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


#define SCHEDULE_DBG 0

//
// schedule()
// current_node is the wandering pointer along the process_node_t list
//
void schedule()
{
	uint32_t status_next;

	if (schedule_off)
		return;

	IRQ_CLI_SAVE(eflags);

	//printf("esp = %08x\ncs = %08x\nds = %08x\n", get_esp(), get_cs(), get_ds());

	if (!current)
	{
		outb_printf("schedule: current is 0.\n");
		current_node = container_of(global_proc_list, process_node_t, link);
	}
	else
	{
		current = current_node->proc;
		++current->proc_data.ticks;
	}

#if SCHEDULE_DBG
	outb_printf("schedule: current node pid = %d\n", current_node->proc->proc_data.pid);
#endif

	do
	{
		next = (container_of((current_node->link.next), process_node_t, link))->proc;
		current_node = container_of(current_node->link.next, process_node_t, link);

		status_next = next->proc_data.status;
	}
	while (status_next != PROC_READY && status_next != PROC_RUNNING );

#if SCHEDULE_DBG
	outb_printf("schedule: next pid = %d\n", next->proc_data.pid);
#endif

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


	//outb(0xe9, 'H');
	//outb(0xe9, 'H');

	if (current)
	{
		schedule_1();
	}
	else
	{
		schedule_2();
	}


	IRQ_RESTORE(eflags);
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
#if 1
	outb_printf("pir = %08x\n", (uint32_t) pir);
	outb_printf("pir->ss = %08x\n", (uint32_t) pir->ss);
	outb_printf("pir->esp = %08x\n", (uint32_t) pir->esp);
	outb_printf("pir->eflags = %08x\n", (uint32_t) pir->eflags);
	outb_printf("pir->cs = %08x\n", (uint32_t) pir->cs);
	outb_printf("pir->eip = %08x\n", (uint32_t) pir->eip);
#endif

#if 0

	printf("pir = %08x\n", (uint32_t) pir);
	printf("pir->ss = %08x\n", (uint32_t) pir->ss);
	printf("pir->esp = %08x\n", (uint32_t) pir->esp);
	printf("pir->eflags = %08x\n", (uint32_t) pir->eflags);
	printf("pir->cs = %08x\n", (uint32_t) pir->cs);
	printf("pir->eip = %08x\n", (uint32_t) pir->eip);

#endif

}


void call_user_handler(uint32_t esp, uint32_t handler, uint32_t arg)
{

	outb_printf("\n");
	outb_printf("call_user_handler: esp = %08x\n", esp);

	iret_blk_t* pir = (iret_blk_t*) (esp + 36);
	//print_iret_blk(pir);

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

void free_page_directory(process_t *proc, page_table_entry_t *page_dir_proc)
{
	DEBUGOUT1(0, "freeing page_directory = %08x\n", (uint32_t) page_dir_proc);
	if (proc == current)
	{
		set_cr3((uint32_t)__PHYS(global_page_dir_sys));
		free(page_dir_proc);
	}
	else
	{
		free(page_dir_proc);
	}
}


void free_user_memory(process_t *proc)
{
	page_table_entry_t *page_dir_proc = __VADDR(proc->proc_data.tss.cr3);

	int i;
	for(i = 0; i < PG_PAGE_DIR_USER_ENTRIES; ++i)
	{
		free_page_table(&page_dir_proc[i]);
	}

	free_page_directory(proc, page_dir_proc);

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
	prepend_list(&global_free_proc_list, &(pnd->link));
}

void destroy_process(process_t* proc)
{

	outb_printf("destroy_process: current = %08x proc = %08x\n", (uint32_t)current, (uint32_t)proc);

	IRQ_CLI_SAVE(eflags);

	proc->proc_data.status = PROC_EXIT;

	uint32_t pid = proc->proc_data.pid;

	free_user_memory(proc);
	destroy_io_data(proc);
	take_out_of_global_proc_list(proc);
	remove_from_wait_queues(proc);
	release_sync_primitives(proc);
	free_process_block(proc);

	release_pid(pid);

	IRQ_RESTORE(eflags);

	if (current == proc)
	{
		current = 0;
		sti();
		// start the dying loop. when next
		// timer hits then process is finished.
		while (1)
		{
			outb_0xe9( 'D');
			WAIT(1 << 15);
		}
	}


}

int clone_file_t(file_t* old_file, file_t** new_file)
{
	DEBUGOUT1(0, "clone_file_t: sizeof(file_t) = %d\n", sizeof(file_t));

	if (!old_file)
	{
		*new_file = old_file;
		return 0;
	}

	file_t* pnew_file = get_file_t();

	memcpy(pnew_file, old_file, sizeof(file_t));

	DEBUGOUT1(0, "clone_file_t: after memcpy.\n");

	pnew_file->f_dentry = old_file->f_dentry;
	//++pnew_file->f_dentry->d_count;
	pnew_file->f_count = 0;

	*new_file = pnew_file;

	DEBUGOUT1(0, "clone_file_t: leave clone_file_t.\n");

	return 0;
}



int clone_proc_t(process_t* old_proc, process_t** new_proc)
{
	process_t* pnew_proc = get_process_t();

	if (!pnew_proc)
	{
		return -1;
	}
	memcpy(pnew_proc, old_proc, sizeof(process_t));

	*new_proc = pnew_proc;

	return 0;
}

int clone_proc_io_block_t(proc_io_block_t* old_ioblk, proc_io_block_t** new_ioblk)
{
	int ret;
	proc_io_block_t* pnew_ioblk = get_proc_io_block_t();

	int i;
	for(i = 0; i < NUM_BASE_FD_PROC; ++i)
	{
		 ret = clone_file_t(old_ioblk->base_fd_arr[i], &pnew_ioblk->base_fd_arr[i]);
		 if (pnew_ioblk->base_fd_arr[i])
		 {
			 ++pnew_ioblk->base_fd_arr[i]->f_count;
		 }
	}

	*new_ioblk = pnew_ioblk;

	return 0;

}


void build_artificial_switch_save_block(
		uint32_t ebx, uint32_t ecx, uint32_t esi, uint32_t edi, uint32_t cr3, uint32_t esp0, uint32_t* esp_new)
{

	switch_save_block_t* pssb = (switch_save_block_t*) (esp0 - sizeof(switch_save_block_t));

	pssb->ds = get_ds();
	pssb->cs = get_cs();
	pssb->ss = get_ss();
	pssb->es = get_es();
	pssb->fs = get_fs();
	pssb->gs = get_gs();

	pssb->cr3 = cr3;
	pssb->eflags = (get_eflags() | (1 << 9));

	pssb->edi = edi;
	pssb->esi = esi;
	pssb->ecx = ecx;
	pssb->ebx = ebx;

	*esp_new = (esp0 - sizeof(switch_save_block_t));

	return;
}

void clone_wq(process_t* new_proc, process_t* proc)
{
	wq_t *proc_wq = proc->proc_data.in_wq;
	if (proc_wq)
	{
		process_node_t* pnd = get_process_node_t();
		pnd->proc = new_proc;
		append_list(&proc_wq->head, &pnd->link);
		new_proc->proc_data.in_wq = proc_wq;
	}
}

int fork_process()
{
	uint32_t ret_eip;
	uint32_t old_bp;
	uint32_t goal_sp;

	IRQ_CLI_SAVE(eflags);


	DEBUGOUT1(0, "fork_process start: current = %08x", (uint32_t) current);

	int ret = -1;
	uint32_t new_page_dir_phys;
	process_t* proc = current;
	process_t* new_proc;

	// use the offset method!
	// (upper stack limit of child) - 76 is the position where the last valid
	// base pointer which is statuated by irq_dispatcher (irq_stub.S)
	// is located
	// 8 bytes above begins the kernel stack as it was before call
	// to irq_dispatcher

	old_bp = 76;
	goal_sp = old_bp - 8;

	// we write the artificial schedule switch save block
	// right after the parameter list of irq_dispatcher (see irq_stub.S)

	// eip in the child gets set right after call irq_dispatch in irq_stub.S

	ret = copy_page_tables(proc, &new_page_dir_phys, PG_PTCM_COPY_FOR_COW);

	if (ret)
	{
		goto ende;
	}

	ret = clone_proc_t(proc, &new_proc);

	if (ret)
	{
		goto ende;
	}

	clone_wq(new_proc, proc);


	old_bp = ((uint32_t) PROC_STACK_BEG(new_proc)) - old_bp;
	goal_sp = ((uint32_t) PROC_STACK_BEG(new_proc)) - goal_sp;

	ret_eip = *((uint32_t*)(old_bp + 4));

	DEBUGOUT(0, "fork_process renew: ret_eip = %08x, old_bp = %08x\n"
			"goal_sp = %08x\n", ret_eip, old_bp, goal_sp);


	DEBUGOUT1(0, "proc_t cloned.\n");

	proc_io_block_t* pnew_proc_io_block;

	ret = clone_proc_io_block_t(proc->proc_data.io_block, &pnew_proc_io_block);

	new_proc->proc_data.io_block = pnew_proc_io_block;

	uint32_t child_pid = get_new_pid();

	init_proc_basic(new_proc, child_pid, 0);

	new_proc->proc_data.status = PROC_STOPPED;

	init_proc_cr3(new_proc, new_page_dir_phys);

	uint32_t esp0_new = (uint32_t) PROC_STACK_BEG(new_proc);

	uint32_t* esp0_new_pt = (uint32_t*) esp0_new;

	// here we put the return value into %eax of the child
	*(esp0_new_pt - 7) = 0; //  offset = 28 bytes

	new_proc->proc_data.tss.esp0 = esp0_new;
	new_proc->proc_data.tss.ss0 = KERNEL32_DS;

	new_proc->proc_data.tss.ss = KERNEL32_DS;

	new_proc->proc_data.tss.ebp = 0;

	//esp0_global1 = goal_sp;

	// prepare kernel stack of next-process = process 0
	// so that task-switch to this process finds the stack
	// as if it has been left by a previous task-switch
	// which of course has not happened when process
	// is first activated.

	DEBUGOUT1(0, "before prepare fork_stack...\n");

	// setup the artificial schedule switch save block
	// for the child. Start at esp0_global1 = goal_sp

	uint32_t esp_new;
	build_artificial_switch_save_block(0, 0, 0, 0, new_page_dir_phys, goal_sp, &esp_new);


	new_proc->proc_data.tss.esp = esp_new;

	init_proc_eip(new_proc, ret_eip, 0);

	DEBUGOUT1(0, "ret eip = %08x, old_bp = %08x\n", new_proc->proc_data.tss.eip, old_bp);

	process_node_t* pnd_new = get_process_node_t();

	pnd_new->proc = new_proc;

	prepend_list(&global_proc_list, &(pnd_new->link));

	DEBUGOUT1(0, "new_proc signal handler = %08x\n", new_proc->proc_data.handler);

	ende:

	DEBUGOUT1(0, "leaving fork parent.\n");

	IRQ_RESTORE(eflags);

	return child_pid;
}


