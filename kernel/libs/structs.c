
#include "libs/structs.h"
#include "libs32/utils32.h"

#include "libs32/klib.h"


/*
typedef struct s_queue_contr
{
  U32 get;
  U32 put;
  U32 size;
  U32 capacity;
  U32 fieldlen;
  U8 *p_base;
} queue_contr_t;
*/


/*
 * 	@param p address of queue controller
 * 	@param size queue size
 *  @param fieldlen size of single entry in bytes
 *  @param pbase address of queue buffer space
 */
uint32_t reset_queue(queue_contr_t *p, uint32_t size, uint32_t fieldlen, void* pbase )
{
  p->get = 0;
  p->put = 0;
  p->size = size;
  p->capacity_left = size;
  p->fieldlen = fieldlen;
  p->p_base = pbase;

}

uint32_t is_full_queue(queue_contr_t *p)
{
  return p->capacity_left == 0;
}

uint32_t is_empty_queue(queue_contr_t *p)
{
	return (p->get == p->put) && !is_full_queue(p);
}

uint32_t put_queue(queue_contr_t *p, void* elem)
{
	if (is_full_queue(p))
	{
		return QUEUE_FULL;
	}

  uint8_t* q = p->p_base;
  q += (p->fieldlen * (p->put));
  uint8_t* q_elem = elem;

  memcpy(q, q_elem, p->fieldlen);

  uint32_t p_new = mod_add(p->put, 1, p->size);

  p->capacity_left -= 1;

  p->put = p_new;


  return QUEUE_OK;

}

uint32_t get_queue(queue_contr_t *p, void* elem)
{
  if (is_empty_queue(p))
  {
    return QUEUE_EMPTY;
  }

  uint8_t* q = p->p_base;
  q += (p->fieldlen * p->get);
  uint8_t* q_elem = elem;

  memcpy(q_elem, q, p->fieldlen);

  p->capacity_left += 1;

  uint32_t p_new = mod_add(p->get, 1, p->size);
	p->get = p_new;

  return QUEUE_OK;
}
