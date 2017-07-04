#ifndef __mem_malloc_h
#define __mem_malloc_h

#include "kerneltypes.h"


typedef struct malloc_node {
	struct malloc_node* next;
} malloc_node_t;

// start with size = 8 = 2^3 till 2^17 => 2^0 .. 2^14 => size = 15

#define MIN_ALLOC_SIZE 8
#define LOG_MIN_ALLOC_SIZE 3

#define MALLOC_HEADS_NUM 15

uint32_t malloc_sizes_log[MALLOC_HEADS_NUM];

malloc_node_t *malloc_heads[MALLOC_HEADS_NUM];

//

#define MALLOC_FIXED_TYPE(type,num,align_mult) ((type*) (malloc((num)*sizeof(type))))

// malloc

void init_malloc_system();

void* malloc(uint32_t size);
void free(void * p);

uint32_t test_malloc();

uint32_t get_pages_count(uint32_t page_desc_code, uint32_t page_desc_code_not);
uint32_t get_malloc_pages_count();
uint32_t get_flags_eq_pages_count(uint32_t page_desc_flags);
uint32_t get_not_pages_count(uint32_t page_desc_code_not);





#endif /* __mem_malloc_h */
