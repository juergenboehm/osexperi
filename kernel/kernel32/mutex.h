

#ifndef __kernel32_mutex_h
#define __kernel32_mutex_h

#include "libs/lists.h"
#include "kernel32/process.h"


typedef struct wq
{
	list_head_t *head;
} wq_t;

typedef struct wq_node {
	list_head_t link;
	process_t *proc;
} wq_node_t;

typedef struct mutex
{
	uint32_t val;
	wq_t *wq;
} mutex_t;


int mtx_init(mutex_t *mtx, uint32_t type, char* desc);
int mtx_destroy(mutex_t *mtx);

int mtx_lock(mutex_t *mtx);
int mtx_unlock(mutex_t *mtx);

int wq_init(wq_t* wq);
int wq_free(wq_t* wq);

int wq_wait(wq_t* wq);
int wq_wakeup(wq_t* wq);

void remove_from_wait_queues(process_t *proc);
void release_sync_primitives(process_t *proc);




#endif /* __kernel32_mutex_h */
