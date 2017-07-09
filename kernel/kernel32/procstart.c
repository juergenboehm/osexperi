


#include "mem/paging.h"
#include "mem/gdt32.h"

#include "drivers/hardware.h"
#include "drivers/keyb.h"
#include "drivers/keyb_decode.h"
#include "drivers/timer.h"
#include "drivers/vga.h"

#include "libs32/kalloc.h"
#include "libs32/klib.h"

#include "libs/structs.h"
#include "libs/utils.h"

#include "fs/gendrivers.h"

#include "kernel32/process.h"
#include "kernel32/objects.h"
#include "kernel32/proclife.h"

#include "kernel32/baseprocs.h"

#include "kernel32/procstart.h"


uint32_t stack_old;
uint32_t stack_new;
uint32_t esp0_global;

uint32_t ax_old;
uint32_t cx_old;


void insert_process(process_t * proc, list_head_t** pproc_list_head, uint32_t status)
{
	process_node_t* new_node = get_process_node_t();
	new_node->proc = proc;
	proc->proc_data.status = status;

	prepend_list(pproc_list_head, &(new_node->link));
	printf("proc_list_head = %08x\n", *pproc_list_head);


// for debugging

	struct list_head* p = *pproc_list_head;
	int i = 0;

	printf("proc_list_head = %08x\n", *pproc_list_head);

	do {
		process_node_t* pn = container_of(p, process_node_t, link);
		printf("Process inserted : %d: node = %08x : proc = %08x\n", i, p, pn->proc);
		++i;
		p = p->next;

		if (i > 5) {
			while (1) {}
		}
	} while (p != *pproc_list_head);

	//WAIT(5*(1 << 24));

}

// new version of init_process_1 with SWITCH_XP context switch model

void attach_io_block(process_t * proc, file_t* f_stdin, file_t* f_stdout)
{
	proc_io_block_t* p_new_proc_io_block = get_proc_io_block_t();

	// fixed_file_list[i] is the /dev/vga<i> file
	p_new_proc_io_block->base_fd_arr[0] = f_stdin;
	p_new_proc_io_block->base_fd_arr[1] = f_stdout;

	proc->proc_data.io_block = p_new_proc_io_block;

	outb_printf("attach_io_block: proc = %08x io_block = %08x\n",
			(uint32_t) proc,
			(uint32_t) proc->proc_data.io_block);

}

void prepare_process(void* fun_addr, int pid, file_t* f_stdin, file_t* f_stdout)
{

	uint32_t i;

	process_t* new_process = get_process_t();

	attach_io_block(new_process, f_stdin, f_stdout);

	insert_process(new_process, &global_proc_list, PROC_READY);

	uint32_t* esp0 = (uint32_t*) PROC_STACK_BEG(new_process);

	// global variable: is used in assembly code
	// esp0_global = (uint32_t) esp0;

	// user stack is set at end of procedure! here it is set 0.
	init_proc_tss_stacks(new_process, (uint32_t) esp0, 0);

	init_proc_eip(new_process, (uint32_t) fun_addr, 0);

	init_proc_cr3(new_process, get_cr3());

	printf("old page dir phys addr = %08x\n", new_process->proc_data.tss.cr3);

	//WAIT(30 * (1 << 24));

	init_proc_basic(new_process, pid, 0);

	init_proc_handler(new_process);

	p_tss_next = &new_process->proc_data.tss;

	++num_procs;

	outb_printf("prepare_process_stack: before enter asm...\n");


	// prepare kernel stack of next-process = process 0
	// so that task-switch to this process finds the stack
	// as if it has been left by a previous task-switch
	// which of course has not happened when process
	// is first activated.

	uint32_t esp_new;

	build_artificial_switch_save_block(0, 0, 0, 0, get_cr3(), (uint32_t)esp0, &esp_new);

	new_process->proc_data.tss.esp = esp_new;


}

uint32_t npid0;
uint32_t npid1;
uint32_t npid2;


void init_process_1_xp(void* fun_addr)
{
	uint32_t i;
	uint32_t j;

	cli();

	schedule_off = 1;

	global_proc_list = 0;
	global_free_proc_list = 0;

	outb_printf("\n");

	npid0 = get_new_pid();
	npid1 = get_new_pid();
	npid2 = get_new_pid();

	// /dev/vga1
	prepare_process(idle_forever, npid0, NULL, &fixed_file_list[DEV_VGA1]);
	// /dev/vga2
	prepare_process(idle_vn, npid1, NULL, &fixed_file_list[DEV_VGA2]);
	// /dev/vga0
	prepare_process(idle_watched, npid2, NULL, &fixed_file_list[DEV_VGA0]);


	uint32_t new_page_dir_phys_addr;

/*

// for debugging:
	printf("esp0_next_idle_forever = %08x stack new = %08x\n", esp0_next_idle_forever, stack_new);

	for(i = 0; i < 6; ++i) {
		printf("word = %04x\n", *(((uint16_t*) stack_new) + i));
	}

	for(i = 0; i < 2 + 4; ++i) {
		printf("dword = %08x\n", *(((uint32_t*) stack_new) + 3 + i));
	}

	for(i = 0; i < 5; ++i) {
		waitkey();
	}

*/

	outb_printf("init_process_1_xp: initial processes entered..\n");

	// current is the first user process

	current = get_process_t();
	insert_process(current, &global_proc_list, PROC_READY);
	current_node = container_of(global_proc_list, process_node_t, link);

	p_tss_current = &current->proc_data.tss;

	memset(current, 0, sizeof(process_t));
	memset(&current->proc_data.tss, 0, sizeof(tss_t));

	// /dev/vga3
	attach_io_block(current, NULL, &fixed_file_list[DEV_VGA3]);

	uint32_t npid3 = get_new_pid();

	init_proc_basic(current, npid3 , 0);

	current->proc_data.status = PROC_READY;

	init_proc_handler(current);

	uint32_t* esp0_system = (uint32_t*)PROC_STACK_BEG(current);

	init_proc_tss_stacks(current, (uint32_t) esp0_system, USER32_STACK);


	page_table_entry_t* new_page_dir;
	make_page_directory(&new_page_dir_phys_addr, &new_page_dir);

	init_proc_cr3(current, new_page_dir_phys_addr);

	printf("new page dir phys addr = %08x\n", new_page_dir_phys_addr);

	//WAIT(30 * (1 << 24));

	const int is_user_mode_process = 1;

	init_proc_tss_segments(current, is_user_mode_process);

	init_proc_eip(current, (uint32_t) fun_addr, 0);


	uint32_t eflags = irq_cli_save();
	init_proc_eflags(current, eflags | (1 << 9));

	printf("current->eflags = %08x\n", current->proc_data.tss.eflags);

	//WAIT(1 << 24);

	DEBUGOUT(0, "_usercode_phys = %08x\nlen16 = %08x\nlen32 = %08x\n", _usercode_phys, _len16, _len32);

	uint32_t real_usercode_phys = 0x100000 + _usercode_phys;
	uint32_t usercode_virtual = 0x1000;

	for(i = 0, j = 0; i < 5; ++i, j += PAGE_SIZE) {
		map_page((usercode_virtual + j),
				(real_usercode_phys + j), new_page_dir, PG_BIT_P | PG_BIT_RW | PG_BIT_US);
	}

	DEBUGOUT(0, "pages mapped.\n");

	proc_switch_count = 0;

	outb_printf("init_process_1_xp: proc = %08x io_block = %08x\n",
			(uint32_t) current,
			(uint32_t) current->proc_data.io_block);


	outb_printf("init_process_1_xp: before asm...\n");

	//WAIT(20 * (1 << 24));

	screen_current = 3;

	schedule_off = 0;

	++num_procs;

	// jump with iret into lower privilege user level

	reset_keyboard();


	asm __volatile__ ( \
	"lower_privilege_qq: \n\t " \
	\
	"movl p_tss_current, %%edx \n\t" \
	\
	"movl " XSTR(OFFSET_CR3) "(%%edx), %%eax \n\t" \
	"movl %%eax, %%cr3 \n\t" \
	LOADREG_SEG_DX(FS) \
	LOADREG_SEG_DX(GS) \
	LOADREG_SEG_DX(ES) \
	\
	"movl " XSTR(OFFSET_ESP0) "(%%edx), %%eax \n\t" \
	"movl global_tss, %%edx \n\t" \
	"movl %%eax, " XSTR(OFFSET_ESP0) "(%%edx) \n\t" \
	"movl p_tss_current, %%edx \n\t" \
	"movw " XSTR(OFFSET_SS0) "(%%edx), %%ax \n\t" \
	"movl global_tss, %%edx \n\t" \
	"movw %%ax, " XSTR(OFFSET_SS0) "(%%edx) \n\t" \
	"movl p_tss_current, %%edx \n\t" \
	\
	"movw $0, %%ax \n\t" \
	"pushw %%ax \n\t" \
	"movw " XSTR(OFFSET_SS) "(%%edx), %%ax \n\t" \
	"pushw %%ax \n\t" /* ss */ \
	"movl " XSTR(OFFSET_ESP) "(%%edx), %%eax \n\t" \
	"pushl %%eax \n\t" \
	"do_eflags_qq: \n\t" \
	"movl " XSTR(OFFSET_EFLAGS) "(%%edx), %%eax \n\t" \
	"pushl %%eax \n\t" \
	"movw $0, %%ax \n\t" \
	"pushw %%ax \n\t" \
	"movw " XSTR(OFFSET_CS) "(%%edx), %%ax \n\t" \
	"pushw %%ax \n\t" /* ss */ \
	"movl " XSTR(OFFSET_EIP) "(%%edx), %%eax \n\t" \
	"pushl %%eax \n\t" /* eip */ \
	"movw " XSTR(OFFSET_DS) "(%%edx), %%ax \n\t" \
	"movw %%ax, %%ds \n\t" \
	\
	"movb $'Y', %%al \n\t"  \
	"outb %%al, $0xe9 \n\t"  \
	\
	"iretl" : );

}
