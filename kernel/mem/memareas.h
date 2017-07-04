#ifndef __mem_memareas_h
#define __mem_memareas_h

#include "kerneltypes.h"

typedef struct __PACKED bios_mem_area_entry_s {

	uint64_t base_address;
	uint64_t length;
	uint32_t type;
	uint32_t acpi;

} bios_mem_area_entry_t;

void get_mem_area_table_info(size_t *table_len, bios_mem_area_entry_t** table_start);
void display_bios_mem_area_table();




#endif

