
#include "kernel_user/stdlib.h"
#include "kernel_user/userproc.h"


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
			uoutb(0xe9, 'W');
		}
		++i;
	}
*/


	uprintf("proc_1: presenting: the primes: cs = 0x%08x ds = 0x%08x\n", uget_cs(), uget_ds());
	uprintf("                                                       \n");
	uprintf("                                                       \n");

	WAIT(10 * (1 << 24));

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
		uoutb(0xe9,'A');
		if (i % 100 == 0)
		{
			//WAIT(1 << 25);
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
