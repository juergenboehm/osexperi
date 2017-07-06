#ifndef __kernel32_objects_h
#define __kernel32_objects_h

#include "kerneltypes.h"
//#include "mem/paging.h"
//#include "mem/vmem_area.h"

#include "fs/vfs.h"
#include "kernel32/process.h"

#include "libs/lists.h"




inode_t* get_inode_t();
dentry_t* get_dentry_t();
file_t* get_file_t();

tss_t* get_tss_t();

process_t* get_process_t();
proc_io_block_t*  get_proc_io_block_t();
process_node_t* get_process_node_t();























#endif
