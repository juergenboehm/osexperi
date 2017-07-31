#ifndef __fs_bufcache_h
#define __fs_bufcache_h

#include "kerneltypes.h"
#include "libs/utils.h"
#include "libs/lists.h"


typedef struct buf_list_bin_s buf_list_bin_t;


typedef struct buf_node_s {

	uint32_t sec_num;
	uint32_t dirty;
	file_t* fil;
	char*	bufp;
	buf_list_bin_t* bin_head_ptr;
	list_head_t link;
	list_head_t lru_link;


} buf_node_t;

typedef struct buf_list_bin_s {

	list_head_t* use_list_head;
	uint32_t length;

} buf_list_bin_t;

#define NUM_HASH_IDE_BUF_LIST	541

#define MAX_NUM_BUFS	4096

extern buf_list_bin_t* global_ide_buf_list;
extern list_head_t* global_ide_buf_free_list;
extern list_head_t* global_ide_buf_lru_list;


int readblk_ide_cached(file_t* fil, uint32_t blk_index, char **buf);
int writeblk_ide_cached(file_t* fil, uint32_t blk_index, char *buf);







#endif
