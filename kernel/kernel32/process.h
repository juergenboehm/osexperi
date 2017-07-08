
#ifndef __kernel32_process_h
#define __kernel32_process_h

#include "kerneltypes.h"
#include "mem/paging.h"
#include "mem/vmem_area.h"

#include "fs/vfs.h"

#include "libs/lists.h"


#define NUM_PROCESSES 16

#define PROCESS_BLOCKSIZE (2 * PAGE_SIZE)

typedef struct __PACKED iret_blk_s {
	uint32_t eip;
	uint16_t cs;
	uint16_t zero2;
	uint32_t eflags;
	uint32_t esp;
	uint16_t ss;
	uint16_t zero1;
} iret_blk_t;


struct __PACKED tss_s {

	uint16_t bk_link;
	uint16_t upper_dummy_0;

	uint32_t esp0;
	uint16_t ss0;
	uint16_t upper_dummy_8;
	uint32_t esp1;
	uint16_t ss1;
	uint16_t upper_dummy_16;
	uint32_t esp2;
	uint16_t ss2;
	uint16_t upper_dummy_24;

	uint32_t cr3;
	uint32_t eip;
	uint32_t eflags;
	uint32_t eax;
	uint32_t ecx;
	uint32_t edx;
	uint32_t ebx;
	uint32_t esp;
	uint32_t ebp;
	uint32_t esi;
	uint32_t edi;

	uint16_t es;
	uint16_t upper_dummy_es;
	uint16_t cs;
	uint16_t upper_dummy_cs;
	uint16_t ss;
	uint16_t upper_dummy_ss;
	uint16_t ds;
	uint16_t upper_dummy_ds;
	uint16_t fs;
	uint16_t upper_dummy_fs;
	uint16_t gs;
	uint16_t upper_dummy_gs;

	uint16_t ldt;
	uint16_t upper_dummy_ldt;

	uint16_t top_low;
	uint16_t top_io_map_base;

};

typedef struct tss_s tss_t;

#define OFFSET_ESP0	0x04
#define OFFSET_SS0	0x08
#define OFFSET_ESP1	0x0c
#define OFFSET_SS1	0x10
#define OFFSET_ESP2 0x14
#define OFFSET_SS2	0x18
#define OFFSET_CR3	0x1c
#define OFFSET_EIP	0x20
#define OFFSET_EFLAGS	0x24

#define OFFSET_EAX	0x28
#define OFFSET_ECX	0x2c

#define OFFSET_EDX	0x30
#define OFFSET_EBX	0x34
#define OFFSET_ESP	0x38
#define OFFSET_EBP	0x3c
#define OFFSET_ESI	0x40
#define OFFSET_EDI	0x44

#define OFFSET_ES		0x48
#define OFFSET_CS		0x4c
#define OFFSET_SS		0x50
#define OFFSET_DS		0x54
#define OFFSET_FS		0x58
#define OFFSET_GS		0x5c

#define OFFSET_LDT	0x60



#define PROC_READY 		0
#define PROC_BLOCKED 	1
#define PROC_RUNNING 	2
#define PROC_STOPPED	3
#define PROC_EXIT			4


#define NUM_BASE_FD_PROC	16



typedef struct __PACKED proc_io_block_s {

	file_t* base_fd_arr[NUM_BASE_FD_PROC];

} proc_io_block_t;


typedef struct __PACKED process_data_s {

	tss_t tss;
	vm_map_t* vm_map;

	proc_io_block_t* io_block;

	// core infos

	uint32_t pid;

	uint32_t ticks;

	uint32_t status;

	// signal handling

	uint32_t handler;
	uint32_t handler_arg;
	uint32_t signal_pending;

} process_data_t;

typedef union {
	char dummy[PROCESS_BLOCKSIZE];
	process_data_t proc_data;
} process_t;



typedef struct process_node_t
{
	list_head_t link;

	process_t* proc;

} process_node_t;



extern tss_t* global_tss;
//extern process_t* process_table[NUM_PROCESSES];

extern process_t* current;
extern process_t* next;

extern struct list_head* global_proc_list;
extern struct list_head* global_free_proc_list;

extern process_node_t* current_node;
extern process_node_t* next_node;

extern void* p_tss_current;
extern void* p_tss_next;

extern void* p_new_esp0;

extern uint32_t proc_switch_count;

extern volatile uint32_t schedule_off;

extern uint32_t num_procs;


int init_global_tss();

void schedule();

void process_signals(uint32_t esp);
void call_user_handler(uint32_t esp, uint32_t handler, uint32_t arg);

void exit_process();
void free_user_memory(process_t *proc);
void destroy_process(process_t* proc);


// useful for inline assembly macros

#define PROC_STACK_BEG(p) (((uint8_t*)p) + 8188)

#define STR(X) #X
#define XSTR(X) STR(X)

#define SAVEREG(REG) "movl %%" #REG "," XSTR(OFFSET_##REG) "(%%ebx) \n\t"
#define SAVEREG_SEG(REG) "movw %%" #REG "," XSTR(OFFSET_##REG) "(%%ebx) \n\t"

#define LOADREG(REG) "movl "  XSTR(OFFSET_##REG) "(%%ebx), %%" #REG  "\n\t"
#define LOADREG_SEG(REG) "movw "  XSTR(OFFSET_##REG) "(%%ebx), %%" #REG  "\n\t"

#define LOADREG_SEG_DX(REG) "movw "  XSTR(OFFSET_##REG) "(%%edx), %%" #REG  "\n\t"





#endif
