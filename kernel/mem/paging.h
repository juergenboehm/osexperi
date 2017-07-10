#ifndef __mem_paging_h
#define __mem_paging_h

#include "kerneltypes.h"
#include "libs/kerneldefs.h"
#include "kernel32/process.h"



typedef struct __PACKED page_table_entry_s {

	uint32_t	val;

} page_table_entry_t;


typedef page_table_entry_t* page_dir_t;
typedef page_table_entry_t* page_table_t;


extern page_table_entry_t* global_page_dir_sys;


// the system maintains a list of page descriptors for all
// available physical pages

int init_paging_system_provis();
int init_paging_system();

page_table_entry_t* create_page_table_init();
page_table_entry_t* create_page_table_main();


typedef page_table_entry_t* (*create_page_table_t)();

extern create_page_table_t create_page_table;

void* get_page(uint32_t mode);


int make_page_directory(uint32_t* page_dir_phys_addr, page_table_entry_t** page_dir_sys_ret);

int map_page1(uint32_t vaddr, uint32_t paddr,
				page_table_entry_t* pg_dir, uint32_t mode_bits_ptab, uint32_t mode_bits_pdir);

int map_page(uint32_t vaddr, uint32_t padd, page_table_entry_t* pg_dir, uint32_t mode_bits);

void get_page_dir_entry(uint32_t page_dir_phys_addr, uint32_t index, uint32_t *pdentry);

void page_fault_handler(uint32_t errcode, uint32_t irq_num, void* esp);

void free_page_table(page_table_entry_t* pte);

int copy_page_tables(process_t* proc, uint32_t *new_page_dir_phys, uint32_t mode);


#endif
