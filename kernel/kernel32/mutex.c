

#include "kerneltypes.h"

#include "mem/malloc.h"

#include "libs32/klib.h"

#include "kernel32/mutex.h"


int mtx_init(mutex_t *mtx, uint32_t type, char* desc)
{
	mtx = malloc(sizeof(mutex_t));
	mtx->val = 1;
	wq_init(mtx->wq);
	return 0;
}

int mtx_destroy(mutex_t *mtx)
{
	free(mtx);
	wq_free(mtx->wq);
	return 0;
}

int mtx_lock(mutex_t *mtx)
{

	return 0;
}

int mtx_unlock(mutex_t *mtx)
{
	return 0;
}

int wq_init(wq_t* wq)
{
	return 0;
}

int wq_free(wq_t* wq)
{
	return 0;
}

int wq_wait(wq_t* wq)
{
	return 0;
}

int wq_wakeup(wq_t* wq)
{
	return 0;
}


void remove_from_wait_queues(process_t *proc)
{

}

void release_sync_primitives(process_t *proc)
{

}







