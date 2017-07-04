
#include "libs/kerneldefs.h"

#include "drivers/hardware.h"
#include "libs32/kalloc.h"
#include "libs32/klib.h"
#include "mem/malloc.h"
#include "mem/paging.h"


page_table_entry_t* page_dir_sys;
create_page_table_t create_page_table;



static uint8_t* ptx = (uint8_t*)0xb8000;


// present and writable
#define PG_BIT_PW (PG_BIT_P | PG_BIT_RW)


void wait(uint32_t n)
{
	volatile uint32_t i = 0;
	for(i = 0; i < n; ++ i);
}

void kprint_U32x(uint8_t** pt, uint32_t num)
{
	size_t i = 0;

	for(i = 0; i < 8; ++i)
	{
		uint32_t digit = (num >> ((7 - i) * 4)) & 0x0f;
		**pt = digit > 9 ? 'a' + digit - 10 : '0' + digit;
		(*pt)++;
		**pt = 0x1e;
		(*pt)++;
	}
	for(i = 0; i < 2; ++i)
	{
		**pt = ' ';
		(*pt)++;
		**pt = 0x1e;
		(*pt)++;
	}

	if ((uint32_t) (*pt) > 0xb8000 + 24 * 80 * 2)
		(*pt) = (uint8_t*) 0xb8000;
}


int init_paging_system_provis()
{

	page_table_entry_t* page_table_4M = (page_table_entry_t*) PAGE_TABLE_4M_PROVIS;
	page_table_entry_t* page_table_8M = (page_table_entry_t*) PAGE_TABLE_8M_PROVIS;
	page_table_entry_t* page_dir_start = (page_table_entry_t*) PAGE_DIR_ADDRESS_PROVIS;

	size_t i = 0;

	uint8_t* pt = (uint8_t*)0xb8000;

	for(i = 0; i < PG_PAGE_TABLE_ENTRIES; ++i)
	{

		PG_PTE_SET_FRAME_ADDRESS(page_table_4M[i], i << PG_FRAME_BITS);
		PG_PTE_SET_BITS(page_table_4M[i], 0x03);

		PG_PTE_SET_FRAME_ADDRESS(page_table_8M[i], (i + PG_PAGE_TABLE_ENTRIES) << PG_FRAME_BITS);
		PG_PTE_SET_BITS(page_table_8M[i], PG_BIT_PW);

		kprint_U32x(&ptx, page_table_4M[i].val);

		PG_PTE_SET_FRAME_ADDRESS(page_dir_start[i], 0);
		PG_PTE_SET_BITS(page_dir_start[i], 0);

	}

	PG_PTE_SET_FRAME_ADDRESS(page_dir_start[0], (uint32_t)page_table_4M);
	PG_PTE_SET_BITS(page_dir_start[0], PG_BIT_PW);

	PG_PTE_SET_FRAME_ADDRESS(page_dir_start[1], (uint32_t)page_table_8M);
	PG_PTE_SET_BITS(page_dir_start[1], PG_BIT_PW);

	PG_PTE_SET_FRAME_ADDRESS(page_dir_start[768], (uint32_t)page_table_4M);
	PG_PTE_SET_BITS(page_dir_start[768], PG_BIT_PW);

	PG_PTE_SET_FRAME_ADDRESS(page_dir_start[769], (uint32_t)page_table_8M);
	PG_PTE_SET_BITS(page_dir_start[769], PG_BIT_PW);

	kprint_U32x(&ptx, page_dir_start[0].val);
	kprint_U32x(&ptx, page_dir_start[1].val);
	kprint_U32x(&ptx, page_dir_start[768].val);
	kprint_U32x(&pt, page_dir_start[769].val);

	return 0;

}

page_table_entry_t* create_page_table_init()
{
	page_table_entry_t *pt =
			(page_table_entry_t*)kalloc_fixed_aligned(PG_PAGE_DIR_SIZE, PAGE_SIZE);
	memset(pt, 0, PAGE_SIZE);

	return pt;
}

page_table_entry_t* create_page_table_main()
{
	page_table_entry_t *pt =
			(page_table_entry_t*)malloc(PG_PAGE_DIR_SIZE);
	memset(pt, 0, PAGE_SIZE);

	return pt;
}



int map_page(uint32_t vaddr, uint32_t paddr,
				page_table_entry_t* pg_dir, uint32_t mode_bits)
{

	if (vaddr < 0xc0000000) {
		DEBUGOUT(0, "enter map_page vaddr = %08x, paddr = %08x\n", vaddr, paddr);
	}

	uint32_t pg_dir_index = PG_PAGE_DIR_INDEX(vaddr);
	uint32_t pg_table_index = PG_PAGE_TABLE_INDEX(vaddr);

	page_table_entry_t *pde = pg_dir + pg_dir_index;
	page_table_entry_t *pte = 0;
	if (!(pde->val))
	{
		pte = (*create_page_table)();

		PG_PTE_SET_FRAME_ADDRESS(*pde, __PHYS(pte));
		PG_PTE_SET_BITS(*pde, mode_bits);

	}
	else
	{
		uint32_t phys_pte = PG_PTE_GET_FRAME_ADDRESS(*pde);
		pte = __VADDR(phys_pte);
	}

	pte = pte + pg_table_index;

	PG_PTE_SET_FRAME_ADDRESS(*pte, paddr);
	PG_PTE_SET_BITS(*pte, mode_bits);

	return 0;
}


int init_paging_system()
{

	create_page_table = &create_page_table_init;

	uint32_t page_dir_phys_addr = 0;

	page_table_entry_t* page_dir_sys_loc = (*create_page_table)();

	kprint_U32x(&ptx, (uint32_t)page_dir_sys_loc);

	// The final kernel map marks all pages below KERNEL_UPPER (=0xc0000000)
  // as not present.
  // Ideally all physical memory from 0x0 onwards gets from the viewpoint of
  // the kernel linearly mapped to 0xc0000000 onward.
  // Therefore the problem with more than 1G *physical* memory.

  uint32_t vaddr;
  uint32_t paddr = 0;

  for(vaddr = KERNEL_UPPER; vaddr; vaddr += PAGE_SIZE)
  {
  	map_page(vaddr, paddr, page_dir_sys_loc, PG_BIT_P | PG_BIT_RW);
  	paddr += PAGE_SIZE;
  }

  // NUM_INIT_PAGE_DIR_ENTRIES page tables are allocated. This corresponds to
  // NUM_INIT_PAGE_DIR_ENTRIES times 4M mapped physical memory
  // (note that one page table maps 1024 * 4KB = 4MB memory)
  // Therefore one page directory entry controls 4MB and
  // 1024 page directory entries map 4GB virtual memory.

	page_dir_phys_addr = ((uint32_t) __PHYS(page_dir_sys_loc));

	page_dir_sys = page_dir_sys_loc;

	set_cr3(page_dir_phys_addr);

	return 0;

}


int make_page_directory(uint32_t * page_dir_phys_addr, page_table_entry_t** page_dir_sys_ret)
{
	page_table_entry_t* page_dir_sys_loc = (*create_page_table)();

	*page_dir_sys_ret = page_dir_sys_loc;

	//kprint_U32x(&ptx, (uint32_t)page_dir_sys_loc);

  uint32_t vaddr;
  uint32_t i;

  for(i = 0; i < (KERNEL_UPPER >> (PG_FRAME_BITS + PG_PAGE_TABLE_BITS)); ++i)
  {
  	(page_dir_sys_loc + i)->val = 0;
  }

  for(vaddr = KERNEL_UPPER; vaddr; vaddr += PAGE_SIZE)
  {
  	*(page_dir_sys_loc + (vaddr >> (PG_FRAME_BITS + PG_PAGE_TABLE_BITS))) =
  			*(page_dir_sys + (vaddr >> (PG_FRAME_BITS + PG_PAGE_TABLE_BITS)));
  }

	*page_dir_phys_addr = ((uint32_t) __PHYS(page_dir_sys_loc));

	return 0;

}


void get_page_dir_entry(uint32_t page_dir_phys_addr, uint32_t index, uint32_t *pdentry)
{
	page_table_entry_t* pdirbase = (page_table_entry_t*) __VADDR(page_dir_phys_addr);
	*pdentry = pdirbase[index].val;
}


void page_fault_handler(uint32_t errcode, uint32_t irq_num, void* esp)
{
	uint32_t esp_val;
	asm __volatile__ ( "movl %%esp, %0" : "=g"(esp_val));
	uint32_t lin_addr;
	asm __volatile__ ( "movl %%cr2, %0" : "=r"(lin_addr));
	printf("page fault = %d %d 0x%08x esp = 0x%08x cs = %08x\n", errcode, irq_num, lin_addr, esp_val,
			(uint32_t)get_cs());
	void *p = malloc(PAGE_SIZE);
	uint32_t paddr = (uint32_t)__PHYS(p);
	void* cur_page_dir_sys;
	cur_page_dir_sys = __VADDR(get_cr3());
	map_page(lin_addr, paddr, (page_table_entry_t*)cur_page_dir_sys, PG_BIT_P | PG_BIT_RW | PG_BIT_US );
	WAIT((1 << 24));
}

