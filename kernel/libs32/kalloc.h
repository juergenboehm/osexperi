#ifndef __libs32_kalloc_h
#define __libs32_kalloc_h

#include "kerneltypes.h"

extern uint32_t _len16;
extern uint32_t _len32;
extern uint32_t _usercode_phys;

int init_kalloc_fixed();

void *kalloc_fixed_aligned(size_t size, size_t align_val);

void* kalloc_peek_align();

#define KALLOC_FIXED_TYPE(type,num,align_mult) ((type*) (kalloc_fixed_aligned((num)*sizeof(type), \
																												(align_mult)*sizeof(type))))


#endif
