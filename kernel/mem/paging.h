#ifndef __mem_paging_h
#define __mem_paging_h

#include "kerneltypes.h"
#include "libs/kerneldefs.h"

#define PG_ARCH_BITS 32

#define PG_PTE_SIZE 4
#define PG_PDE_SIZE 4

#define PG_PAGE_TABLE_ENTRIES 1024
#define PG_PAGE_TABLE_SIZE		(PG_PAGE_TABLE_ENTRIES * PG_PTE_SIZE)
#define PG_PAGE_TABLE_BITS    10


#define PG_PAGE_DIR_ENTRIES		1024
#define PG_PAGE_DIR_SIZE			(PG_PAGE_DIR_ENTRIES * PG_PDE_SIZE)
#define PG_PAGE_DIR_BITS      10

#define PG_PAGE_DIR_USER_ENTRIES	768

#define PG_FRAME_BITS (PG_ARCH_BITS - PG_PAGE_DIR_BITS - PG_PAGE_TABLE_BITS)
#define PG_FRAME_ADDRESS_MASK ((uint32_t)(-(1 << PG_FRAME_BITS)))

#define PG_PAGE_DIR_MASK			(((1 << PG_PAGE_DIR_BITS) - 1) << (PG_PAGE_TABLE_BITS + PG_FRAME_BITS))
#define PG_PAGE_TABLE_MASK			(((1 << PG_PAGE_TABLE_BITS) - 1) << PG_FRAME_BITS)

#define PG_PAGE_DIR_INDEX(x) (((x) & PG_PAGE_DIR_MASK) >> (PG_PAGE_TABLE_BITS + PG_FRAME_BITS))
#define PG_PAGE_TABLE_INDEX(x) (((x) & PG_PAGE_TABLE_MASK) >> PG_FRAME_BITS)



#define PAGE_SIZE (1 << PG_FRAME_BITS)
#define PAGE_TABLE_AREA_SIZE (PG_PAGE_TABLE_ENTRIES * PAGE_SIZE)

#define PG_ATTR_MASK (~PG_FRAME_ADDRESS_MASK)


typedef struct __PACKED page_table_entry_s {

	uint32_t	val;

} page_table_entry_t;


typedef page_table_entry_t* page_dir_t;
typedef page_table_entry_t* page_table_t;


#define PG_BIT_P_POS        0   // present
#define PG_BIT_RW_POS       1   // read(0)/write(1) access
#define PG_BIT_US_POS       2   // user-too(1)/supervisor-only(0)
#define PG_BIT_PWT_POS      3   // cache write-through
#define PG_BIT_PCD_POS      4   // cache disable
#define PG_BIT_A_POS        5   // accessed
#define PG_BIT_D_POS        6   // dirty
#define PG_BIT_PS_POS       7   // page size (0: 4 KB)
#define PG_BIT_G_POS        8   // granularity

#define PG_BIT_P    (1 << PG_BIT_P_POS)
#define PG_BIT_RW   (1 << PG_BIT_RW_POS)
#define PG_BIT_US   (1 << PG_BIT_US_POS)
#define PG_BIT_PWT  (1 << PG_BIT_PWT_POS)
#define PG_BIT_PCD  (1 << PG_BIT_PCD_POS)
#define PG_BIT_A    (1 << PG_BIT_A_POS)
#define PG_BIT_D    (1 << PG_BIT_D_POS)
#define PG_BIT_PS   (1 << PG_BIT_PS_POS)
#define PG_BIT_G    (1 << PG_BIT_G_POS)


#define PG_PTE_GET_FRAME_ADDRESS(x) ((x).val & PG_FRAME_ADDRESS_MASK)

#define PG_PTE_SET_FRAME_ADDRESS(x, a) ((x).val = (((uint32_t)(a) & PG_FRAME_ADDRESS_MASK)))

#define PG_PTE_GET_BITS(x) ((x).val & PG_ATTR_MASK)

#define PG_PTE_SET_BITS(x, attr) ((x).val = (((x).val & PG_FRAME_ADDRESS_MASK) | ((uint32_t)(((attr) & PG_ATTR_MASK)))))


extern page_table_entry_t* global_page_dir_sys;


// the system maintains a list of page descriptors for all
// available physical pages

int init_paging_system_provis();
int init_paging_system();

page_table_entry_t* create_page_table_init();
page_table_entry_t* create_page_table_main();


typedef page_table_entry_t* (*create_page_table_t)();

extern create_page_table_t create_page_table;

int make_page_directory(uint32_t* page_dir_phys_addr, page_table_entry_t** page_dir_sys_ret);

int map_page(uint32_t vaddr, uint32_t padd, page_table_entry_t* pg_dir, uint32_t mode_bits);

void get_page_dir_entry(uint32_t page_dir_phys_addr, uint32_t index, uint32_t *pdentry);

void page_fault_handler(uint32_t errcode, uint32_t irq_num, void* esp);

#endif
