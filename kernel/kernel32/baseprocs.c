
#include "mem/paging.h"
#include "mem/gdt32.h"
#include "mem/pagedesc.h"
#include "mem/malloc.h"
#include "mem/memmain.h"

#include "drivers/hardware.h"
#include "drivers/keyb.h"
#include "drivers/keyb_decode.h"
#include "drivers/timer.h"
#include "drivers/vga.h"
#include "drivers/ide.h"

#include "libs32/kalloc.h"
#include "libs32/klib.h"

#include "libs/structs.h"
#include "libs/utils.h"
#include "libs/lists.h"

#include "fs/ext2.h"
#include "fs/gendrivers.h"
#include "fs/bufcache.h"

#include "kernel32/mutex.h"
#include "kernel32/process.h"
#include "kernel32/procstart.h"

#include "kernel32/baseprocs.h"


char* proc_state_list[] = { "ready", "blocked", "running", "stopped", "exit" };


void exit(uint32_t exit_code)
{
	while (1) {};
}


void display_tss(tss_t* tss)
{
	printf("esp = 0x%08x\n", tss->esp);
	printf("ss = 0x%08x\n", tss->ss);

	printf("esp0 = 0x%08x\n", tss->esp0);
	printf("ss0 = 0x%08x\n", tss->ss0);

	printf("ebp = 0x%08x\n", tss->ebp);

	printf("ebx = 0x%08x\n", tss->ebx);
	printf("eax = 0x%08x\n", tss->ebx);
	printf("ecx = 0x%08x\n", tss->ebx);
	printf("edx = 0x%08x\n", tss->ebx);

	printf("esi = 0x%08x\n", tss->esi);
	printf("edi = 0x%08x\n", tss->edi);

	printf("ds = 0x%08x\n", tss->ds);
	printf("es = 0x%08x\n", tss->es);

}

int syncj(int j)
{
	mtx_lock(&ide_buf_mutex);

	INIT_LISTVAR(p);

	FORLIST(p, global_ide_buf_list[j].use_list_head)
	{
		buf_node_t* pbuf = container_of(p, buf_node_t, link);
		if (pbuf->dirty)
		{
			outb_printf("written dirty sec: %d\n", pbuf->sec_num);
			writeblk_ide(pbuf->fil, pbuf->sec_num, pbuf->bufp);
			pbuf->dirty = 0;
		}
		p = p->next;
	}
	END_FORLIST(p, global_ide_buf_list[j].use_list_head);


	mtx_unlock(&ide_buf_mutex);


	return 0;

}

void idle_process()
{

	uint32_t i = 0;
	uint32_t j = 0;

	uint32_t old_system_ticks = system_ticks;

	while (1)
	{
		//printf("running: %d : system_ticks = %d\n", i, system_ticks);

		{

			outb_printf("idle_process: writing hash list %d\n", j);

			syncj(j);

			j = (j+1) % NUM_HASH_IDE_BUF_LIST;

			sleep(2);

		}

		++i;
	}
}

int readline_echo(char* buffer, int *cnt)
{
	const int max_screen_line_len = 65;

	int max_len = *cnt;
	char *p = buffer;

	int curr_cnt = -1; // at the beginning: unknown = -1;

	*p = 0;

	int char_cnt = 0;

	while (1)
	{
		uint32_t keyb_full_code = getc(0);

		uint8_t ascii_code = (keyb_full_code >> 16) & 0xff;

		if (ascii_code != 0)
		{
			uint8_t display_code = (ascii_code >= 32) ? ascii_code : 32;
			if (ascii_code == ASCII_CR)
			{
				goto ende;
			}
			else if (ascii_code == ASCII_BS)
			{
				if (char_cnt > 0 && ((curr_cnt == -1) || (curr_cnt > 0)))
				{
					display_code = ascii_code;
					--char_cnt;
					--p;
					*p = 0;
					if (curr_cnt > 0)
					{
						--curr_cnt;
					}
					printf("%c", display_code);
				}
			}
			else if (char_cnt < max_len)
			{
				*p = display_code;
				++p;
				*p = 0;
				++char_cnt;
				if (curr_cnt >= 0)
				{
					++curr_cnt;
				}
				printf("%c", display_code);

				if (char_cnt && !(char_cnt % max_screen_line_len))
				{
					curr_cnt = 0;
					printf("\n");
				}

			}

		}
	}

	ende:

	*cnt = char_cnt;

	return 0;

}


int execute_calc(int argc, char* argv[])
{

	const char* ops[4] = { "+", "-", "*", "/" };
	const int stack_len = 16;

	int res;
	int stack[stack_len];

	// stack grows downward
	int sp = stack_len;


	int i;
	int j;

	for(i = 1; i < argc; ++i)
	{
		for(j = 0; j < 4; ++j)
		{
			if (!strcmp(ops[j], argv[i])) {
				break;
			}
		}
		if (j == 4)
		{
			// push number on stack
			if (sp > 0)
			{
				int n1 = atoi(argv[i]);
				stack[--sp] = n1;
			} else {
				printf("calc: stack overflow.\n");
				return -1;
			}
		}
		else if (0 <= j && j < 4)
		{
			int res;
			switch (j)
			{
				case 0: res = stack[sp+1] + stack[sp];
								stack[++sp] = res;
								break;
				case 1: res = stack[sp+1] - stack[sp];
								stack[++sp] = res;
								break;
				case 2: res = stack[sp+1] * stack[sp];
								stack[++sp] = res;
								break;
				case 3: res = stack[sp+1] / stack[sp];
								stack[++sp] = res;
								break;


			}
		}
	}

	res = stack[sp];

	printf("%d\n", res);
	return 0;
}

void print_proc_info_line(process_t* proc)
{
	printf("pid = %d ticks = %d status = %s, waitq = %08x",
			proc->proc_data.pid,
			proc->proc_data.ticks,
			proc_state_list[proc->proc_data.status],
			proc->proc_data.in_wq);
}


int execute_sync(int argc, char* argv[])
{

	int j;

	for(j = 0; j < NUM_HASH_IDE_BUF_LIST; ++j)
	{
		syncj(j);
	}

	printf("sync: done.\n");

	return 0;
}



int execute_sig(int argc, char* argv[])
{
	int ret = -1;

	if (argc < 3)
	{
		printf("sig: too few arguments.\n");
		return -1;
	}

	uint32_t ntimes = 1;
	uint32_t delay = 1 << 20;

	if (argc > 3) {
		ntimes = atoi(argv[3]);
	}

	uint32_t pid = atoi(argv[1]);
	uint32_t arg = atoi(argv[2]);

	int np = 0;


	int found = 0;

	int i;
	for(i = 0; i < ntimes; ++i)
	{
		IRQ_CLI_SAVE(eflags);

		INIT_LISTVAR(p);

		FORLIST(p, global_proc_list)
		{
			process_node_t *pnd = container_of(p, process_node_t, link);

			process_t *proc = pnd->proc;

			if (proc->proc_data.pid == pid)
			{
				proc->proc_data.handler_arg = arg;
				proc->proc_data.signal_pending = 1;

				ret = 0;
				found = 1;
				break;
			}
			++np;
			p = p->next;

		}
		END_FORLIST(p, global_proc_list);

		IRQ_RESTORE(eflags);
		WAIT(delay);
	}

	if (!found)
	{
		printf("sig: process not found.\n");
	}

	return ret;
}


int execute_ps(int argc, char* argv[])
{
	printf("ps: started.\n");
	int np = 0;

	INIT_LISTVAR(p);
	FORLIST(p, global_proc_list)
	{
			process_node_t *pnd = container_of(p, process_node_t, link);

			print_proc_info_line(pnd->proc);
			printf("\n");

			++np;
			p = p->next;

	}
	END_FORLIST(p, global_proc_list);

	return 0;

}



int execute_sst(int argc, char* argv[])
{
	int np = 0;

	printf("sst: started.\n");

	if (argc < 3) {
		printf("sst: too few arguments.\n");
		return -1;
	}

	uint32_t pid = atoi(argv[1]);

	uint32_t status;
	uint32_t max_status = sizeof(proc_state_list)/sizeof(proc_state_list[0]);
	for(status = 0; status < max_status; ++status)
	{
		if (!strcmp(argv[2], proc_state_list[status]))
		{
			break;
		}
	}
	if (status == max_status)
	{
		printf("sst: illegal status.");
		return -1;
	}

	IRQ_CLI_SAVE(eflags);

	INIT_LISTVAR(p);
	FORLIST(p, global_proc_list)
	{
		process_node_t *pnd = container_of(p, process_node_t, link);

		if (pnd->proc->proc_data.pid == pid)
		{
			pnd->proc->proc_data.status = status;
			goto unlock;
		}
		++np;
		p = p->next;

	}
	END_FORLIST(p, global_proc_list)

	unlock: IRQ_RESTORE(eflags);

}

int execute_kill(int argc, char* argv[])
{
	if (argc < 2)
	{
		printf("kill: use: kill <pid>");
		return -1;
	}

	uint32_t pid = atoi(argv[1]);

	INIT_LISTVAR(p);
	FORLIST(p, global_proc_list)
	{
		process_node_t *pnd = container_of(p, process_node_t, link);

		if (pnd->proc->proc_data.pid == pid)
		{
				printf("kill: destroy_process pid = %d\n", pid);
				destroy_process(pnd->proc);
				break;
		}

		p = p->next;

	}
	END_FORLIST(p, global_proc_list);

	printf("kill: kill %d done\n", pid);

	return 0;
}

int execute_spd(int argc, char* argv[])
{

	if (argc < 3) {
		printf("spd: too few arguments.\n");
		return -1;
	}

	int npid = atoi(argv[1]);
	int from_index = atoi(argv[2]);
	int to_index = from_index;

	if (argc > 3) {
		to_index = atoi(argv[3]);
	}

	INIT_LISTVAR(p);
	FORLIST(p, global_proc_list)
	{
		process_node_t *pnd = container_of(p, process_node_t, link);
		process_data_t *pdata = &pnd->proc->proc_data;

		if (pdata->pid == npid) {

			int i;
			uint32_t pdentry = 0;

			uint32_t page_dir_phys_addr = pdata->tss.cr3;

			for(i = from_index; i <= to_index; ++i)
			{
					get_page_dir_entry(page_dir_phys_addr, i, &pdentry);
					printf("page_dir_phys_addr = %08x: page dir entry[%d] = %08x\n",
							page_dir_phys_addr, i, pdentry);
			}

			return 0;
		}

		p = p->next;

	}
	END_FORLIST(p, global_proc_list);

	printf("spd: process not found.\n");

	return -1;
}


int execute_spdx(int argc, char* argv[])
{

	if (argc < 2) {
		printf("spdx: too few arguments.\n");
		return -1;
	}

	int npid = atoi(argv[1]);


	INIT_LISTVAR(p);
	FORLIST(p, global_proc_list)
	{
		process_node_t *pnd = container_of(p, process_node_t, link);
		process_data_t *pdata = &pnd->proc->proc_data;

		if (pdata->pid == npid) {

			int i;
			IRQ_CLI_SAVE(eflags);
			uint32_t pdentry = 0;

			uint32_t page_dir_phys_addr = pdata->tss.cr3;

			uint32_t pdir_index;
			uint32_t ptable_index;

			page_table_entry_t* page_dir = (page_table_entry_t*)__VADDR(page_dir_phys_addr);

			for(pdir_index = 0; pdir_index < PG_PAGE_DIR_USER_ENTRIES; ++pdir_index)
			{

				uint32_t pdir_entry_phys = PG_PTE_GET_FRAME_ADDRESS(page_dir[pdir_index]);

				if (pdir_entry_phys)
				{
					page_table_entry_t* p_akt_pagetable = __VADDR(pdir_entry_phys);
					uint32_t mode_bits_pdir = PG_PTE_GET_BITS(page_dir[pdir_index]);

					for(ptable_index = 0; ptable_index < PG_PAGE_TABLE_ENTRIES; ++ptable_index)
					{

						uint32_t page_frame_phys = PG_PTE_GET_FRAME_ADDRESS(p_akt_pagetable[ptable_index]);

						if (page_frame_phys)
						{
							uint32_t mode_bits_ptab = PG_PTE_GET_BITS(p_akt_pagetable[ptable_index]);

							uint32_t current_vaddr =
									(pdir_index << (PG_FRAME_BITS + PG_PAGE_TABLE_BITS)) + (ptable_index << PG_FRAME_BITS);


							printf("d %08x : t %08x : f %08x : vaddr = %08x : mbd %02x : mbt: %02x\n",
									page_dir_phys_addr, pdir_entry_phys, page_frame_phys, current_vaddr,
									(uint8_t)mode_bits_pdir, (uint8_t) mode_bits_ptab);;
						}
					}
				}
			}

			IRQ_RESTORE(eflags);

			return 0;
		}

		p = p->next;

	}
	END_FORLIST(p, global_proc_list);

	printf("spdx: process not found.\n");

	return -1;
}

int execute_mem(int argc, char* argv[])
{
	uint32_t total_free_bytes;
	uint32_t used_bytes;
	uint32_t free_bytes_buddy;
	uint32_t used_buddy;
	uint32_t unusable_bytes;
	uint32_t zero_flags_pages;
	uint32_t nomem_pages;
	uint32_t not_nomem_pages;
	uint32_t alloc_pages;

	zero_flags_pages = get_flags_eq_pages_count(0);
	not_nomem_pages = get_not_pages_count(PDESC_FLAG_NOMEM);
	nomem_pages = get_pages_count(PDESC_FLAG_NOMEM, 0);
	alloc_pages = get_pages_count(PDESC_FLAG_ALLOC, 0);

	total_free_bytes = not_nomem_pages * PAGE_SIZE;

	unusable_bytes = nomem_pages * PAGE_SIZE;

	printf("Total number of pages = %d\n", num_pages_total);

	printf("Pages with NOMEM = %d : Pages without NOMEM = %d\n",
			nomem_pages, not_nomem_pages);
	printf("Pages with flags = zero = %d\n", zero_flags_pages);
	printf("Pages with ALLOC = %d\n", alloc_pages);

	printf("Total Pages used for small mallocs = %d\n", get_malloc_pages_count());
	printf("Bytes without NOMEM set = %d\n", not_nomem_pages * PAGE_SIZE);
	printf("Total bytes minus unusable areas = %d\n", num_pages_total * PAGE_SIZE - unusable_bytes);
	printf("Initial free mem buddy = %d\n", initial_free_mem_buddy);
	printf("Unusable areas: %d bytes.\n", unusable_bytes);

	get_order_stat(1, &free_bytes_buddy);

	used_bytes = total_free_bytes - free_bytes_buddy;

	used_buddy = initial_free_mem_buddy - free_bytes_buddy;

	printf("total = %d : used = %d \n",
			total_free_bytes, used_bytes );
	printf("free buddy = %d bytes : used buddy = %d bytes.\n",
			free_bytes_buddy, used_buddy);

	const int max_tally_use_cnt = 4;
	int tally_use_cnt[max_tally_use_cnt];
	int i;
	memset(tally_use_cnt, 0, sizeof(tally_use_cnt));

	int pdi;
	for(pdi = 0; pdi < num_pages_total; ++pdi)
	{
		page_desc_t* pdesc = BLK_PTR(pdi);
		uint32_t use_cnt = pdesc->use_cnt;
		if (use_cnt < max_tally_use_cnt - 1)
		{
			++tally_use_cnt[use_cnt];
		}
		else
		{
			++tally_use_cnt[max_tally_use_cnt -1];
		}
	}

	printf("use_cnt histo: ");
	for(i = 0; i < max_tally_use_cnt; ++i)
	{
		printf("(%d : %d), ", i, tally_use_cnt[i]);
	}
	printf("\n");

	mtx_lock(&ide_buf_mutex);

	INIT_LISTVAR(p);

	int len_ide_freelist = 0;

	FORLIST(p, global_ide_buf_free_list)
	{
		p = p->next;
		++len_ide_freelist;

	}
	END_FORLIST(p, global_ide_buf_free_list);

	mtx_unlock(&ide_buf_mutex);

	printf("number of used ide_bufs = %d\n", MAX_NUM_BUFS - len_ide_freelist);

	uint32_t sum = 0;
	for(i = 0; i < NUM_HASH_IDE_BUF_LIST; ++i)
	{
		sum += global_ide_buf_list[i].length;
	}
	printf("summed length of bin lists = %d\n", sum);

	return 0;
}

int execute_mtx(int argc, char* argv[])
{
	if (argc < 3)
	{
		printf("mtx: usage: mtx <mutex num> l|u.\n");
		return -1;
	}
	int mtx_index = atoi(argv[1]);
	int do_lock = !strcmp(argv[2], "l") ? 1 : !strcmp(argv[2], "u") ? 0 : -1;
	if (do_lock == -1)
	{
		printf("mtx: second parameter must be l|u.\n");
		return -1;
	}
	if (do_lock)
	{
		mtx_lock(&init_mutex_table[mtx_index]);
	}
	else
	{
		mtx_unlock(&init_mutex_table[mtx_index]);
	}
	return 0;

}

int execute_sem(int argc, char* argv[])
{
	if (argc < 4)
	{
		printf("sem: usage: sem <sema_index> u|d num");
	}

	uint32_t sema_idx = atoi(argv[1]);
	int do_up = !strcmp(argv[2], "u") ?  1: !strcmp(argv[2], "d") ? 0 : -1;
	uint32_t num = atoi(argv[3]);
	if (do_up == -1)
	{
		printf("sem: second parameter must be u|d.\n");
	}
	while (num--)
	{
		if (do_up)
		{
			sema_up(&init_sema_table[sema_idx]);
		}
		else
		{
			sema_down(&init_sema_table[sema_idx]);
		}
	}

	return 0;
}

int execute_ide(int argc, char* argv[])
{
	if (argc < 2)
	{
		printf("ide: usage: ide rd|wr|id|sf|tst [<blk_num>] [<dev_num>]\n");
		return -1;
	}

#define OPC_ID 0
#define OPC_SF 1
#define OPC_RD 2
#define OPC_TST 3
#define OPC_WR 4
#define OPC_ERR -1

	uint32_t opcode = !strcmp(argv[1], "id") ? OPC_ID :
						!strcmp(argv[1], "sf") ? OPC_SF : !strcmp(argv[1], "rd") ? OPC_RD :
								!strcmp(argv[1], "tst") ? OPC_TST:
								!strcmp(argv[1], "wr") ? OPC_WR: OPC_ERR;

	if (opcode == OPC_ERR)
	{
		printf("ide: illegal op: must be rd|id|sf|ext2");
		return -1;
	}

	uint32_t dev_num = 0;
	uint32_t blk_num = 0;

	if (argc > 3)
	{
		dev_num = atoi(argv[3]);
	}
	if (argc > 2)
	{
		blk_num = atoi(argv[2]);
	}

	if (dev_num != 0 && dev_num != 1)
	{
		printf("ide: illegal dev_num: must be 0 or 1.\n");
		return -1;
	}

	printf("ide: blk_num = %d : dev_num = %d\n", blk_num, dev_num);

	switch (opcode)
	{
	case OPC_RD:

		// do read through file /dev/ide<x>

		outb_printf("opcode = 3.\n");

		memset(ide_buffer, 0, 512);

		file_t* devide = &fixed_file_list[DEV_IDE + dev_num];

		devide->f_fops->readblk(devide, blk_num, (char**)&ide_buffer);

		display_buffer(ide_buffer, 512);
		break;

	case OPC_WR:
	{
		// do read through file /dev/ide<x>

		outb_printf("opcode = 5. Doing write. blk_num = 1024\n");

		file_t* devide = &fixed_file_list[DEV_IDE];

		int i;

		if (dev_num == 1)
		{
			for(i = 0; i < 512; ++i)
			{
				ide_buffer[i] = i % 256;
			}
		}
		else if (dev_num == 0)
		{
			memset(ide_buffer, 0, 512);
		}

		devide->f_fops->writeblk(devide, blk_num, (char*)ide_buffer);

		display_buffer(ide_buffer, 512);
	}
	break;

	case OPC_TST:
	{
		// do read through file /dev/ide<x>
		file_t* devide1 = &fixed_file_list[DEV_IDE];
		test_read_write(devide1);
	}
	break;

	case OPC_ID:
	{
		ide_test(0, blk_num);
	}
	break;
	case OPC_SF:
	{
		ide_test(1, blk_num);
	}
	break;
	default:
		break;
	}

	return 0;
}

int execute_cat(int argc, char* argv[])
{

	if (argc < 2)
	{
		printf("cat: usage: cat <path>\n");
		return -1;

	}

#if 0
	if (!strcmp("dummy", argv[1]))
	{
		int i;
		char* pline = (char*) malloc(128);

		for(i = 0; i < 75; ++i){
			pline[i] = 'A' + (rand() >> 5) % 30;
		}
		pline[i] = 0;

		for(i = 0; i < 860; ++i)
		{
			printf("%s\n", pline);
		}

		free(pline);

		return 0;
	}
#endif

	file_t *dev_file = &fixed_file_list[DEV_IDE + 1];

	inode_ext2_t res_inode;

	char* demo_path = argv[1];
	int nlen = strlen(demo_path);

	//outb_printf("nlen = %d : demo_path = %s", nlen, demo_path);

	file_ext2_t root_dir;
	init_file_ext2(&root_dir, dev_file, gsb_ext2);
	file_ext2_t out_file;
	init_file_ext2(&out_file, dev_file, gsb_ext2);


	read_inode_ext2(&root_dir, 2);

	char* last_fname = (char*) malloc(EXT2_NAMELEN + 1);

	parse_path_ext2(&root_dir, 0, demo_path, &out_file, last_fname);

	printf("content of %s\n", demo_path);

	display_inode_ext2(&out_file);

	destroy_file_ext2(&out_file);
	destroy_file_ext2(&root_dir);

	free(last_fname);


	return 0;

}



int execute_date(int argc, char* argv[])
{
	char buf[64];
	tm_t tm1;
	uint32_t system_secs = get_secs_time();

	printf("date: seconds = %d\n", system_secs);

	gmtime_r(system_secs, &tm1);

	strftime(buf, &tm1);

	printf("%s\n", buf);

	return 0;
}


typedef struct exec_struct_s {
	char* command_name;
	int (*command)(int argc, char* argv[]);
} exec_struct_t;

exec_struct_t my_commands[] = { {"calc", execute_calc},
																	{"ps", execute_ps},
																	{"spd", execute_spd },
																	{"spdx", execute_spdx },
																	{"mem", execute_mem},
																	{"sig", execute_sig},
																	{"sst", execute_sst},
																	{"kill", execute_kill},
																	{"mtx", execute_mtx},
																	{"sem", execute_sem},
																	{"ide", execute_ide},
																	{"cat", execute_cat},
																	{"date", execute_date},
																	{"sync", execute_sync}};


void dispatch_op(exec_struct_t *commands, int ncommands, int argc, char* argv[])
{
	int i = 0;
	for(i = 0; i < ncommands; ++i)
	{
		if (!strcmp(commands[i].command_name, argv[0]))
		{
			(*commands[i].command)(argc, argv);
		}
	}
}


void use_keyboard()
{
	const int buflen = 256;
	const int argvlen = 32;
	char buf[buflen];
	char* argv[argvlen];
	int argc = 0;


	int i = 0;
	int len = 0;

	while (1)
	{
		len = buflen;
		printf(">");
		int ret = readline_echo(buf, &len);
		printf("\n");

		parse_buf(buf, len, " ", &argc, argv);

		for(i = 0; i < argc; ++i)
		{
			printf("arg[%d] = %s\n", i, argv[i]);
		}

		if (argc > 0) {
			dispatch_op(my_commands, sizeof(my_commands)/sizeof(my_commands[0]), argc, argv);
		}

		printf("len = %d\n", len);
	}
}


void idle_screen()
{
	outb_0xe9( 'B');

	uint32_t i = 0;

	while (1) {

		if (screen_current != screen_current_old) {
			screen_update();
		}
	}
}

int ext2_system_on = 0;

void kernel_shell_proc()
{

	uint32_t i = 0;

	printf("init ext2 system: \n");

	file_t* dev_ide1 = &fixed_file_list[DEV_IDE + 1];

	init_ext2_system(dev_ide1);

	printf("ext2 system initialized.\n");

	ext2_system_on = 1;

	use_keyboard();

}
