
#include "drivers/hardware.h"

#include "mem/pagedesc.h"
#include "mem/paging.h"
#include "mem/malloc.h"

void init_malloc_system()
{
	uint32_t i;
	uint32_t size = MIN_ALLOC_SIZE;
	for(i = 0; i < MALLOC_HEADS_NUM; ++i)
	{
		malloc_sizes_log[i] = size;
		size <<= 1;
		malloc_heads[i] = 0;
	}
	create_page_table = &create_page_table_main;
}

void refill_malloc_nodes(uint32_t log_size)
{
	DEBUGOUT(5, "enter refill_malloc_nodes(%d)\n", log_size);

	uint32_t size = (1 << log_size) << LOG_MIN_ALLOC_SIZE;

	uint32_t q_alloc = buddy_alloc(0);

	if (INDEX_IS_NULL(q_alloc))
		return;

	page_desc_t *pd_alloc = BLK_PTR(q_alloc);
	pd_alloc->flags |= PDESC_FLAG_MALLOC;
	pd_alloc->malloc_order = log_size;

	char* q = PDESC_INDEX_TO_ADDR(q_alloc);

	malloc_node_t *p = malloc_heads[log_size];

	((malloc_node_t*)q)->next = p;

	p = (malloc_node_t*) q;

	uint32_t rest = PAGE_SIZE - size;

	while (rest)
	{
		q += size;
		((malloc_node_t*)q)->next = p;
		rest -= size;
		p = (malloc_node_t*)q;
	}

	malloc_heads[log_size] = p;

	DEBUGOUT(5, "leave refill_malloc_nodes\n");

}

void* get_malloc_node(uint32_t log_size)
{
	DEBUGOUT1(1, "enter get_malloc_node\n");

	if (log_size >= PG_FRAME_BITS - LOG_MIN_ALLOC_SIZE)
	{
		uint32_t q_alloc = buddy_alloc(log_size + LOG_MIN_ALLOC_SIZE - PG_FRAME_BITS);

		DEBUGOUT1(1, "q_alloc = %08x\n", q_alloc);

		if (INDEX_IS_NULL(q_alloc))
		{
			return 0;
		}

		page_desc_t *pd_alloc = BLK_PTR(q_alloc);
		pd_alloc->flags |= PDESC_FLAG_MALLOC;
		pd_alloc->malloc_order = log_size;

		void* q = PDESC_INDEX_TO_ADDR(q_alloc);

		return q;
	}

	void* p_free = malloc_heads[log_size];
	if (!p_free)
	{
		refill_malloc_nodes(log_size);
		p_free = malloc_heads[log_size];
		if (p_free == 0)
			return 0;
	}
	malloc_heads[log_size] = malloc_heads[log_size]->next;

	DEBUGOUT1(1, "leave get_malloc_node\n");
	return p_free;
}

static uint32_t tally_log_size[MALLOC_HEADS_NUM];


void* malloc(uint32_t size)
{
	// To protect the many memory related datastructures
	// that are acted upon by the now called code.
	uint32_t eflags = irq_cli_save();

	DEBUGOUT1(0, "enter malloc(%d)\n", size);

	uint32_t size_4 = align(size, 4);
	ASSERT(size_4 <= (1 << (MALLOC_HEADS_NUM + LOG_MIN_ALLOC_SIZE - 1)) );

	uint32_t log_size = 0;
	while (log_size < MALLOC_HEADS_NUM && malloc_sizes_log[log_size] < size_4)
		++log_size;
	tally_log_size[log_size]++;

	DEBUGOUT1(1, "log_size = %d\n", log_size);

	void *p_ret = get_malloc_node(log_size);
	DEBUGOUT1(0, "leave malloc p_ret = %08x\n", (uint32_t) p_ret);

	irq_restore(eflags);

	ASSERT(p_ret != 0);

	return p_ret;
}

void free(void * p)
{

	// To protect the many memory related datastructures
	// that are acted upon by the now called code.
	uint32_t eflags = irq_cli_save();

	uint32_t q_pd = ADDR_TO_PDESC_INDEX(p);
	page_desc_t *pdesc = BLK_PTR(q_pd);
	//ASSERT((pdesc->flags & PDESC_FLAG_MALLOC));
	uint32_t malloc_order_log = pdesc->malloc_order;

	DEBUGOUT1(0, "free(%d)\n", (1 << (malloc_order_log + LOG_MIN_ALLOC_SIZE)));

	if (malloc_order_log >= PG_FRAME_BITS - LOG_MIN_ALLOC_SIZE)
	{
		pdesc->flags &= ~PDESC_FLAG_MALLOC;
		buddy_free(pdesc);
	}
	else
	{
		malloc_node_t *pp = malloc_heads[malloc_order_log];
		malloc_heads[malloc_order_log] = p;
		((malloc_node_t*)p)->next = pp;
	}

	irq_restore(eflags);
}

#define LEN_TEST_QUEUE 64

typedef struct test_node {
	void* p;
	uint32_t size;
} test_node_t;

static test_node_t p_queue[LEN_TEST_QUEUE];


static uint32_t pq_read = 0;
static uint32_t pq_write = 0;
static uint32_t pq_fill = 0;

uint32_t get_size_malloc_head(uint32_t log_size)
{
	malloc_node_t *p = malloc_heads[log_size];
	uint32_t sz = 0;
	while (p)
	{
		sz += ((1 << log_size) << LOG_MIN_ALLOC_SIZE);
		p = p->next;
	}
	return sz;
}

uint32_t total_size_malloc_head(uint32_t max_log_size)
{
	uint32_t i;
	uint32_t sz_tot = 0;
	for(i = 0; i < max_log_size; ++i)
	{
		sz_tot += get_size_malloc_head(i);
	}
	return sz_tot;
}

uint32_t get_log_size(uint32_t sz)
{
	uint32_t i = 0;
	while (i < MALLOC_HEADS_NUM && malloc_sizes_log[i] < sz)
		++i;
	return i;
}

void display_size_malloc_heads()
{
	uint32_t i;
	for(i = 0; i < MALLOC_HEADS_NUM; ++i)
	{
		uint32_t sz = get_size_malloc_head(i);
		printf(" %d ", sz);
	}
	printf("\n");
	for(i = 0; i < MALLOC_HEADS_NUM; ++i)
	{
		uint32_t sz = get_size_malloc_head(i);
		printf(" %d ", sz >> PG_FRAME_BITS);
	}
	printf("\n");
}

void display_tally_log_size()
{
	uint32_t i;
	for(i = 0; i < MALLOC_HEADS_NUM; ++i)
	{
		printf( " %d ", tally_log_size[i]);
	}
	printf("\n");
}

uint32_t get_malloc_pages_count()
{
	return get_pages_count(PDESC_FLAG_MALLOC, 0);
}

uint32_t get_pages_count(uint32_t page_desc_code, uint32_t page_desc_code_not)
{
	uint32_t i;
	uint32_t cnt = 0;
	for(i = 0; i < num_pages_total; ++i)
	{
		page_desc_t* pd = BLK_PTR(i);
		if ((pd->flags & page_desc_code) && !(pd->flags & page_desc_code_not))
		{
			cnt++;
		}
	}
	return cnt;
}

uint32_t get_not_pages_count(uint32_t page_desc_code_not)
{
	uint32_t i;
	uint32_t cnt = 0;
	for(i = 0; i < num_pages_total; ++i)
	{
		page_desc_t* pd = BLK_PTR(i);
		if (!(pd->flags & page_desc_code_not))
		{
			cnt++;
		}
	}
	return cnt;
}


uint32_t get_flags_eq_pages_count(uint32_t page_desc_flags)
{
	uint32_t i;
	uint32_t cnt = 0;
	for(i = 0; i < num_pages_total; ++i)
	{
		page_desc_t* pd = BLK_PTR(i);
		if (pd->flags == page_desc_flags)
		{
			cnt++;
		}
	}
	return cnt;
}


uint32_t get_size_queue()
{
	uint32_t i;
	uint32_t sz = 0;

	i = pq_read;
	while (i != pq_write)
	{
		sz += p_queue[i].size;
		i++;
		if (i == LEN_TEST_QUEUE)
			i = 0;
	}
	return sz;
}

uint32_t test_malloc()
{
	uint32_t i;

	for(i = 0; i < MALLOC_HEADS_NUM; ++i)
	{
		tally_log_size[i] = 0;
	}

	printf("*****Start test_malloc.\n\n");

	for(i = 0; i < 10000; ++i )
	{
		if (i < 9000)
		{
			uint32_t size = malloc_sizes_log[rand() % 12] + (rand() % 6 - 3);
			void* p = malloc(size);

			p_queue[pq_write].p = p;
			p_queue[pq_write].size = size;

			pq_write++;
			pq_fill++;
			if (pq_write == LEN_TEST_QUEUE)
				pq_write = 0;
		}

		if (pq_fill > LEN_TEST_QUEUE - 4 || (pq_fill > 0 && i > 9000))
		{
			uint32_t sz_prev = total_size_malloc_head(9);

			uint32_t i = get_log_size(p_queue[pq_read].size);

			void* p = p_queue[pq_read].p;
			p_queue[pq_read].size = 0;
			pq_read++;
			if (pq_read == LEN_TEST_QUEUE)
				pq_read = 0;
			pq_fill--;
			free(p);

			uint32_t sz_after = total_size_malloc_head(9);

			if (i < 9)
				ASSERT(sz_after == sz_prev + malloc_sizes_log[i]);

		}
		printf("Size allocated = %d\n", get_size_queue());
		display_size_malloc_heads();
		display_tally_log_size();

		if (pq_fill == 0)
			break;


	}
		printf("Total Pages with MALLOC_FLAG = %d\n", get_malloc_pages_count());

	return 0;
}



