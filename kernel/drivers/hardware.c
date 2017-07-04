
#include "kerneltypes.h"
#include "drivers/hardware.h"

__NOINLINE void set_cr3(uint32_t phys_page_dir_addr)
{
asm __volatile__ ("mov %0, %%eax \n\t mov %%eax, %%cr3 \n\t .L99999: jmp 1f \n\t 1: \n\t nop \n\t": :
		"g"(phys_page_dir_addr) : "%eax" );
}
