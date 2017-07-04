
#ifndef __mem_vmem_area_h
#define __mem_vmem_area_h

#include "kerneltypes.h"


typedef struct vm_area {

	struct vm_area *next;
	struct vm_area **prev;

	uint32_t low;
	uint32_t high;
	uint32_t flags;

} vm_area_t;

typedef struct vm_map {

	struct vm_area *head;

} vm_map_t;


int vm_map_init(vm_map_t *avm_map);


#endif /* __mem_vmem_area_h */
