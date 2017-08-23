
#include "kernel_user/stdlib.h"
#include "kernel_user/userproc.h"


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


	int fd = open("/home/bochsrc", O_RDONLY);

	printf("\n\nopen done: fd = %d\n", fd);

	int fd_out = open("/bochsrc.copy", O_WRONLY | O_CREAT, 0644);

	printf("\nopen done: fd_out = %d\n", fd_out);


	int to_rd = 127;

	char buf[128];

	int num_rd = 0;

	do
	{

		num_rd = read(fd, buf, to_rd);

		if (num_rd < 0)
		{
			break;
		}

		if (num_rd > 0)
		{
			buf[num_rd] = 0;

			printf("%s", buf);

			write(fd_out, buf, num_rd);
		}
	}
	while (num_rd != 0);


	while (1)
		WAIT(1 << 20);

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

