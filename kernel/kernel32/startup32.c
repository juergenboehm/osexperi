
#include "libs/kerneldefs.h"

#include "libs32/utils32.h"

#include "drivers/hardware.h"
#include "drivers/pci.h"

#include "kernel32/irq.h"

#include "drivers/timer.h"
#include "drivers/keyb.h"
#include "drivers/keyb_decode.h"
#include "drivers/ide.h"
#include "drivers/pic.h"

#include "drivers/vga.h"


#include "fs/vfs.h"
#include "fs/bufcache.h"

#include "libs32/klib.h"

#include "libs32/kalloc.h"

#include "mem/memareas.h"
#include "mem/paging.h"
#include "mem/malloc.h"


#include "libs/structs.h"

#include "libs/gdt.h"
#include "libs/idt.h"

#include "mem/gdt32.h"

#include "kernel32/objects.h"
#include "kernel32/process.h"


// for ide drive access

uint8_t* ide_buffer;

prd_entry_t* prd_table;

// try

extern void* uproc_1;


void keyb_controller_comreg()
{
	outb(0x64, 0x20);
	uint8_t keyb_command = inb(0x60);
	keyb_command &= 0xff;
	outb(0x64, 0x60);
	outb(0x60, keyb_command);
}

/*
void do_screen_reset()
{
	screen_reset(0, 0, 25, 80);
}
*/


void kmain32()
{

	//raw_printf("kmain32 started ");

	current = 0;
	screen_current = 0;

	uint32_t i;
	for(i = 0; i < NUM_PROCESSES/8; ++i)
	{
		pidbuf[i] = 0;
	}

	SETBIT(pidbuf, 0);



	outb_printf("kmain32 started.\n");

	init_kalloc_fixed();

	outb_printf("kalloc_fixed_done.\n");

	//raw_printf(" kalloc fixed done ");

	// now the initialization of the memory system
	// is done right at the beginning, because
	// it depends only on init_kalloc_fixed.
	// earlier it was postponed so that
	// virtual vgas could be created for debugging output
	// this is not necessary anymore, as
	// outb_printf is now used in the new DEBUGOUT1()

	init_mem_system();
	outb_printf("init_mem_system done.\n");

	//raw_printf(" +++++++++++++ init_mem_system done ++++++++++++++ ");


	init_malloc_system();
	outb_printf("init_malloc_system done.\n");

	//raw_printf(" +++++++++++ init_malloc_system done +++++++++++++ ");

	init_base_files();

	outb_printf("init_base_files done.\n");


	//screen_reset(0, 0, 0, 25, 80);
	int fd_vga0 = do_open("/dev/vga0", 1);
	int fd_vga1 = do_open("/dev/vga1", 1);
	int fd_vga2 = do_open("/dev/vga2", 1);
	int fd_vga3 = do_open("/dev/vga3", 1);

	//test_malloc();



	printf("Protected mode.\n");
	printf("Paging enabled.\n\n");

	init_gdt_table_32();


	DEBUGOUT1(0, "Len16: %08x\n", (uint32_t)_len16 );
	DEBUGOUT1(0, "Len32: %08x\n\n", (uint32_t)_len32 );

	idt_table = MALLOC_FIXED_TYPE(idt_entry, IDT_TABLE_SIZE, 1);

	init_idt_table();
	init_pic_alt();

	schedule_off = 1;

	keyb_special_counter = 0;

  uint8_t* test_dummy = MALLOC_FIXED_TYPE(uint8_t, 128, 4096);


  memset((void*)&idt_ptr, 0, sizeof(lim_addr_ptr));
  SET_LIM_ADDR(idt_ptr, IDT_TABLE_SIZE * sizeof(idt_entry), idt_table);
  SET_LIDT(idt_ptr);

	init_global_tss();

	init_sync_system();

	init_objects();

  sti();

	i = 0;



	init_keyboard();

	init_keytables();

	init_timer();

	display_bios_mem_area_table();


	waitkey();

	enumerate_pci_bus(pci_addr_ide_contr);

	uint32_t res = ide_init(pci_addr_ide_contr);

	init_bufcache();


	// the following structures are needed for the ide driver
	// as far as I understand it, at least prd_table must start
	// at a 64kB boundary.
	// we want to eliminate the kalloc_fixed_aligned calls here.

	//ide_buffer = MALLOC_FIXED_TYPE(uint8_t, 512, 0x10000);
	//ide_buffer = (uint8_t*) kalloc_fixed_aligned(512 * sizeof(uint8_t), 0x10000);
	ide_buffer = malloc(0x10000);
	printf("\nkmain32: ide_buffer = %08x\n", (uint32_t)ide_buffer);

	//prd_table must be 16 byte aligned
	//prd_table = MALLOC_FIXED_TYPE(prd_entry_t, 16, 2);
	//prd_table = (prd_entry_t*)kalloc_fixed_aligned(16 * sizeof(prd_entry_t), 0x10000);
	prd_table = malloc(0x10000);
	printf("\nkmain32: prd_table = %08x\n", (uint32_t) prd_table);


	uint32_t cnt = 0;


	//do_list_tests();

	// for instant keyboard code debugging
	//use_keyboard();

	uint64_t val1 = 0x600dc0decafebabeL;
	printf("val1 = %016lx\n", val1);

	for(i = 0; i < 2; ++i)
	{
		waitkey();
	}

	void* uproc_1 = (void*) 0x1000;

	//schedule_off = 0;

	init_process_1_xp(uproc_1);

}

