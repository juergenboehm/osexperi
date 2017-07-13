
#include "kerneltypes.h"
#include "drivers/hardware.h"

__NOINLINE void set_cr3(uint32_t phys_page_dir_addr)
{
#if 0
asm __volatile__ ("mov %0, %%eax \n\t mov %%eax, %%cr3 \n\t .L99999: jmp 1f \n\t 1: \n\t nop \n\t": :
		"g"(phys_page_dir_addr) : "%eax" );
#endif

#if 1
asm __volatile__ ("movl %0, %%eax \n\t movl %%eax, %%cr3 \n\t": :
 "g"(phys_page_dir_addr) : "%eax" );
#endif

}

