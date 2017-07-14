
#include "libs/kerneldefs.h"
#include "libs/structs.h"
#include "libs/utils.h"
#include "drivers/hardware.h"
#include "kernel32/process.h"
#include "mem/gdt32.h"


__ALIGNED(16)
descriptor_t gdt_table_32[GDT_TABLE_32_LEN];

__ALIGNED(8)
lim_addr_ptr gdt_ptr_32;


int __NOINLINE volatile init_gdtptr_32 ()
{

	memset(gdt_ptr_32, 0, sizeof(lim_addr_ptr));

	DBGOUT32("sizeof(GDT_ENTRY) = ", sizeof(descriptor_t));

	uint32_t addr_gdtable_32 = (uint32_t) &gdt_table_32;

	DBGOUT32("addr_gdtable_provis = ", addr_gdtable_32);


  SET_LIM_ADDR(gdt_ptr_32, GDT_TABLE_32_LEN * sizeof(descriptor_t), &gdt_table_32);
  SET_LGDT(gdt_ptr_32);

  return 0;

}

void init_gdt_table_32()
{
	int i = 0;

	printf("init_gdt_table_32: start.\n");

	for(i = 0; i < GDT_TABLE_32_LEN; ++i )
	{
		DESCRIPTOR_SET_SEG_ZERO(gdt_table_32[i]);
	}

	memset(gdt_table_32, 0, sizeof(gdt_table_32));

	DESCRIPTOR_SET_CODE_SEG(gdt_table_32[KERNEL_16_CS_GDT_INDEX], 0);
	DESCRIPTOR_SET_DATA_SEG(gdt_table_32[KERNEL_16_DS_GDT_INDEX], 0);

	DESCRIPTOR_SET_BASE(gdt_table_32[KERNEL_16_CS_GDT_INDEX], 0x30000 );
	DESCRIPTOR_SET_BASE(gdt_table_32[KERNEL_16_DS_GDT_INDEX], 0x30000 );

	DESCRIPTOR_SET_LIMIT(gdt_table_32[KERNEL_16_CS_GDT_INDEX], 0xfffff - 0x30 );
	DESCRIPTOR_SET_LIMIT(gdt_table_32[KERNEL_16_DS_GDT_INDEX], 0xfffff - 0x30);


	DESCRIPTOR_SET_CODE_SEG(gdt_table_32[KERNEL_32_CS_KERNEL_GDT_INDEX], 0); // dpl 0 kernel mode
	DESCRIPTOR_SET_DATA_SEG(gdt_table_32[KERNEL_32_DS_KERNEL_GDT_INDEX], 0); // dpl 0
	DESCRIPTOR_SET_CODE_SEG(gdt_table_32[KERNEL_32_CS_USER_GDT_INDEX], 3); // dpl 3 user mode
	DESCRIPTOR_SET_DATA_SEG(gdt_table_32[KERNEL_32_DS_USER_GDT_INDEX], 3); // dpl 3


	descriptor_t* p = gdt_table_32 + 4;


/*
	for(i = 0; i < 2; ++i )
	{
		print_gdt_entry(p++);
	}
*/
	init_gdtptr_32();

	printf("init_gdt_table_32: done.\n");


}
