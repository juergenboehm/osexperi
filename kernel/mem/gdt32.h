#ifndef __mem_gdt32_h
#define __mem_gdt32_h

#include "libs/gdt.h"
#include "libs/structs.h"

#define GDT_TABLE_32_LEN 16

extern __ALIGNED(16)
descriptor_t gdt_table_32[GDT_TABLE_32_LEN];


void init_gdt_table_32();

#endif
