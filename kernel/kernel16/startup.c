

#include "libs16/code16.h"
#include "kerneltypes.h"

#include "libs/kerneldefs.h"

#include "libs/structs.h"

#include "libs16/print16.h"
#include "libs16/bioslib.h"

#include "libs/gdt.h"

#include "startup.h"



#define GDT_TABLE_PROVIS_LEN 8

__ALIGNED(16)
descriptor_t gdt_table_provis[GDT_TABLE_PROVIS_LEN];

__ALIGNED(8)
lim_addr_ptr gdt_ptr_provis;


void __NOINLINE init_gdtptr ()
{

	memset16(&gdt_ptr_provis, 0, sizeof(lim_addr_ptr));

	DBGOUT("sizeof(GDT_ENTRY) = ", sizeof(descriptor_t));

	// gdt_ptr_provis.lim = GDT_TABLE_PROVIS_LEN * sizeof(gdt_entry) - 1;

	uint32_t addr_gdtable_provis = (uint32_t) &gdt_table_provis;
	addr_gdtable_provis += (KERNEL16_SEG << 4);

	DBGOUT("addr_gdtable_provis = ", addr_gdtable_provis);

  SET_LIM_ADDR(gdt_ptr_provis, GDT_TABLE_PROVIS_LEN * sizeof(descriptor_t), addr_gdtable_provis );

	// gdt_ptr_provis.addr = addr_gdtable_provis;

	asm volatile( "lgdt gdt_ptr_provis" : : : "memory" );

}


int enable_a20()
{
	uint16_t result;

	asm volatile (
									"movw $0x2401, %%ax\n\t"
									"int $0x15\n\t"
									"movb $0, %%al\n\t"
									"rclb %%al\n\t"
									"movw %%ax, %0\n\t" : "=g"(result) : : "%ax" );

	return (int) result;

}


void __NOINLINE keyb_wait(uint8_t mask, uint8_t val)
{
		asm __volatile__
			(
				"1: \n\t"
				"testb $0xff, %1 \n\t"
				"jz 3f \n\t"
				"2: \n\t"
				"inb	$0x64, %%al \n\t"
				"testb	%0, %%al \n\t"
				"jz 2b \n\t"
				"jmp 4f \n\t"
				"3: \n\t"
				"inb	$0x64, %%al \n\t"
				"testb	%0, %%al \n\t"
				"jnz 3b \n\t"
				"4: \n\t"
				"nop \n\t": : "g"(mask), "g"(val) : "%eax" );
}

void __NOINLINE keyb_send_cmd(uint8_t val)
{
		keyb_wait(2,0); // input buffer empty
		asm __volatile__(
			"outb %0, $0x64" : : "a"(val)
		);
}


void __NOINLINE keyb_send_data(uint8_t data)
{
		keyb_wait(2,0); // input buffer empty
		asm __volatile__(
			"outb %0, $0x60" : : "a"(data)
		);
}

uint8_t __NOINLINE keyb_get_data()
{
		uint8_t data = 0;

		keyb_wait(1,1); // output buffer full
		asm __volatile__ (
			"inb $0x60, %0" : "=a"(data));

		return data;
}


int enable_a20_keyb()
{
		asm("cli");
		keyb_send_cmd(0xad); // disable keyboard

		keyb_send_cmd(0xd0); // next byte read comes from [microcontroller output byte]
		uint8_t data = keyb_get_data();

		data |= 0x02; // enable A20 gate

		keyb_send_cmd(0xd1); // next byte written goes to [microcontroller output byte]
		keyb_send_data(data);

		keyb_send_cmd(0xae); // enable keyboard
		asm("sti");

		return 0;
}

uint32_t enable_a20_bios_15()
{
	uint32_t retcode = 0;

	asm __volatile__ (
		PUSH_THE_REGS \
		"movw     $0x2403, %%ax                #--- A20-Gate Support --- \n\t" \
		"int     $0x15  \n\t" \
		"jb      .a20_ns                  # INT 15h is not supported \n\t" \
		"cmpb    $0, %%ah \n\t" \
		"jnz     .a20_ns                  # INT 15h is not supported \n\t" \
		\
		"movw    $0x2402, %%ax                # --- A20-Gate Status --- \n\t" \
		"int     $0x15 \n\t" \
		"jb      .a20_failed              # couldn't get status \n\t" \
		"cmpb    $0, %%ah \n\t" \
		"jnz     .a20_failed              #couldn't get status \n\t" \
		 \
		"cmpb    $0x01, %%al \n\t" \
		"jz      .a20_already_activated           # A20 is already activated \n\t" \
		 \
		"movw     $0x2401, %%ax           # --- A20-Gate Activate --- \n\t" \
		"int     $0x15 \n\t" \
		"jb      .a20_failed               #couldn't activate the gate \n\t" \
		"cmp     $0, %%ah \n\t" \
		"jnz     .a20_failed              # couldn't activate the gate \n\t" \
		"movl		$0x1234, %0 \n\t"
		"jmp		.ende \n\t " \
		".a20_already_activated: \n\t" \
		"movl		$0x5678, %0 \n\t"
		"jmp		.ende \n\t " \
		".a20_ns: \n\t"
		"movl	$0xabab, %0 \n\t" \
		"jmp 		.ende \n\t " \
		".a20_failed: \n\t" \
		"movl $0xcdcd, %0 \n\t" \
		".ende: \n\t" \
		\
		POP_THE_REGS
   : "=g"(retcode) : : "%eax", "%ebx", "%ecx", "%edx", "%esi", "%edi" );

	return retcode;

}

uint32_t set_video_mode(uint8_t mode)
{

	uint8_t retcode = 0;

	asm __volatile__ (
			"movb $0, %%ah \n\t" \
			"movb %1, %%al \n\t " \
			"int $0x10 \n\t" \
			"movb %%al, %0" \
			: "=g"(retcode) : "g"(mode) : "%eax", "%ebx", "%ecx", "%edx", "%esi", "%edi" );

	return retcode;
}


/*

int __NOINLINE enable_a20_keyb_asm()
{

			asm __volatile__(

				".LOOP_EA20:"
        "cli \n\t"
 				"call     1f \n\t"
        "movb     $0xAD,%%al  \n\t"  // disable keyboard
        "outb     %%al, $0x64  \n\t"
 				""
        "call    1f  \n\t"
        "movb    $0xD0, %%al  \n\t"  // copy [microcontroller output byte] (a register) to port 60
        "outb    %%al, $0x64  \n\t"
 				""
        "call    2f  \n\t"					 // has it arrived?
        "inb     $0x60, %%al  \n\t"  // read it from there, gives value we call mob
 				"movb		 %%al, %%bl		\n\t"  // save it in %bl
        "call    1f  \n\t"
        "movb    $0xD1, %%al  \n\t"  // next byte written to port 60 goes to [microcontroller output byte]
        "outb    %%al, $0x64  \n\t"
 				""
        "call    1f  \n\t"
        "orb     $2, %%bl  \n\t"			// or the byte mob with 2 as bit 1 of mob controls a20 line
        "movb		 %%bl, %%al   \n\t"   // restore it from %bl
				"outb    %%al, $0x60  \n\t"		// write it then to port 60 where it is copied to [microcontroller output byte]
 				""
        "call    1f  \n\t"
        "mov     $0xAE, %%al  \n\t"  	// enable keyboard
        "outb    %%al, $0x64  \n\t"
 				""
        "call    1f  \n\t"
 				"jmp		 3f \n\t"
				"1:  \n\t"									// wait on input buffer empty
        "inb     $0x64, %%al  \n\t"
        "test    $2, %%al  \n\t" 		// %%al & 2 == 0 / 1 : input buffer empty / full
        "jnz     1b  \n\t"
        "ret  \n\t"
 				""
 				""
				"2:  \n\t"  								// wait on output buffer full
        "inb     $0x64, %%al  \n\t"
        "test    $1, %%al  \n\t"   	// %%al & 1 == 0 / 1: output buffer = empty / full
        "jz      2b  \n\t"
        "ret  \n\t"
				"3: sti\n\t" :
				: : "%eax", "%ebx");

}

*/

int kmain()
{

	int i = 0;

	print_str("\r\nKernel primary loaded.\r\n");

	for(i = 0; i < GDT_TABLE_PROVIS_LEN; ++i )
	{
		DESCRIPTOR_SET_SEG_ZERO(gdt_table_provis[i]);
	}

	memset16(&gdt_table_provis, 0, sizeof(gdt_table_provis));

	DESCRIPTOR_SET_CODE_SEG(gdt_table_provis[KERNEL_16_CS_GDT_INDEX], KPL);
	DESCRIPTOR_SET_DATA_SEG(gdt_table_provis[KERNEL_16_DS_GDT_INDEX], KPL);

	DESCRIPTOR_SET_BASE(gdt_table_provis[KERNEL_16_CS_GDT_INDEX], 0x30000 );
	DESCRIPTOR_SET_BASE(gdt_table_provis[KERNEL_16_DS_GDT_INDEX], 0x30000 );

	DESCRIPTOR_SET_LIMIT(gdt_table_provis[KERNEL_16_CS_GDT_INDEX], 0xfffff - 0x30 );
	DESCRIPTOR_SET_LIMIT(gdt_table_provis[KERNEL_16_DS_GDT_INDEX], 0xfffff - 0x30);


	DESCRIPTOR_SET_CODE_SEG(gdt_table_provis[KERNEL_32_CS_KERNEL_GDT_INDEX], KPL); // dpl 0 kernel mode
	DESCRIPTOR_SET_DATA_SEG(gdt_table_provis[KERNEL_32_DS_KERNEL_GDT_INDEX], KPL); // dpl 0
	DESCRIPTOR_SET_CODE_SEG(gdt_table_provis[KERNEL_32_CS_USER_GDT_INDEX], UPL); // dpl 3 user mode
	DESCRIPTOR_SET_DATA_SEG(gdt_table_provis[KERNEL_32_DS_USER_GDT_INDEX], UPL); // dpl 3

	descriptor_t* p = gdt_table_provis + 4;

	for(i = 0; i < 2; ++i )
	{
		print_gdt_entry(p++);
	}

	init_gdtptr();
	int ok = enable_a20_keyb();
	DBGOUT("a_20 ok = ", ok);

	uint32_t retcode = enable_a20_bios_15();
	DBGOUT("a_20 bios 15 retcode = ", retcode);


	size_t len_map = 0;

	int err = get_mem_map((uint16_t)(((uint32_t)BIOS_MEM_AREA_TABLE_ADDR & 0xf0000) >> 4), (uint8_t*)0x0000, &len_map);

	uint32_t* pt = (uint32_t*)BIOS_MEM_AREA_HANDLE;
	*pt++ = err;
	*pt = (uint32_t) len_map;

	// copy_segseg(KERNEL16_SEG, 4 * 512, 512, 0x3000, 0x0000);

	DBGOUT("err mem map = ", err);
	DBGOUT("len mem map = ", len_map);

	DBGOUT("a_20 ok = ", ok);
	DBGOUT("a_20 bios 15 retcode = ", retcode);

	//retcode = set_video_mode(3);
	//DBGOUT("set video mode retcode = ", retcode);

	asm __volatile__ (
			"movw		$0xb800, %%ax \n\t"
			"movw		%%ax, %%es \n\t"
			"xor		%%di, %%di \n\t"
			"movb		$70, %%es:(%%di) \n\t"
			"inc		%%di \n\t"
			"movb		$0x1e, %%es:(%%di) \n\t"
			: : : "%di", "%ax" );

	return 0;

}
