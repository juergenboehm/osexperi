
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

#include "libs32/kalloc.h"
#include "libs32/klib.h"

#include "libs/structs.h"
#include "libs/utils.h"
#include "libs/lists.h"

#include "fs/gendrivers.h"

#include "kernel32/process.h"
#include "kernel32/procstart.h"

#include "kernel32/baseprocs.h"



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

void idle_forever()
{
	outb(0xe9, 'B');

	uint32_t i = 0;

	while (1) {
		printf("I am idle. %d\n", ++i);
		if (!(i % (1 << 24)))
		{
			outb(0xe9, 'B');
		}

		if (screen_current != screen_current_old) {
			screen_update();
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
		if (key_avail())
		{
			uint32_t keyb_full_code = 0;
			do
			{
				keyb_full_code = read_key_with_modifiers();
			} while (keyb_full_code == 0);

			//uint32_t keyb_full_code = read_keyb_byte();
			//printf("%08d + %08d + %08x\n", timer_special_counter, keyb_special_counter, keyb_full_code);

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
	}

	ende:

	*cnt = char_cnt;

	return 0;

}

void parse_buf(char* buf, int len, int* argc, char* argv[])
{
	char* p = buf;
	int argc_local = 0;

	*argc = argc_local;


	while (p - buf < len)
	{
		if (argc_local && *p)
		{
			*p = 0;
			++p;
		}
		while (*p == ' ')
		{
			++p;
		}

		if (*p)
		{
			argv[argc_local] = p;
			++argc_local;
			while (*p != ' ')
				++p;
		}
		else
		{
			break;
		}
	}

	*argc = argc_local;

	//printf("parse_buf: argc = %d\n", *argc);

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
	printf("pid = %d ticks = %d status = %d",
			proc->proc_data.pid,
			proc->proc_data.ticks,
			proc->proc_data.status);
}


int execute_ps(int argc, char* argv[])
{
	printf("ps: started.\n");
	int np = 0;

	list_head_t *p = process_node_list_head;

	if (p)
	{
		do
		{
			process_node_t *pnd = container_of(p, process_node_t, link);

			print_proc_info_line(pnd->proc);
			printf("\n");

			++np;
			p = p->next;

		} while (p != process_node_list_head);
	}
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

	list_head_t *p = process_node_list_head;

	if (p)
	{
		do
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

		} while (p != process_node_list_head);
	}

	printf("spd: process not found.\n");

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

	return 0;
}


typedef struct exec_struct_s {
	char* command_name;
	int (*command)(int argc, char* argv[]);
} exec_struct_t;

exec_struct_t my_commands[] = { {"calc", execute_calc},
																	{"ps", execute_ps}, {"spd", execute_spd },
																	{"mem", execute_mem}};


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

		parse_buf(buf, len, &argc, argv);

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


void idle_watched()
{
	outb(0xe9, 'B');

	uint32_t i = 0;

	while (1) {
		printf("I am watched. %d\n", ++i);
		++i;
	}
}


void idle_vn()
{
	outb(0xe9, 'B');

	uint32_t i = 0;

	while (1) {
		printf("I love vn. %d\n", ++i);
		if (!(i % (1 << 24)))
		{
			outb(0xe9, 'V');
		}
		++i;

		if (i == 2206) {
			use_keyboard();
		}
	}
}
