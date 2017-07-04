#ifndef __libs_structs_h
#define __libs_structs_h

#include "libs16/code16.h"
#include "kerneltypes.h"


#include "libs/utils.h"

typedef struct __PACKED s_lim_addr_ptr
{

	uint16_t lim;
	uint32_t addr;

} lim_addr_ptr;

#define SET_LIM_ADDR(xdt_ptr, limit, table_ptr)  \
                      { (xdt_ptr).lim = (limit)-1; \
                        (xdt_ptr).addr = (uint32_t) (table_ptr); }



enum {QUEUE_OK = 0, QUEUE_EMPTY = 1, QUEUE_FULL = 2};

typedef struct s_queue_contr
{
  uint32_t get;
  uint32_t put;
  uint32_t size;
  uint32_t capacity_left;
  uint32_t fieldlen;
  uint8_t *p_base;
} queue_contr_t;

uint32_t reset_queue(queue_contr_t *p, uint32_t size, uint32_t fieldlen, void* pbase );

uint32_t is_full_queue(queue_contr_t *p);

uint32_t put_queue(queue_contr_t *p, void* elem);

uint32_t get_queue(queue_contr_t *p, void* elem);

#endif
