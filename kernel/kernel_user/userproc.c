
#include "kernel_user/stdlib.h"
#include "kernel_user/userproc.h"


int execute_cp(int argc, char* argv[])
{
	int retval = -1;

	if (argc < 3)
	{
		fprintf(3, "usage: cp <pathname_from> <pathname_to>\n");
		goto ende;
	}

	int fd_in = open(argv[1], O_RDONLY);

	fprintf(3, "\n\nopen done: fd = %d\n", fd_in);

	int fd_out = open(argv[2], O_WRONLY | O_CREAT, 0644);

	fprintf(3, "\nopen done: fd_out = %d\n", fd_out);


	int to_rd = 127;

	char buf[128];

	int num_rd = 0;

	do
	{

		num_rd = read(fd_in, buf, to_rd);

		if (num_rd < 0)
		{
			break;
		}

		if (num_rd > 0)
		{
			buf[num_rd] = 0;

			write(fd_out, buf, num_rd);
		}
	}
	while (num_rd != 0);

	close(fd_in);
	close(fd_out);


	ende:
	return retval;

}

int execute_cd(int argc, char* argv[])
{
	int retval = -1;

	if (argc < 2)
	{
		fprintf(3, "usage: cd <dirname>\n");
		goto ende;
	}

	retval = chdir(argv[1]);

	ende:
	return retval;
}

int execute_rm(int argc, char* argv[])
{
	int retval = -1;

	if (argc < 2)
	{
		fprintf(3, "usage: rm <pathname>\n");
		goto ende;
	}

	retval = unlink(argv[1]);

	ende:
	return retval;
}

int execute_rmdir(int argc, char* argv[])
{
	int retval = -1;

	if (argc < 2)
	{
		fprintf(3, "usage: rmdir <dir_pathname>\n");
		goto ende;
	}

	retval = rmdir(argv[1]);

	ende:
	return retval;
}

int execute_mkdir(int argc, char* argv[])
{
	int retval = -1;

	if (argc < 2)
	{
		fprintf(3, "usage: mkdir <dir_pathname>\n");
		goto ende;
	}

	retval = mkdir(argv[1], 0744);

	ende:
	return retval;
}






int execute_ls(int argc, char* argv[])
{
	int retval = -1;

	if (argc < 2)
	{
		fprintf(3, "usage: ls <dirname>\n");
		goto ende;
	}

	int fd_dir = open(argv[1], O_RDONLY);

	fprintf(3, "\nfd_dir = %d\n", fd_dir);

	if (fd_dir < 0)
	{
		goto ende;
	}

	dirent_t dirent;

	do
	{
		retval = readdir(fd_dir, &dirent);
		if (retval <= 0)
		{
			break;
		}
		else
		{
			fprintf(3, "%c %s\n", dirent.d_type == EXT2_FT_DIR ? 'd' : 'r', dirent.d_name);
		}
	}
	while (1);


	close(fd_dir);

	ende:
	return retval;

}




typedef struct exec_struct_s {
	char* command_name;
	int (*command)(int argc, char* argv[]);
} exec_struct_t;


exec_struct_t my_commands[] = { {"ls", execute_ls},
																{"cd", execute_cd},
																{"cp", execute_cp},
																{"rm", execute_rm},
																{"rmdir", execute_rmdir},
																{"mkdir", execute_mkdir}};


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


void my_handler(uint32_t arg)
{
	printf("\nmy handler_called: arg = %d\n", arg);
}

int fak(int n)
{
	if (n == 1)
	{
		return 1;
	}
	else
	{
		return n * fak(n-1);
	}
}


int readline_echo(int fd, int fd_out, char* buffer, int *cnt)
{
	const int max_screen_line_len = 65;

	int max_len = *cnt;
	char *p = buffer;

	int curr_cnt = -1; // at the beginning: unknown = -1;

	*p = 0;

	int char_cnt = 0;

	while (1)
	{
		uint32_t keyb_full_code = getc(fd);

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
					fprintf(fd_out, "%c", display_code);
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
				fprintf(fd_out, "%c", display_code);

				if (char_cnt && !(char_cnt % max_screen_line_len))
				{
					curr_cnt = 0;
					fprintf(fd_out, "\n");
				}

			}

		}
	}

	ende:

	*cnt = char_cnt;

	return 0;

}


int testq = 1;


void uproc_1()
{
	//timer_schedule_on = 1;

	uint32_t i;
	uint32_t j;
	uint32_t cnt = 0;
	i = 2;

// for debugging
/*
	i = 0;
	while (1)
	{
		if (!(i % (1 << 24))) {
			uoutb_0xe9( 'W');
		}
		++i;
	}
*/

// generate a mode 5 page fault with access to system area
#if 0
	typedef void (*pfun_t)();

	pfun_t pfun = (pfun_t)(0xc0100000);

	(*pfun)();
#endif

// prove that a read access in user area creates a new page via page-fault
#if 1

	uint32_t val = *((uint32_t*) 0x60000000);

#endif

	register_handler(my_handler);

	outb_printf("proc_1: presenting: the primes: cs = 0x%08x ds = 0x%08x\n", (uint32_t)get_cs(), (uint32_t)get_ds());
	outb_printf("                                                       \n");
	outb_printf("                                                       \n");

	printf("proc_1: presenting: the primes: cs = 0x%08x ds = 0x%08x\n", (uint32_t)get_cs(), (uint32_t)get_ds());
	printf("                                                       \n");
	printf("                                                       \n");


	printf("proc1: forking\n");
	uint32_t ret = fork();
	printf("after fork: ret = %d\n", ret);
	printf("proc1: fork done.\n");

	if (ret == 0)
	{
		int i;
		for(i = 1; i < 10; ++i)
		{
			printf("fak(%d) = %d\n", i, fak(i));
		}
#ifdef MEM_BIG_ALLOCATE_TEST
		uint8_t* pt = (uint8_t*)0x100000;

		for(i = 0; i < 5 * 1024 * 1024; ++i)
		{
			pt[i] = 'W';
		}
		while (1) {};
#endif

		testq = 998;
		uint32_t key = 0;


		while (1)
		{
			key = 0;
			while (!((key >> 16) & 0xff))
			{
				key = getc(0);
			}
			uint8_t ascii_code = (key >> 16) & 0xff;
			if (ascii_code == '\r')
			{
				printf("\r\n");
			}
			else
			{
				printf("%c", ascii_code);
			}
		}

	}




	char linebuf[256];

	while (1)
	{
		int cnt = 256;
		int argc;
		char* argv[128];

		fprintf(3, ">");
		readline_echo(2, 3, linebuf, &cnt);
		fprintf(3, "\n");

		parse_buf(linebuf, cnt, " ", &argc, argv);

		for(i = 0; i < argc; ++i)
		{
			fprintf(3, "arg[%d] = %s\n", i, argv[i]);
		}

		if (argc > 0) {
			dispatch_op(my_commands, sizeof(my_commands)/sizeof(my_commands[0]), argc, argv);
		}

		fprintf(3, "len = %d\n", cnt);

	}

	// for debugging: provoke an illegal access to kernel space
	// results in a page_fault, as wished for
/*
	uint32_t paddr = 0xc0000010;
	uprintf("paddr = %08x\n", paddr);

	__volatile__ uint32_t val = *((uint32_t*) paddr);
*/



	while (i < (1 << 30))
	{
		j = 2;
		while (j * j <= i)
		{
			if (i % j == 0) {
				j = 0;
				break;
			}
			j = j + 1;
		}
		if (j != 0)
		{
			++cnt;
			fprintf(3, " %d ", i);
			if (!(cnt % 4))
			{
				fprintf(3, "\n");
			}
		}
		i = i + 1;
		//outb_0xe9('A');
		if (i % 8 == 0)
		{
			WAIT((1 << 10));
		}
	}

	while (1);
}

