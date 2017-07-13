

#define NODEBUG

#include "kerneltypes.h"
#include "libs/utils.h"
#include "libs/kerneldefs.h"
#include "libs32/kalloc.h"
#include "libs32/klib.h"
#include "libs32/utils32.h"

#include "mem/pagedesc.h"
#include "mem/memareas.h"
#include "mem/paging.h"


/* global variables */

uint32_t num_pages_total;

page_desc_t *global_page_list;

p_page_desc_t pp_order_heads[MAX_ORDER];

uint32_t free_list_sizes[MAX_ORDER];



/* definitions of used functions */

inline uint32_t get_buddy_index(uint32_t blk_index, uint32_t order)
{
	return blk_index ^ (1 << order);
}

uint32_t mark_occupied(page_desc_t* p_blk, uint32_t order)
{
	PDESC_ALLOCATE(p_blk);
	//p_blk->allocated = 1;
	p_blk->order = order;
	return 0;
}

uint32_t buddy_free(page_desc_t* p_blk)
{

	uint32_t order;
	uint32_t blk_index;
	uint32_t buddy_index;

start:

	DEBUGOUT1(0, "buddy free: index: %d order:%d\n", BLK_INDEX(p_blk), p_blk->order);
	
	order = p_blk->order;
	blk_index = BLK_INDEX(p_blk);
	buddy_index = get_buddy_index(blk_index, order);


	if (buddy_index < num_pages_total)
	{
		p_page_desc_t q = BLK_PTR(buddy_index);
		if (!PDESC_IS_ALLOCATED(q) && q->order == order)
		{
			uint32_t free_index = blk_index & buddy_index;
			p_page_desc_t qq = BLK_PTR(free_index);

			LL_DELETE(&q, links, page_desc_t);

			PDESC_ALLOCATE(qq);
			qq->order = order + 1;
			p_blk = qq;
			goto start;
		}
	}
	LL_INSERT_BEFORE(p_blk, &pp_order_heads[order], links, page_desc_t)

	PDESC_DEALLOCATE(p_blk);
	
	return 0;
}

uint32_t buddy_alloc(uint32_t order)
{

	DEBUGOUT(0,"buddy_alloc: %d\n", order);
	ASSERT(order < MAX_ORDER);
	
	if (order >= MAX_ORDER)
	{
		return num_pages_total;
	}
	
	uint32_t try_order = order;
	while (try_order < MAX_ORDER && !pp_order_heads[try_order])
		++try_order;
		
	ASSERT(try_order < MAX_ORDER);
	
	p_page_desc_t q = pp_order_heads[try_order];
	LL_DELETE(&pp_order_heads[try_order], links, page_desc_t);

	PDESC_ALLOCATE(q);
	q->order = try_order;

	uint32_t q_index = BLK_INDEX(q);
	
	while (try_order > order)
	{
		uint32_t next_order = try_order - 1;
		p_page_desc_t p_half = BLK_PTR(q_index + (1 << next_order));
		p_half->order = next_order;
		PDESC_ALLOCATE(p_half);
		volatile num = buddy_free(p_half);
		try_order = next_order;
	}

	q->order = order;
	PDESC_ALLOCATE(q);
	
	DEBUGOUT(0, "buddy_alloc:allocated: %d\n", q_index);
	
	return q_index;
	
}

void fill_free_list_sizes()
{
	int i_order = 0;
	for(i_order = 0; i_order < MAX_ORDER; ++i_order)
	{
		int n_cnt = 0;
		page_desc_t *q = pp_order_heads[i_order];
		while (q)
		{
			++n_cnt;
			ASSERT(!PDESC_IS_ALLOCATED(q));
			ASSERT(q->order == i_order);
			q = q->links.next;
		}
		free_list_sizes[i_order] = n_cnt;
	}
}

void get_order_stat(int mode, uint32_t *free_bytesa)
{
	fill_free_list_sizes();
	int i_order = 0;

	uint32_t free_bytes = 0;

	for(i_order = 0; i_order < MAX_ORDER; ++i_order)
	{
		uint32_t n_cnt = free_list_sizes[i_order];

		free_bytes += n_cnt * (1 << (i_order + 12));

		if (mode == 0) {
			DEBUGOUT(0, "order %d: len: %d\n", i_order, n_cnt);
		}
	}
	if (free_bytesa) {
		*free_bytesa = free_bytes;
	}
}

void full_stat(uint32_t alloc_size)
{
	uint32_t free_size = 0;
	int i = 0;
	for(i = 0; i < MAX_ORDER; ++i)
	{
		free_size += (free_list_sizes[i] * (1 << i));
	}
	printf("alloc: %d free: %d total: %d\n", alloc_size, free_size, alloc_size + free_size);
	ASSERT(alloc_size + free_size == num_pages_total);
}


uint32_t init_order_heads()
{
	int i = 0;
	for(i = 0; i < MAX_ORDER; ++i)
	{		
		pp_order_heads[i] = 0;
	}
	return 0;
}

uint32_t init_buddy_system_test(uint32_t n_blks)
{
	global_page_list = 0;

	global_page_list = kalloc_fixed_aligned(n_blks * sizeof(page_desc_t), sizeof(page_desc_t));
	
	if (global_page_list == NULL)
	{
		printf("init_buddy_system: malloc %d blocks failed.", n_blks);
		return 1;
	}

	//DEBUGOUT(0, "sizeof(page_desc_t) = %d\n", sizeof(page_desc_t));

	//STOP;

	num_pages_total = n_blks;

	
	init_order_heads();

	uint32_t i = 0;
	
	for(i = 0; i < n_blks; ++i)
	{
		mark_occupied(global_page_list + i, 0);
	}

	printf("init_buddy_system: mark_occupied_done.\n");
	
	for(i = 0; i < n_blks; ++i)
	{
		buddy_free(global_page_list + i);
		// WAIT(1 << 23);
	}
	
	return 0;	
}

uint32_t destroy_buddy_system()
{
	return 0;
}


uint32_t get_allocated_size(p_page_desc_t* pholders, uint32_t n_holders)
{
	int i = 0;
	uint32_t alloc_size = 0;
	for(i = 0; i < n_holders; ++i)
	{
		ASSERT(PDESC_IS_ALLOCATED(pholders[i]));
		alloc_size = alloc_size + (1 << (pholders[i]->order));
	}
	return alloc_size;
}

#define MAX_HOLDERS 768
#define MAX_ALLOC_ORDER 4


uint32_t test_buddy_system()
{
	p_page_desc_t pholders[MAX_HOLDERS];
	
	uint32_t n_alloc = MAX_HOLDERS;
	
	int i = 0;
	
	for(i = 0; i < n_alloc; ++i)
	{

		uint32_t rnd_order_i = rand() % MAX_ALLOC_ORDER;
		X_DEBUGOUT(0, "test_buddy_system: i: %d rnd_order_i: %d\n", i, rnd_order_i);

		uint32_t blk_index = buddy_alloc(rnd_order_i);

		pholders[i] = BLK_PTR(blk_index);

		X_ASSERT(pholders[i]->order == rnd_order_i);
		
		fill_free_list_sizes();
		uint32_t alloc_size = get_allocated_size(pholders, i + 1);
		full_stat(alloc_size);

	}

	int i_ex = 0;
	
	for(i_ex = 0; i_ex < 10000; ++i_ex)
	{

		
		uint32_t j = rand() % n_alloc;
		uint32_t rnd_order_i = rand() % MAX_ALLOC_ORDER;

		X_DEBUGOUT(0, "test_buddy_system: i_ex: %d: rnd_order_i: %d\n", i_ex, rnd_order_i);

		buddy_free(pholders[j]);
		uint32_t blk_index = buddy_alloc(rnd_order_i);
		pholders[j] = BLK_PTR(blk_index);

		X_ASSERT(pholders[j]->order == rnd_order_i);
	
		fill_free_list_sizes();
		uint32_t alloc_size = get_allocated_size(pholders, n_alloc);
		full_stat(alloc_size);		
		// WAIT((1 << 20) * 1);
	}	
	
	return 0;
	
}


uint32_t init_global_page_list()
{
	size_t table_len = 0;
	bios_mem_area_entry_t* p_entry = NULL;

	size_t i = 0;

	// table_len is len of BIOS memarea table
	// p_entry is pointer to start of this table

	//raw_printf(" before_get_mem_area_table_info ");

	get_mem_area_table_info(&table_len, &p_entry);

	//raw_printf( "table_len = %d ", table_len);

	uint32_t max_address = 0;

	for(i = 0; i < table_len; ++i, ++p_entry)
	{
		uint32_t field_start = p_entry->base_address;
		uint32_t field_end = field_start + p_entry->length;
		uint32_t typ = p_entry->type;
		// p_entry->acpi ignored

		if (typ == 1)
		{
			max_address = max(max_address, field_end - 1);
		}

	}

	max_address = min(max_address, MAX_ADDRESS_PHYS);

	uint32_t n_pages = align(max_address + 1, PAGE_SIZE) / PAGE_SIZE;

	global_page_list = 0;

	global_page_list = kalloc_fixed_aligned(n_pages * sizeof(page_desc_t), sizeof(page_desc_t));
	memset(global_page_list, 0, n_pages * sizeof(page_desc_t));

	if (global_page_list == NULL)
	{
		DEBUGOUT1(0, "init_global_page_list: malloc %d blocks failed.\n", n_pages);
		return 1;
	}
	else
	{
		DEBUGOUT1(0, "init_global_page_list: %d page_desc_t of total size %d\n",
																		n_pages, n_pages * sizeof(page_desc_t));
	}

	num_pages_total = n_pages;
	for(i = 0; i < num_pages_total; ++i)
	{
		global_page_list[i].flags = PDESC_FLAG_NOMEM | PDESC_FLAG_ALLOC;
	}

	get_mem_area_table_info(&table_len, &p_entry);

	for(i = 0; i < table_len; ++i, ++p_entry)
	{
		uint32_t field_start = p_entry->base_address;
		uint32_t field_end = field_start + p_entry->length;
		uint32_t typ = p_entry->type;
		// p_entry->acpi ignored

#define TO_PAGE(x) ((x) >> PG_FRAME_BITS)

		uint32_t page_start = TO_PAGE(align(field_start, PAGE_SIZE));
		uint32_t page_end = TO_PAGE(field_end);
		uint32_t j;
		if (typ == 1)
		{
			for(j = page_start; j < page_end; ++j)
			{

				if (j >= num_pages_total)
					break;

#define KERNEL_32_START_PAGE (KERNEL_32_START >> PG_FRAME_BITS)

				ASSERT( (((char*)kalloc_peek_align() - (char*)KERNEL_32_START_UPPER)>>12) < 2048);

				// declare 2060 pages (about 8437 kB) as NOMEM kernel memory
				// this is not used in the buddy system
				// it contains all the allocations done in the buildup phase by kalloc_fixed_aligned
				// and the kernel stack at KERNEL_UPPER + 0x800000
				if (j >= KERNEL_32_START_PAGE && j <= KERNEL_32_START_PAGE + 2060 /*- 256*/ )
					continue;

#undef KERNEL_32_START_PAGE

				page_desc_t *p = &global_page_list[j];

				p->flags &= ~PDESC_FLAG_NOMEM;

			}
		}
	}

	return 0;
}

uint32_t init_buddy_system(uint32_t n_pages)
{


	init_order_heads();

	uint32_t i = 0;

	for(i = 0; i < n_pages; ++i)
	{
		mark_occupied(global_page_list + i, 0);
	}

	DEBUGOUT1(0, "init_buddy_system: mark_occupied_done.\n");

	for(i = 0; i < n_pages; ++i)
	{
		if (!PDESC_IS_NOMEM(global_page_list + i))
			buddy_free(global_page_list + i);
	}

	return 0;
}
