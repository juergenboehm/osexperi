
#ifndef __mem_pagedesc_h
#define __mem_pagedesc_h

#include "kerneltypes.h"
#include "mem/paging.h"
#include "mem/linklist.h"

#define BLK_INDEX(p) ((uint32_t)((p) - global_page_list))
#define BLK_PTR(index) (global_page_list + (index))

#define PDESC_INDEX_TO_ADDR(i) ((void*) (KERNEL_UPPER + ((i) << PG_FRAME_BITS)))
#define ADDR_TO_PDESC_INDEX(p) (((uint32_t)(p)-KERNEL_UPPER) >> PG_FRAME_BITS)


#define NEXT_PTR(q) ((typeof(q)) (q->link.next))
#define PREV_PTR(q) ((typeof(q)) (q->link.prev))

#define MAX_ORDER 20

//
// PDESC_FLAG_ALLOC set has the following meaning:
// if set in a page that has 2^k order
// it means that the 2^k block starting with the page
// is not in the 2^k free_list of the buddy system
// it does _not_ mean something for a single page only
// if not set in a 2^k order block it means that
// the following 2^k block is free and should appear in
// the respective 2^k free_list of the buddy system
//
// In the beginning, for all pages PDESC_FLAG_ALLOC is set
// then for every usable page the page is freed with
// buddy_free. As buddy_free is doing allocs and markings
// on intermediate result blocks, only a small number
// of pages is not marked with PDESC_FLAG_ALLOC finally
// although most pages are considered free by the buddy
// system and appear in the free_list. (Concretely
// the non ALLOC marked pages are the headers of
// big order blocks in the (upper) free_list
//

// PDESC_FLAG_NOMEM means the page is not in the buddy system
// initial free lists.

// PDESC_FLAG_MALLOC means the page is used by the system malloc
// to allocate smaller objects than one page.


#define PDESC_FLAG_ALLOC	(1 << 0)
#define PDESC_FLAG_NOMEM  (1 << 1)
#define PDESC_FLAG_MALLOC (1 << 2)





struct page_desc_t;

typedef LINK_S(page_desc_t) LINK_T(page_desc_t);

typedef struct page_desc_t
{
	LINK_T(page_desc_t) links;

	uint32_t flags;
	uint32_t order;

	uint32_t malloc_order;

} page_desc_t;

typedef page_desc_t *p_page_desc_t;


#define PDESC_IS_ALLOCATED(p) ((p)->flags & PDESC_FLAG_ALLOC)
#define PDESC_IS_NOMEM(p) ((p)->flags & PDESC_FLAG_NOMEM)

#define PDESC_ALLOCATE(p) { (p)->flags |= PDESC_FLAG_ALLOC; }
#define PDESC_DEALLOCATE(p) { (p)->flags &= ~(uint32_t)(PDESC_FLAG_ALLOC); }



extern page_desc_t *global_page_list;
extern uint32_t num_pages_total;

#define INDEX_IS_NULL(i) (((i) == num_pages_total))


/* declaration of used functions */

/* initialization of global_page_list */

uint32_t init_global_page_list();


/* buddy system */


inline uint32_t get_buddy_index(uint32_t blk_index, uint32_t order);

uint32_t mark_occupied(page_desc_t* p_blk, uint32_t order);

uint32_t buddy_free(page_desc_t* p_blk);
uint32_t buddy_alloc(uint32_t order);


uint32_t init_order_heads();
uint32_t init_buddy_system(uint32_t n_pages);

/* buddy system test */

uint32_t init_buddy_system_test(uint32_t n_blks);

void get_order_stat(int mode, uint32_t *free_bytesa);

uint32_t test_buddy_system();



#endif
