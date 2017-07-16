
#include "kernel_user/stdlib.h"
#include "kernel_user/userproc.h"

void my_handler(uint32_t arg)
{
	uprintf("\nmy handler_called: arg = %d\n", arg);
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

	uprintf("proc_1: presenting: the primes: cs = 0x%08x ds = 0x%08x\n", (uint32_t)uget_cs(), (uint32_t)uget_ds());
	uprintf("                                                       \n");
	uprintf("                                                       \n");

	uprintf("proc1: forking");
	uint32_t ret = fork();
	uprintf("after fork: ret = %d\n", ret);
	uprintf("proc1: fork done.");

	if (ret == 0)
	{
		int i;
		for(i = 1; i < 10; ++i)
		{
			uprintf("fak(%d) = %d\n", i, fak(i));
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
				key = ugetc(0);
			}
			uint8_t ascii_code = (key >> 16) & 0xff;
			if (ascii_code == '\r')
			{
				uprintf("\r\n");
			}
			else
			{
				uprintf("%c", ascii_code);
			}
		}

	}


	//WAIT(10 * (1 << 24));


	while (i < (1 << 30))
	{
		// for debugging: provoke an illegal access to kernel space
		// results in a page_fault, as wished for
/*
		if (i > (1 << 16)) {
			uint32_t paddr = 0xc0000010;
			uprintf("paddr = %08x\n", paddr);
			//WAIT(1 << 24);
			__volatile__ uint32_t val = *((uint32_t*) paddr);
		}
*/
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
			uprintf(" %d ", i);
			if (!(cnt % 4))
			{
				uprintf("\n");
			}
		}
		i = i + 1;
		//uoutb_0xe9('A');
		if (i % 8 == 0)
		{
			WAIT(126 * (1 << 24));
		}
	}

	//udisplay_tss(&process_table[0]->proc_data.tss);

	while (1);
}

void udisplay_tss(tss_t* tss)
{
	uprintf("esp = 0x%08x\n", tss->esp);
	uprintf("ss = 0x%08x\n", tss->ss);

	uprintf("esp0 = 0x%08x\n", tss->esp0);
	uprintf("ss0 = 0x%08x\n", tss->ss0);

	uprintf("ebp = 0x%08x\n", tss->ebp);

	uprintf("ebx = 0x%08x\n", tss->ebx);
	uprintf("eax = 0x%08x\n", tss->ebx);
	uprintf("ecx = 0x%08x\n", tss->ebx);
	uprintf("edx = 0x%08x\n", tss->ebx);

	uprintf("esi = 0x%08x\n", tss->esi);
	uprintf("edi = 0x%08x\n", tss->edi);

	uprintf("ds = 0x%08x\n", tss->ds);
	uprintf("es = 0x%08x\n", tss->es);

}
