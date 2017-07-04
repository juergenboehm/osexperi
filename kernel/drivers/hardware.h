#ifndef __drivers_hardware_h
#define __drivers_hardware_h

#include "kerneltypes.h"
#include "libs/utils.h"

#define EFLAGS_IF_FLAG (1 << 9)


static inline void io_wait()
{
	asm __volatile__ ( "outb %%al, $0x80" : : "a"(0) );
}

static inline uint8_t inb(uint16_t port)
{
	uint8_t val;
	asm __volatile__ ( "inb %1, %0" :
					"=a"(val) : "Nd"(port) );
	return val;
}

static inline void outb(uint16_t port, uint8_t val)
{
	asm __volatile__ ( "outb %1, %0" :
				 : "Nd"(port), "a"(val) );
}

static inline uint16_t inw(uint16_t port)
{
	uint16_t val;
	asm __volatile__ ( "inw %1, %0" :
					"=a"(val) : "Nd"(port) );
	return val;
}

static inline void outw(uint16_t port, uint16_t val)
{
	asm __volatile__ ( "outw %1, %0" :
				 : "Nd"(port), "a"(val) );
}


static inline uint32_t inl(uint16_t port)
{
	uint32_t val;
	asm __volatile__ ( "inl %1, %0" :
					"=a"(val) : "Nd"(port) );
	return val;
}

static inline void outl(uint16_t port, uint32_t val)
{
	asm __volatile__ ( "outl %1, %0" :
				 : "Nd"(port), "a"(val) );
}

static inline void sti()
{
    asm __volatile__ ( "sti" );
}

static inline void cli()
{
    asm __volatile__ ( "cli" );
}


static inline uint32_t irq_cli_save()
{
	uint32_t eflags;
	asm __volatile__ ( "pushfl \n\t"
										 "popl %%eax \n\t"
										 "cli \n\t" :
			"=a"(eflags) );
	return eflags;

}


static inline void irq_restore(uint32_t eflags)
{
	if (eflags & EFLAGS_IF_FLAG)
	{
		asm __volatile__ ( "sti");
	}

}


__NOINLINE void set_cr3(uint32_t phys_page_dir_addr);

static inline uint32_t get_cr3()
{
		uint32_t cr3_val;
		asm __volatile__("movl %%cr3, %0": "=r"(cr3_val));
		return cr3_val;
}

static inline uint32_t get_esp()
{
		uint32_t esp_val;
		asm __volatile__("movl %%esp, %0": "=r"(esp_val));
		return esp_val;
}

static inline uint16_t get_cs()
{
		uint16_t cs_val;
		asm __volatile__("movw %%cs, %0": "=r"(cs_val));
		return cs_val;
}

static inline uint16_t get_ds()
{
		uint16_t ds_val;
		asm __volatile__("movw %%ds, %0": "=r"(ds_val));
		return ds_val;
}


#define SET_LGDT(gdt_ptr) \
    { asm volatile ( "lgdt "#gdt_ptr : : : "memory" ); }


#define SET_LIDT(idt_ptr) \
	 { asm __volatile__ ( "lidt "#idt_ptr : : : "memory" ); }





#endif
