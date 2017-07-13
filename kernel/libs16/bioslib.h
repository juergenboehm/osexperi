#ifndef __bioslib_h
#define __bioslib_h

#include "libs16/code16.h"

#include "kerneltypes.h"
#include "libs/gdt.h"

__NOINLINE __volatile__ int copy_segseg(uint16_t old_seg, uint16_t old_offs, int len, uint16_t new_seg, uint16_t new_offs);


__NOINLINE void print_char(uint8_t ch);

// transfer to extended memory

// data block to specify transfer start and dest

typedef struct __PACKED __ALIGNED(8) s_move_mem_block {

	long long dummy;
	long long tab_start_addr;

	descriptor_t gdte_source;
	descriptor_t gdte_dest;

	long long cs_bios;
	long long ss_bios;

} move_mem_block;

__NOINLINE int copy_ext(move_mem_block* pmmb, uint32_t start, uint32_t goal, uint16_t len, uint16_t user_seg);



// disk access routines

// disk access packet

typedef struct __PACKED s_DAPA{

	uint8_t packet_size; // size of s_DAPA itself. must therefore be 16.
	uint8_t always_zero;
	uint16_t numsec;
	uint16_t	offset_buf;
	uint16_t segment_buf;
	uint32_t start_lba;
	uint32_t start_lba_upper;

 } DAPA;

#define	DISKBUF_SIZE	(16 * 512)

int init_DAPA(uint32_t lba, uint16_t numsec, uint8_t* bufp, DAPA* dapa, uint16_t loader_ds);

int loadsec( uint32_t lba, uint16_t numsec, uint8_t* bufp, DAPA* dapa, uint16_t loader_ds);

int writesec(	uint32_t lba, uint16_t numsec, uint8_t* bufp, DAPA* dapa, uint16_t loader_ds );



// BIOS getMemory map


#define BIOS_MMAP_ENTRY_LEN	24


int __NOINLINE __volatile__ get_mem_map_step(uint16_t buf_seg, uint8_t* bufp, bool* ende, uint8_t** newbufp, uint32_t* ebx);

int __NOINLINE __volatile__ get_mem_map(uint16_t buf_seg, uint8_t* bufp, size_t* len_map);


#if 1
#define PUSH_THE_REGS   \
		"pushl %%ebp \n\t" \
		"pushal \n\t" \
		"pushw %%ds \n\t pushw %%es \n\t pushw %%fs \n\t pushw %%gs \n\t"

#define POP_THE_REGS  \
		"popw %%gs \n\t popw %%fs \n\t popw %%es \n\t popw %%ds \n\t" \
		"popal \n\t" \
		"popl %%ebp \n\t"
#endif

#if 0
#define PUSH_THE_REGS " "
#define POP_THE_REGS " "
#endif



#endif
