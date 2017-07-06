
#include "fs/vfs.h"
#include "kernel32/process.h"
#include "kernel32/objects.h"

inode_t* get_inode_t()
{

}

dentry_t* get_dentry_t()
{
	return 0;
}

file_t* get_file_t()
{
	return 0;
}

tss_t* get_tss_t()
{
	tss_t* p_new_tss = (tss_t*) malloc(PAGE_SIZE);
	memset(p_new_tss, 0, sizeof(tss_t));
	return p_new_tss;
}


process_t* get_process_t()
{
	process_t* p_new_process = (process_t*)malloc(sizeof(process_t));
	return p_new_process;
}

proc_io_block_t*  get_proc_io_block_t()
{
	proc_io_block_t* p_new_proc_io_block = (proc_io_block_t*) malloc(sizeof(proc_io_block_t));

	memset(p_new_proc_io_block, 0, sizeof(proc_io_block_t));

	return p_new_proc_io_block;
}

process_node_t* get_process_node_t()
{
	process_node_t* p_new_node = (process_node_t*) malloc(sizeof(process_node_t));
	memset(p_new_node, 0, sizeof(process_node_t));
	return p_new_node;
}

