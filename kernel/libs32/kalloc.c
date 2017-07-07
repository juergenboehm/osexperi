
#include "libs/kerneldefs.h"
#include "libs32/klib.h"
#include "libs32/utils32.h"
#include "mem/paging.h"

#include "libs32/kalloc.h"

static uint8_t* pt_kalloc_fixed;

// just to remember where we started (unused by now)
static uint8_t* pt_kalloc_fixed_base;


uint32_t _len16;
uint32_t _len32;


void fill_start_params()
{
	uint32_t* pt = (uint32_t*)((KERNEL16_SEG << 4) + 4);

	_len16 = *pt++;
	_len32 = *pt++;
	_usercode_phys = *pt;
}


int init_kalloc_fixed()
{

	outb_printf("starting init_kalloc_fixed.\n");

	fill_start_params();

	pt_kalloc_fixed = (uint8_t*) align(_len32 + KERNEL_32_START_UPPER, PAGE_SIZE);
	pt_kalloc_fixed_base = pt_kalloc_fixed;


	//DEBUGOUT(1, "init_kalloc_fixed: pt_kalloc_fixed = %08x\n", (uint32_t) pt_kalloc_fixed);

	return 0;

}

void *kalloc_fixed_aligned(size_t size, size_t align_val){

	uint8_t* ret_ptr = pt_kalloc_fixed;

	size_t offset = 0;

	if (align_val)
	{
		offset = (uint32_t)ret_ptr;
		offset = align(offset, align_val) - offset;
	}

	pt_kalloc_fixed = ret_ptr + offset;

	ret_ptr += offset;

	pt_kalloc_fixed += size;
/*
	DEBUGOUT(3, "size = %d, align_val = %d\n", size, align_val );
  DEBUGOUT(3, "kalloc_fixed: new: pt_kalloc_fixed = %08x\n", (uint32_t) pt_kalloc_fixed );
  DEBUGOUT(3, "kalloc_fixed: ret_ptr = %08x\n", (uint32_t) ret_ptr );
  DEBUGOUT(3, "kalloc_fixed: offset = %08x\n", (uint32_t) offset );
*/
	return (void*)ret_ptr;

}

void* kalloc_peek_align()
{
	return pt_kalloc_fixed;
}
