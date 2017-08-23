
#include "libs/kerneldefs.h"

#include "drivers/hardware.h"
#include "libs32/kalloc.h"
#include "libs32/klib.h"
#include "kernel32/process.h"
#include "mem/pagedesc.h"
#include "mem/malloc.h"
#include "mem/pagingdefs.h"
#include "mem/paging.h"

// global system page directory
page_table_entry_t* global_page_dir_sys;
create_page_table_t create_page_table;



static uint8_t* ptx = (uint8_t*)0xb8000;


// present and writable
#define PG_BIT_PW (PG_BIT_P | PG_BIT_RW)

void* get_page(uint32_t mode)
{
	void* p = malloc(PAGE_SIZE);
	if (p)
	{
		memset(p, 0, PAGE_SIZE);
	}
}

void* get_page_with_refcnt(uint32_t mode)
{
	void* p = malloc(PAGE_SIZE);
	if (p)
	{
		memset(p, 0, PAGE_SIZE);
		page_desc_t* pd = BLK_PTR(ADDR_TO_PDESC_INDEX(p));
		++pd->use_cnt;
	}
	return p;
}


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

int map_page1(uint32_t vaddr, uint32_t paddr,
				page_table_entry_t* pg_dir, uint32_t mode_bits_ptab, uint32_t mode_bits_pdir)
{

	if (vaddr < 0xc0000000) {
		DEBUGOUT1(0, "enter map_page vaddr = %08x, paddr = %08x\n", vaddr, paddr);
	}

	uint32_t pg_dir_index = PG_PAGE_DIR_INDEX(vaddr);
	uint32_t pg_table_index = PG_PAGE_TABLE_INDEX(vaddr);

	page_table_entry_t *pde = pg_dir + pg_dir_index;
	page_table_entry_t *pte = 0;
	if (!(pde->val))
	{
		pte = (*create_page_table)();

		// outb_printf("create_page_table case.\n");

		PG_PTE_SET_FRAME_ADDRESS(*pde, __PHYS(pte));
		PG_PTE_SET_BITS(*pde, mode_bits_pdir);

	}
	else
	{

		//outb_printf("non create_page_table case.\n");

		PG_PTE_SET_BITS(*pde, mode_bits_pdir);
		uint32_t phys_pte = PG_PTE_GET_FRAME_ADDRESS(*pde);
		pte = __VADDR(phys_pte);
	}

	pte = pte + pg_table_index;

	PG_PTE_SET_FRAME_ADDRESS(*pte, paddr);
	PG_PTE_SET_BITS(*pte, mode_bits_ptab);

	INVLPG();

	return 0;
}



int map_page(uint32_t vaddr, uint32_t paddr,
				page_table_entry_t* pg_dir, uint32_t mode_bits)
{
	return map_page1(vaddr, paddr, pg_dir, mode_bits, mode_bits);
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

  // 256 page tables are allocated. This corresponds to
  // 256 times 4M mapped physical memory
  // (note that one page table maps 1024 * 4KB = 4MB memory)
  // Therefore one page directory entry controls 4MB and
  // 1024 page directory entries map 4GB virtual memory.

	page_dir_phys_addr = ((uint32_t) __PHYS(page_dir_sys_loc));

	global_page_dir_sys = page_dir_sys_loc;

	raw_printf("before set_cr3 page_dir_phys_addr = %08x addr init_paging_system = %08x ",
			(uint32_t) page_dir_phys_addr, (uint32_t) &init_paging_system);

	set_cr3(page_dir_phys_addr);

	raw_printf("after set_cr3 ");

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
  			*(global_page_dir_sys + (vaddr >> (PG_FRAME_BITS + PG_PAGE_TABLE_BITS)));
  }

	*page_dir_phys_addr = ((uint32_t) __PHYS(page_dir_sys_loc));

	return 0;

}


void get_page_dir_entry(uint32_t page_dir_phys_addr, uint32_t index, uint32_t *pdentry)
{
	page_table_entry_t* pdirbase = (page_table_entry_t*) __VADDR(page_dir_phys_addr);
	*pdentry = pdirbase[index].val;
}

page_table_entry_t *resolve_pde_vaddr(uint32_t lin_addr, page_table_entry_t* cur_page_dir_sys)
{
	uint32_t pd_index = PG_PAGE_DIR_INDEX(lin_addr);
	uint32_t pde_phys = PG_PTE_GET_FRAME_ADDRESS(cur_page_dir_sys[pd_index]);
	uint32_t pde_flags = PG_PTE_GET_BITS(cur_page_dir_sys[pd_index]);
	if (pde_flags & PG_BIT_P)
	{
		return cur_page_dir_sys + pd_index;
	}
	else
	{
		return 0;
	}
}

page_table_entry_t *resolve_pte_vaddr(uint32_t lin_addr, page_table_entry_t* cur_page_dir_sys)
{

	uint32_t pd_index = PG_PAGE_DIR_INDEX(lin_addr);
	uint32_t pt_index = PG_PAGE_TABLE_INDEX(lin_addr);

	uint32_t pde_phys = PG_PTE_GET_FRAME_ADDRESS(cur_page_dir_sys[pd_index]);
	uint32_t pde_flags = PG_PTE_GET_BITS(cur_page_dir_sys[pd_index]);
	if (pde_flags & PG_BIT_P)
	{
		page_table_entry_t *pde_ptr = __VADDR(pde_phys);
		return pde_ptr + pt_index;
	}
	else
	{
		return 0;
	}
}


void page_fault_handler(uint32_t errcode, uint32_t irq_num, void* esp)
{
	uint32_t esp_val;
	asm __volatile__ ( "movl %%esp, %0" : "=g"(esp_val));
	uint32_t lin_addr;
	asm __volatile__ ( "movl %%cr2, %0" : "=r"(lin_addr));

	iret_blk_t* pir = (iret_blk_t*)(PROC_STACK_BEG(current) - sizeof(iret_blk_t));

	outb_printf("page fault = %d %08x esp = %08x cs = %08x ds = %08x\n", errcode, lin_addr, esp_val,
			(uint32_t)get_cs(), (uint32_t)get_ds());

	//print_iret_blk(pir);


	void* cur_page_dir_sys;
	cur_page_dir_sys = __VADDR(get_cr3());

	uint32_t is_userarea_lin_addr = lin_addr < KERNEL_UPPER;


	uint32_t in_usermode = errcode & PG_BIT_US;
	uint32_t was_a_write = errcode & PG_BIT_RW;
	uint32_t not_present = !(errcode & PG_BIT_P);
	uint32_t protection_violation = errcode & PG_BIT_P;

	if (!in_usermode)
	{
		outb_printf("page_fault_handler: error in supervisor mode.\n");
		while (1) {};
	}

	if (in_usermode && !is_userarea_lin_addr && protection_violation)
	{
		outb_printf("page_fault_handler: illegal access from user code to system area.\n");
		while (1) {};
	}

	if (protection_violation && in_usermode && was_a_write && is_userarea_lin_addr)
	{
		// COW case

		outb_printf("page_fault_handler: doing copy on write.\n");

		void *p = get_page_with_refcnt(0);

		uint32_t lin_addr1 = PG_GET_VADDR(PG_PAGE_DIR_INDEX(lin_addr), PG_PAGE_TABLE_INDEX(lin_addr));

		outb_printf("normalized lin_addr = %08x\n", lin_addr1);


		page_table_entry_t* pde = resolve_pde_vaddr(lin_addr, cur_page_dir_sys);
		page_table_entry_t* pte = resolve_pte_vaddr(lin_addr, cur_page_dir_sys);

		uint32_t pde_bits = PG_PTE_GET_BITS(*pde);
		uint32_t pte_bits = PG_PTE_GET_BITS(*pte);

		outb_printf("pde_bits = %08x pte_bits = %08x\n", pde_bits, pte_bits);

		pte_bits |= PG_BIT_RW;
		pde_bits |= PG_BIT_RW;

		outb_printf("new: pde_bits = %08x pte_bits = %08x\n", pde_bits, pte_bits);

		uint32_t phys_addr_frame = PG_PTE_GET_FRAME_ADDRESS(*pte);

		void *p_old = __VADDR(phys_addr_frame);

		outb_printf("p = %08x p_old = %08x\n", (uint32_t)p, (uint32_t)p_old);

		memcpy(p, p_old, PAGE_SIZE);

		outb_printf("memcpy done.\n");

		page_desc_t* pdesc = BLK_PTR(ADDR_TO_PDESC_INDEX(p_old));
		--pdesc->use_cnt;

		if (!pdesc->use_cnt && !(pdesc->flags & PDESC_FLAG_NOMEM))
		{
			DEBUGOUT1(0, "freeing page_frame paddr_frame = %08x\n", (uint32_t) phys_addr_frame);
			free(p_old);
		}

		map_page1(lin_addr, (uint32_t)__PHYS(p), cur_page_dir_sys, pte_bits, pde_bits);

		outb_printf("map_page1 done.\n");

		return;

	}

	if (in_usermode && is_userarea_lin_addr)
	{
		void *p = get_page_with_refcnt(0);
		uint32_t paddr = (uint32_t)__PHYS(p);

		if (!lin_addr)
		{
			printf("Access to address 0 forbidden:\n");
			print_iret_blk(pir);
			while (1) {};
		}

		if (p)
		{
			outb_printf("page_fault: p allocated = %08x\n", (uint32_t) p);

			map_page(lin_addr, paddr, (page_table_entry_t*)cur_page_dir_sys, PG_BIT_P | PG_BIT_RW | PG_BIT_US );

			outb_printf("page_fault_handler leave.\n");

			//WAIT((1 << 24));
		}
		else
		{
			outb_printf("page_fault_handler: no free mem found: malloc failed.\n");
			while (1) {};
		}
	}
	else
	{
		outb_printf("page_fault_handler: protection violation.\n");
		while (1) {};
	}
}




void free_page_table_entry(page_table_entry_t* pte)
{
	uint32_t pte_val = PG_PTE_GET_FRAME_ADDRESS(*pte);
	if (pte_val)
	{
		void* pte_val_vaddr = __VADDR(pte_val);
		DEBUGOUT1(0, "free_page_table_entry: p_addr_frame = %08x\n", (uint32_t) pte_val);
		page_desc_t* p_addr_frame_pd = BLK_PTR(ADDR_TO_PDESC_INDEX(pte_val_vaddr));
		--p_addr_frame_pd->use_cnt;
		if (!p_addr_frame_pd->use_cnt && !(p_addr_frame_pd->flags & PDESC_FLAG_NOMEM))
		{
			DEBUGOUT1(0, "freeing page_frame paddr_frame = %08x\n", (uint32_t) pte_val);
			free(pte_val_vaddr);
		}
	}
}

// frees the page table pointed to by *pde from the page directory
void free_page_table(page_table_entry_t* pde)
{
	uint32_t pde_val = PG_PTE_GET_FRAME_ADDRESS(*pde);
	if (pde_val)
	{
		page_table_entry_t* ptab = (page_table_entry_t*) __VADDR(pde_val);
		int i;
		for(i = 0; i < PG_PAGE_TABLE_ENTRIES; ++i)
		{
			free_page_table_entry(&ptab[i]);
		}
		// frees the page table itself
		DEBUGOUT1(0, "free page_table itself ptab = %08x\n", (uint32_t)ptab);
		free(ptab);
	}
}


int copy_page_tables(process_t* proc, uint32_t *new_page_dir_phys, uint32_t mode)
{

	uint32_t pdir_index;
	uint32_t ptable_index;

	bool do_cow_prepare = mode & PG_PTCM_COPY_FOR_COW;

	DEBUGOUT1(0,"**************copy_page_tables: enter\n");

	page_table_entry_t* page_dir = __VADDR(proc->proc_data.tss.cr3);

	page_table_entry_t* new_page_dir = (page_table_entry_t*) get_page(0);

	for(pdir_index = PG_PAGE_DIR_USER_ENTRIES; pdir_index < PG_PAGE_DIR_ENTRIES; ++pdir_index)
	{
		new_page_dir[pdir_index].val = page_dir[pdir_index].val;
	}

	DEBUGOUT1(0,"**** copy_page_tables: copy_user_tables\n");

	for(pdir_index = 0; pdir_index < PG_PAGE_DIR_USER_ENTRIES; ++pdir_index)
	{

		uint32_t pdir_entry_phys = PG_PTE_GET_FRAME_ADDRESS(page_dir[pdir_index]);

		if (pdir_entry_phys)
		{
			page_table_entry_t* p_akt_pagetable = __VADDR(pdir_entry_phys);
			uint32_t mode_bits_pdir = PG_PTE_GET_BITS(page_dir[pdir_index]);

			if (do_cow_prepare)
			{
				PG_PTE_SET_BITS(page_dir[pdir_index], mode_bits_pdir & ~PG_BIT_RW);
			}

			for(ptable_index = 0; ptable_index < PG_PAGE_TABLE_ENTRIES; ++ptable_index)
			{

				uint32_t page_frame_phys = PG_PTE_GET_FRAME_ADDRESS(p_akt_pagetable[ptable_index]);

				if (page_frame_phys)
				{
					DEBUGOUT1(0,"**** copy_page_tables: pdir_index = %d\n", pdir_index);

					DEBUGOUT1(0,"**** copy_page_tables: ptable_index = %d\n", ptable_index);

					page_table_entry_t* page_frame = __VADDR(page_frame_phys);


					uint32_t mode_bits_ptab = PG_PTE_GET_BITS(p_akt_pagetable[ptable_index]);

					if (do_cow_prepare)
					{
						PG_PTE_SET_BITS(p_akt_pagetable[ptable_index], mode_bits_ptab & ~ PG_BIT_RW);
					}

					uint32_t* p_copied_page = 0;
					if (!do_cow_prepare)
					{
						p_copied_page = (uint32_t*) get_page_with_refcnt(0);

						memcpy(p_copied_page, page_frame, PAGE_SIZE);
					}

					uint32_t current_vaddr = PG_GET_VADDR(pdir_index, ptable_index);

					if (do_cow_prepare)
					{
						mode_bits_ptab &= ~PG_BIT_RW;
						mode_bits_pdir &= ~PG_BIT_RW;
					}

					if (!do_cow_prepare)
					{
						map_page1(current_vaddr, (uint32_t)__PHYS(p_copied_page), new_page_dir,
													mode_bits_ptab, mode_bits_pdir);
					}
					else
					{

						page_desc_t* pdesc = BLK_PTR(ADDR_TO_PDESC_INDEX(page_frame));

						++pdesc->use_cnt;

						map_page1(current_vaddr, page_frame_phys, new_page_dir,
												mode_bits_ptab, mode_bits_pdir);
					}
					DEBUGOUT1(0,
							"++++page_copied: vaddr = %08x, page_frame_phys = %08x, mode_bits_pdir = %08x, mode_bits_ptab = %008x\n",
							current_vaddr, page_frame_phys, mode_bits_pdir, mode_bits_ptab);

				}
			}
		}
	}

	*new_page_dir_phys = (uint32_t)__PHYS(new_page_dir);

	return 0;


}



