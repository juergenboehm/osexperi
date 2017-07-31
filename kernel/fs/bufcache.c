
#include "kerneltypes.h"

#include "libs/kerneldefs.h"
#include "libs/utils.h"
#include "libs32/klib.h"

#include "kernel32/mutex.h"

//#include "drivers/hardware.h"
//#include "drivers/pic.h"
#//include "drivers/pci.h"
#include "drivers/ide.h"

#include "fs/bufcache.h"



buf_list_bin_t* global_ide_buf_list;

list_head_t* global_ide_buf_free_list;

list_head_t* global_ide_buf_lru_list;


// mode: R/W = 0/1
int find_buf_ide(list_head_t* buf_lis, file_t* fil_sought, uint32_t sector_sought, uint32_t mode, char** pbuf)
{

	int found = 0;

	INIT_LISTVAR(p);

	FORLIST(p, buf_lis)
	{
		buf_node_t *pbuf_nod = container_of(p, buf_node_t, link);

		if (pbuf_nod->sec_num == sector_sought && pbuf_nod->fil == fil_sought)
		{

			// move element to beginning of local list
			delete_elem(&buf_lis, &(pbuf_nod->link));
			prepend_list(&buf_lis, &(pbuf_nod->link));

			// move element to beginning of lru list
			delete_elem(&global_ide_buf_lru_list, &(pbuf_nod->lru_link));
			prepend_list(&global_ide_buf_lru_list, &(pbuf_nod->lru_link));

			if (mode == 1)
			{
				pbuf_nod->dirty = 1;
			}


			*pbuf = pbuf_nod->bufp;
			found = 1;
			break;
		}

		p = p->next;

	}
	END_FORLIST(p, buf_lis);

	return found;
}

buf_node_t* get_free_buf_node_t()
{
	list_head_t* p = global_ide_buf_free_list;

	if (!p)
	{

		//outb_printf("get_free_buf_node_t: enter\n");

		// remove last element of lru_list
		// which is the least recently used one.
		list_head_t* q = global_ide_buf_lru_list;

		ASSERT(q != 0);

		// q->prev is the last element
		list_head_t* plast = q->prev;

		buf_node_t* pbuf_node = container_of(plast, buf_node_t, lru_link);

		if (pbuf_node->dirty)
		{
			writeblk_ide(pbuf_node->fil, pbuf_node->sec_num, pbuf_node->bufp);
			pbuf_node->dirty = 0;
		}
		delete_elem(&q, &(pbuf_node->lru_link));

		// remove pbuf_node from its local bin list
		list_head_t* r = pbuf_node->bin_head_ptr->use_list_head;
		delete_elem(&r, &(pbuf_node->link));
		--pbuf_node->bin_head_ptr->length;

		char* pbuf = pbuf_node->bufp;
		memset(pbuf, 0, IDE_BLKSIZE);
		pbuf_node->dirty = 0;
		pbuf_node->fil = 0;
		pbuf_node->sec_num = 0;

		prepend_list(&global_ide_buf_free_list, &(pbuf_node->link));

		p = global_ide_buf_free_list;

		ASSERT(p);
	}
	//outb_printf("get_free_buf_node_t: exit\n");

	ASSERT(p);

	buf_node_t* pnd = container_of(p, buf_node_t, link);
	delete_elem(&global_ide_buf_free_list, &(pnd->link));
	return pnd;
}



#define WITH_CACHE 1


int readblk_ide_cached(file_t* fil, uint32_t blk_index, char** buf)
{

	int retval = -1;

	char* pbuf = 0;

	int hash_bin = blk_index % NUM_HASH_IDE_BUF_LIST;

	//outb_printf("readblk_ide_cached: taking mutex ide_buf_mutex ..\n");

	mtx_lock(&ide_buf_mutex);

	int found = find_buf_ide(global_ide_buf_list[hash_bin].use_list_head, fil, blk_index, 0, &pbuf);
	if (found)
	{
		memcpy(*buf, pbuf, IDE_BLKSIZE);
		retval = IDE_BLKSIZE;
		goto ende;
	}

	retval = readblk_ide(fil, blk_index, buf);

	if (retval < 0)
	{
		goto ende;
	}

	buf_node_t* pbuf_node = get_free_buf_node_t();
	memcpy(pbuf_node->bufp, *buf, IDE_BLKSIZE);

	pbuf_node->dirty = 0;
	pbuf_node->fil = fil;
	pbuf_node->sec_num = blk_index;

	pbuf_node->bin_head_ptr = &global_ide_buf_list[hash_bin];

	prepend_list(&global_ide_buf_list[hash_bin].use_list_head, &(pbuf_node->link));
	++global_ide_buf_list[hash_bin].length;

	prepend_list(&global_ide_buf_lru_list, &(pbuf_node->lru_link));

	ende:

	//outb_printf("readblk_ide_cached: releasing mutex ide_buf_mutex ..\n");

	mtx_unlock(&ide_buf_mutex);
	return retval;
}

int writeblk_ide_cached(file_t* fil, uint32_t blk_index, char* buf)
{
	char* pbuf = 0;

	int hash_bin = blk_index % NUM_HASH_IDE_BUF_LIST;

	//outb_printf("writeblk_ide_cached: taking mutex ide_buf_mutex ..\n");

	mtx_lock(&ide_buf_mutex);

	int found = find_buf_ide(global_ide_buf_list[hash_bin].use_list_head, fil, blk_index, 1, &pbuf);

	if (found)
	{
		memcpy(pbuf, buf, IDE_BLKSIZE);
	}
	else
	{

		buf_node_t* pbuf_node = get_free_buf_node_t();

		memcpy(pbuf_node->bufp, buf, IDE_BLKSIZE);

		pbuf_node->dirty = 1;
		pbuf_node->fil = fil;
		pbuf_node->sec_num = blk_index;

		pbuf_node->bin_head_ptr = &global_ide_buf_list[hash_bin];

		prepend_list(&global_ide_buf_list[hash_bin].use_list_head, &(pbuf_node->link));
		++global_ide_buf_list[hash_bin].length;

		prepend_list(&global_ide_buf_lru_list, &(pbuf_node->lru_link));

	}

	//outb_printf("writeblk_ide_cached: releasing mutex ide_buf_mutex ..\n");
	mtx_unlock(&ide_buf_mutex);

	return IDE_BLKSIZE;

}


int init_bufcache()
{
	int i;

	global_ide_buf_list = (buf_list_bin_t*) malloc(NUM_HASH_IDE_BUF_LIST * sizeof(buf_list_bin_t));


	for(i = 0; i < NUM_HASH_IDE_BUF_LIST; ++i)
	{
		global_ide_buf_list[i].length = 0;
		global_ide_buf_list[i].use_list_head = 0;
	}


	global_ide_buf_lru_list = 0;
	global_ide_buf_free_list = 0;


	for(i = 0; i < MAX_NUM_BUFS; ++i)
	{
		buf_node_t* pbuf_node = (buf_node_t*) malloc(sizeof(buf_node_t));
		char* pbuf = (char*)malloc(IDE_BLKSIZE);
		memset(pbuf, 0, IDE_BLKSIZE);
		pbuf_node->bufp = pbuf;
		pbuf_node->dirty = 0;
		pbuf_node->fil = 0;
		pbuf_node->sec_num = 0;

		prepend_list(&global_ide_buf_free_list, &(pbuf_node->link));
	}

	return 0;

}


