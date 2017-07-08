
#include "libs16/print16.h"
#include "libs16/bioslib.h"
#include "libs/gdt.h"
#include "libs/utils.h"

#include "loader.h"


typedef uint8_t* P_U8;
typedef uint32_t* P_U32;


#define	DISKBUF_ADDR	0x9000

#define MAX_KERNEL16_LEN	32768

uint8_t* diskbuf_global;
__ALIGNED(8) DAPA dapa_global;

__ALIGNED(8) move_mem_block mm_block;


int lmain()
{

	diskbuf_global = (uint8_t*)(DISKBUF_ADDR);

	print_newline();
	print_str("*** PROTOS starting ***\r\n");

	print_newline();
	print_U32(sizeof(uint8_t));

	print_newline();
	print_U32(sizeof(uint16_t));

	print_newline();
	print_U32(sizeof(uint32_t));

	print_str("\r\nPointer Size = ");
	print_U32(sizeof(P_U8));
	print_newline();

	print_str("Pointer Size = ");
	print_U32(sizeof(P_U32));
	print_newline();

	DBGOUT("int Size = ", sizeof(int));

	uint8_t dummy = 64;
	P_U8 dummy_ptr = &dummy;
	uint32_t dummy_p_long = (uint32_t)(dummy_ptr);

	DBGOUT("Pointer Content = ", dummy_p_long);

	print_newline();
	print_U32(0x11223344);

	print_newline();
	print_U32(0xaabbccdd);

	test_disk();

	print_str("\r\nDisk trial access done.\r\n");

	int num_loader_sec = NUM_LOADER_SEC;
	int num_mbr_sec = 1;

	int offset_kernel_sec = num_loader_sec + num_mbr_sec;

	int num_kernel_secs = KERNEL_LEN / 512;


	DBGOUT("Kernel len = ", KERNEL_LEN);


	int mov_sek_num = 1;

	int to_do_num = num_kernel_secs;
	int start_sec = offset_kernel_sec;

	uint16_t dest16 = 0x0000;

	// when the kernel gets longer than about 64k, dest16 overflows
	// therefore it is limited here to MAX_KERNEL16_LEN
	uint16_t max_dest16 = MAX_KERNEL16_LEN;

	uint32_t dest32 = 0x100000;

	DBGOUT("dest32 = ", dest32);

	while( to_do_num > 0)
	{

		int tf_num = min( to_do_num, mov_sek_num);
		DBGOUT("to do = ", to_do_num);

		//loadsec_fd( start_sec, tf_num, diskbuf_global, &dapa_global, LOADER_SEG);
		loadsec( start_sec, tf_num, diskbuf_global, &dapa_global, LOADER_SEG);

    DBGOUT("loadsec done: dest32 = ", dest32);

		int to_move = min(dest16 + tf_num * 512, 0x10000) - dest16;

		if (dest16 < max_dest16 && to_move > 0)
		{
			volatile int ret = copy_segseg( LOADER_SEG, (uint16_t)(((uint32_t)diskbuf_global) & 0xffff), to_move, KERNEL16_SEG, dest16 );
			dest16 += to_move;

		} else
		{
			dest16 = max_dest16;
		}

		DBGOUT("copy segseg done: to_move = ", to_move);

		uint32_t src = (LOADER_SEG << 4) + (((uint32_t)diskbuf_global) & (uint32_t)(uint16_t)0xffff);

    DBGOUT("src = ", src);
    DBGOUT("dest = ", dest32);

		int ok = copy_ext(&mm_block,
							src,
	 						dest32,
							tf_num * 512 / 2, LOADER_SEG );

		dest32 += (uint32_t)(tf_num * 512);

		DBGOUT("ok = ", ok);

		start_sec += tf_num;

		to_do_num -= tf_num;


	}

	DBGOUT("Kernel len = ", KERNEL_LEN);

	print_str("Load 4 done.\r\n");

	//while(1) {};

/*
	copy_segseg( 0x9000, 0x0800, 1024, LOADER_SEG, (U16)((((U32)diskbuf_global) & 0xffff) + 2048));

	print_str("Copy seg done.\r\n");

	diskbuf_global[2048] = 'Q';
	diskbuf_global[2049] = 'X';

	writesec(32, 2, diskbuf_global + 2048, &dapa_global, LOADER_SEG );
*/


	print_str("Kernel image moved.\r\n");

	return 'E';

}



int test_disk()
{

	loadsec( 0, 2, diskbuf_global, &dapa_global, LOADER_SEG);

	print_newline();

	int i;
	char *str = "Juergen Boehm 23232323232323";
	char *p = str;


	for(i = 0; *p; ++i)
	{
		diskbuf_global[i] = (uint8_t)(*(p++));
	}
	diskbuf_global[i] = (uint8_t)*p;

	print_str((char*)(diskbuf_global));

	//writesec(64, 2, diskbuf_global, &dapa_global, LOADER_SEG);
	return 0;

}
