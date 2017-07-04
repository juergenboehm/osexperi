
#include "libs/utils.h"

#include "libs16/bioslib.h"
#include "libs16/print16.h"


__NOINLINE __volatile__ int copy_segseg(uint16_t old_seg, uint16_t old_offs, int len, uint16_t new_seg, uint16_t new_offs)
{

  DBGOUT("copy_segseg: target = ", ((((uint32_t)new_seg) << 4) + ((uint32_t)new_offs)));

	asm volatile (
			 "push %%es \n\t push %%fs \n\t"
			 "movw %0, %%ax \n\t"
			 "movw %%ax, %%es \n\t"
			 "movw %1, %%ax \n\t"
			 "movw %%ax, %%fs \n\t"
			 "movw %2, %%si \n\t"
			 "movw %3, %%di \n\t"
			 "movl %4, %%ecx \n\t"
			 ".LOOPXXX: \n\t movb %%es:(%%si), %%al \n\t"
			 "movb %%al, %%fs:(%%di) \n\t"
			 "inc %%si \n\t"
			 "inc %%di \n\t"
			 "decl %%ecx \n\t"
			 "cmp $0, %%cx \n\t"
			 "jne .LOOPXXX \n\t"
			 "pop %%fs \n\t pop %%es \n\t " :  :
			 		"g" (old_seg), "g" (new_seg),
					"g" (old_offs), "g" (new_offs), "g"(len) : "%si", "%di", "%ax", "%ecx", "memory" );

  return 0;
}

// BIOS transfer to extended memory

int __NOINLINE copy_ext(move_mem_block* pmmb, uint32_t start, uint32_t goal, uint16_t len, uint16_t user_seg)
{
	descriptor_t* src = &(pmmb->gdte_source);
	descriptor_t* dest = &(pmmb->gdte_dest);

	DESCRIPTOR_SET_GD_P_DPL_S_TYP(*src, start, 0xffff, 0, 0, 1, 0, 1, 0);
	DESCRIPTOR_SET_GD_P_DPL_S_TYP(*dest, goal, 0xffff, 0, 0, 1, 0, 1, 1);

	pmmb->dummy = 0;
	pmmb->tab_start_addr = 0;

	pmmb->cs_bios = 0;
	pmmb->ss_bios = 0;

	uint16_t result;

/*
  DBGOUT("sizeof(long long) = ", sizeof(long long));
	print_str("***************\r\n");
	print_gdt_entry(src);
	print_gdt_entry(dest);
	print_str("***************\r\n");
*/

	asm volatile(
								"push %%es \n\t"
								"movw %1, %%ax\n\t"
								"movw %%ax, %%es\n\t"
								"movw %2, %%si\n\t"
								"movw %3, %%cx\n\t"
								"movw $0x8700, %%ax\n\t"
								"int  $0x15\n\t"
								"pop  %%es\n\t"
								"movl $0, %%eax\n\t"
								"rcll	$1, %%eax\n\t"
								"movw %%ax, %0\n\t"
									 : "=g"(result) : "g" (user_seg), "g"((uint16_t)(uint32_t)pmmb), "g"(len) :
											"%si", "%eax", "%cx", "memory" );


	return (int)result;


}


// BIOS character print routine

__NOINLINE void print_char(uint8_t ch)
{
	asm("movb	%0, %%al" : : "m" (ch): "%ax");
	asm("movb $0x0e, %%ah" : : : "%ax" );
	asm("movb	$0x00, %%bh": : : "%bh" );
	asm("movb	$0x0c, %%bl": : : "%bl" );
	asm("int $0x10" );

}


// BIOS harddisk functions

int __NOINLINE init_DAPA(uint32_t lba, uint16_t numsec, uint8_t* bufp, DAPA* dapa, uint16_t loader_ds)
{
  //DBGOUT("init_DAPA: loader_ds = ", loader_ds);

	dapa->packet_size = 16;
	dapa->always_zero = 0;
	dapa->numsec = numsec;
	dapa->offset_buf = (uint16_t)(((uint32_t)bufp) & 0xffff);
	dapa->segment_buf = loader_ds;
	dapa->start_lba = lba;
	dapa->start_lba_upper = 0;

	return 0;

}

#define BIOS_READ_DISK	0x42
#define BIOS_WRITE_DISK	0x43

#define DISK_CODE	0x80

// load from hard disk

int __NOINLINE loadsec( uint32_t lba, uint16_t numsec, uint8_t* bufp, DAPA* dapa, uint16_t loader_ds)
{

	init_DAPA( lba, numsec, bufp, dapa, loader_ds);
	asm( "movw %0, %%si" : : "g" ((uint16_t)(((uint32_t) dapa) & 0xffff)) : "%si" );
	asm( "movw %0, %%ax \n\t movw %%ax, %%ds" : : "m" ((uint16_t) loader_ds) : "%ax");
	asm( "movb %0, %%ah" : : "i" (BIOS_READ_DISK) : "%ah");
	asm( "movb %0, %%dl" : : "i" (DISK_CODE) : "%dl" );
	asm( "int $0x13");

	return 0;
}


int __NOINLINE writesec(	uint32_t lba, uint16_t numsec, uint8_t* bufp, DAPA* dapa, uint16_t loader_ds)
{

	init_DAPA( lba, numsec, bufp, dapa, loader_ds);
	asm( "movw %0, %%si" : : "g" ((uint16_t)(((uint32_t) dapa) & 0xffff)) : "%si" );
	asm( "movw %0, %%ax \n\t movw %%ax, %%ds" : : "m" ((uint16_t) loader_ds) : "%ax");
	asm( "movb %0, %%ah" : : "i" (BIOS_WRITE_DISK) : "%ah" );
	asm( "movb %0, %%dl" : : "i" (DISK_CODE) : "%dl" );
	asm( "int $0x13");

	return 0;
}


// load from floppy

#define FD_CYLS				80
#define	FD_HDS				2
#define FD_SECT_PT		18

int __NOINLINE loadsec_fd( uint32_t lba, uint16_t numsec, uint8_t* bufp, DAPA* dapa, uint16_t loader_ds)
{

	uint8_t numsec_8 = (uint8_t)(numsec);

	uint8_t sector = lba % FD_SECT_PT + 1;

	uint16_t temp = lba / FD_SECT_PT;

	uint8_t head = temp % FD_HDS;
	uint16_t cylinder = temp / FD_HDS;

	uint8_t cylinder_low = cylinder & 0xff;
	uint8_t sector_val = sector | ((cylinder >> 2) & 0xc0);

	uint16_t buf_16 = (uint16_t)(((uint32_t)bufp) & 0xffff);


	uint32_t result = 1;
	uint8_t retry_cnt = 0;

	while(result && retry_cnt < 3)
	{

		asm __volatile__ (
			"push	%%es \n\t"
			"movw %1, %%ax \n\t "
			"movw %%ax, %%es \n\t "
			"movw %2, %%bx \n\t "
			"movb $0x02, %%ah \n\t "
			"movb %3, %%al \n\t "
			"movb %4, %%ch \n\t "
			"movb %5, %%cl \n\t "
			"movb %6, %%dh \n\t "
			"movb %7, %%dl \n\t "
			"int $0x13 \n\t"
			"movl $0x0, %%eax \n\t "
			"rcll $1, %%eax \n\t "
			"movl %%eax, %0 \n\t "
			"pop %%es \n\t":
					"=g" (result) :
		 			"m"(loader_ds), "m"(buf_16),
					"m"(numsec_8),
					"m"(cylinder_low),
					"m"(sector_val),
					"m"(head), "i"(0) : "%eax", "%dx", "%cx", "%bx", "memory"
			 );

		++retry_cnt;
	}


		return result;
}



// BIOS getMemory map




int __NOINLINE __volatile__ get_mem_map_step(uint16_t buf_seg, uint8_t* bufp, bool* ende, uint8_t** newbufp, uint32_t* ebx)
{

	int err = 0;
	uint32_t ebx_val = *ebx;
	volatile uint8_t size_entry = 0;

	asm __volatile__
	(
		"pushw %%es \n\t"
		"movw %3, %%ax \n\t"
		"movw %%ax, %%es \n\t"
		"movw %4, %%di \n\t"
		"movl %5, %%ebx \n\t"
		"movl $0x534D4150, %%edx \n\t"	// 'SMAP'
		"movl $24, %%ecx \n\t"
		"movl $0xe820, %%eax \n\t"
		"int	$0x15 \n\t"
		"movb %%cl, %2 \n\t"
		"cmp $0x18, %%cl \n\t"
		".L9900: je 1f \n\t"
		"addw $0x14, %%di \n\t"
		"movl $0xffffffff, %%es:(%%di) \n\t"
		"1: movl $0x0, %%edx \n\t"
		"rcll $1, %%edx \n\t"
		"movl %%edx, %0 \n\t"
		"movl %%ebx, %1 \n\t"
		"popw %%es \n\t" :
				"=g"(err), "=g"(ebx_val), "=g"(size_entry) : "g"(buf_seg), "g"((uint16_t)((uint32_t)(bufp) & 0xffff)),
				 "g"(ebx_val):
						"%eax", "%ebx", "%ecx", "%edx", "%edi", "memory" );

	*ebx = ebx_val;
	*newbufp = bufp + 24;

	DBGOUT("size_entry: ", (uint32_t) size_entry);

	DBGOUT("get_mem_map_first: err: ", err);
	DBGOUT("get_mem_map_first: ebx_val: ", ebx_val);
	*ende = EXOR((ebx_val == 0), err);
	DBGOUT("get_mem_map_first: err (second): ", err);

	return err;
}


int __NOINLINE __volatile__ get_mem_map(uint16_t buf_seg, uint8_t* bufp, size_t* len_map)
{

	DBGOUT("get_mem_map: len_map: ", (uint32_t)len_map);

	uint8_t* bufp_akt = bufp;
	int err = 0;
	uint32_t ebx = 0;

	bool ende = false;
	err = get_mem_map_step(buf_seg, bufp_akt, &ende, &bufp_akt, &ebx);

	if(!err)
	{
		DBGOUT("get_mem_map: increment len_map", *len_map);
		(*len_map)++;
		DBGOUT("get_mem_map: increment len_map (after)", *len_map);
	}

	DBGOUT("get_mem_map: ebx:", ebx);


	while(!err && !ende)
	{
		err = get_mem_map_step(buf_seg, bufp_akt, &ende, &bufp_akt, &ebx);
		if(!err)
			(*len_map)++;
	}

	return err;

}

