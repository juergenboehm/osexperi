
#include "fs/vfs.h"
#include "libs/lists.h"
#include "kernel32/process.h"
#include "kernel32/objects.h"

list_head_t* global_proc_node_list;

static int len_global_proc_node_list = 0;

inode_t* get_inode_t()
{

}

dentry_t* get_dentry_t()
{
	return 0;
}

file_t* get_file_t()
{
	file_t *p_new_file = (file_t*) malloc(sizeof(file_t));
	memset(p_new_file, 0, sizeof(file_t));

	return p_new_file;
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
	if (global_proc_node_list)
	{
		process_node_t* p_new_node = container_of(global_proc_node_list, process_node_t, link);
		// delete first element
		delete_elem(&global_proc_node_list, global_proc_node_list);
		--len_global_proc_node_list;
		//outb_printf("get_process_node_t: len free list = %d\n", len_global_proc_node_list);
		return p_new_node;
	}
	else
	{
		process_node_t* p_new_node = (process_node_t*) malloc(sizeof(process_node_t));
		memset(p_new_node, 0, sizeof(process_node_t));
		return p_new_node;
	}
}

wq_t* get_wq_t()
{
	wq_t* p_new_wq_t = (wq_t*) malloc(sizeof(wq_t));
	memset(p_new_wq_t, 0, sizeof(wq_t));
	return p_new_wq_t;
}



void free_process_node_t(process_node_t* pnd)
{
	prepend_list(&global_proc_node_list, &(pnd->link));
	++len_global_proc_node_list;
	//outb_printf("free_process_node_t: len free list = %d\n", len_global_proc_node_list);
}

void free_process_t(process_t* proc)
{
	free(proc);
}

void free_proc_io_block_t(proc_io_block_t* pio_blk)
{
	free(pio_blk);
}

void free_wq_t(wq_t* p_wqt)
{
	free(p_wqt);
}

void init_objects()
{
	global_proc_node_list = 0;
}








