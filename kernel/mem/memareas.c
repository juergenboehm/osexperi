
#include "libs/kerneldefs.h"
#include "mem/memareas.h"


void get_mem_area_table_info(size_t *table_len, bios_mem_area_entry_t** table_start)
{
	uint32_t* pt = (uint32_t*) __VADDR((KERNEL16_SEG << 4) + BIOS_MEM_AREA_HANDLE);
	pt++;
	*table_len = *pt;

	*table_start = (bios_mem_area_entry_t*) __VADDR(BIOS_MEM_AREA_TABLE_ADDR);

}

void display_bios_mem_area_table()
{
	size_t table_len = 0;
	bios_mem_area_entry_t* p_entry = NULL;

	size_t i = 0;

	// table_len is len of BIOS memarea table
	// p_entry is pointer to start of this table

	get_mem_area_table_info(&table_len, &p_entry);

	printf("BIOS Memory Areas: table_len = %d, p_entry = %08x\n\n", table_len, (uint32_t) p_entry);

	for(i = 0; i < table_len; ++i)
	{
		printf("From %016lx Len %016lx : Type %08x: Acpi %08x\n", (p_entry->base_address), (p_entry->length),
				p_entry->type, p_entry->acpi );
		p_entry++;

		waitkey();
	}
	printf("Fertig.\n");
	waitkey();
}

