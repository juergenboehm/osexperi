

#include "kerneltypes.h"
#include "drivers/hardware.h"

#include "kernel32/objects.h"

#include "mem/malloc.h"

#include "libs32/klib.h"

#include "kernel32/mutex.h"


mutex_t init_mutex_table[NUM_INIT_MUTEXES];
semaphore_t init_sema_table[NUM_INIT_SEMAPHORES];

semaphore_t ide_irq_sema;
mutex_t ide_op_mutex;

mutex_t key_wait_mutex[NUM_SCREENS];
semaphore_t key_read_sema[NUM_SCREENS];



int mtx_init(mutex_t *mtx, uint32_t type, char* desc)
{
	mtx->val = 1;
	wq_t *new_wq = get_wq_t();
	if (new_wq)
	{
		mtx->wq = new_wq;
		wq_init(mtx->wq);
		return 0;
	}
	else
	{
		return -1;
	}
}

int mtx_destroy(mutex_t *mtx)
{
	wq_free(mtx->wq);
	return 0;
}

int mtx_lock(mutex_t *mtx)
{
	IRQ_CLI_SAVE(eflags);

start:

	if (mtx->val == 1)
	{
		mtx->val = 0;
		goto ende;
	}
	else
	{
			wq_wait(mtx->wq);
			goto start;
	}

ende:
	IRQ_RESTORE(eflags);

	return 0;
}

int mtx_unlock(mutex_t *mtx)
{
	mtx->val = 1;
	wq_wakeup(mtx->wq);
	return 0;
}


int sema_init(semaphore_t *sema, uint32_t start_val, uint32_t type, char* desc)
{
	sema->val = start_val;
	wq_t *new_wq = get_wq_t();
	if (new_wq)
	{
		sema->wq = new_wq;
		wq_init(sema->wq);
		return 0;
	}
	else
	{
		return -1;
	}
}

int sema_destroy(semaphore_t *sema)
{
	wq_free(sema->wq);
	return 0;
}

uint32_t sema_down(semaphore_t *sema)
{
	uint32_t retval = 0;
	IRQ_CLI_SAVE(eflags);

	start:

	if (sema->val > 0){
		retval = --sema->val;
		goto ende;
	}
	else
	{
		wq_wait(sema->wq);
		goto start;
	}

ende:
	IRQ_RESTORE(eflags);
	return retval;
}

uint32_t sema_up(semaphore_t *sema)
{
	IRQ_CLI_SAVE(eflags);

	uint32_t retval = ++sema->val;
	wq_wakeup(sema->wq);

	IRQ_RESTORE(eflags);

	return retval;
}

int sema_set(semaphore_t *sema, uint32_t new_val)
{
	IRQ_CLI_SAVE(eflags);
	sema->val = new_val;
	IRQ_RESTORE(eflags);
	return 0;
}

uint32_t sema_get(semaphore_t *sema)
{
	uint32_t retval = 0;
	IRQ_CLI_SAVE(eflags);
	retval = sema->val;
	IRQ_RESTORE(eflags);
	return retval;
}


int wq_init(wq_t* wq)
{
	wq->head = 0;
	return 0;
}


int wq_free(wq_t* wq)
{
	if (wq && wq->head)
	{
		// release pending processes
		while (wq->head)
		{
			wq_wakeup(wq);
		}
	}
	free_wq_t(wq);
	return 0;
}

int wq_wait(wq_t* wq)
{
	IRQ_CLI_SAVE(eflags);

	process_node_t* pnd = get_process_node_t();
	pnd->proc = current;

	current->proc_data.status = PROC_STOPPED;

	append_list(&(wq->head), &(pnd->link));

	current->proc_data.in_wq = wq;

	IRQ_RESTORE(eflags);

	schedule();

	return 0;

}

int wq_wakeup(wq_t* wq)
{

	IRQ_CLI_SAVE(eflags);

	if (wq && wq->head)
	{
		process_node_t* pnd = container_of(wq->head, process_node_t, link);
		process_t *proc = pnd->proc;
		proc->proc_data.status = PROC_READY;
		proc->proc_data.in_wq = 0;
		delete_elem(&(wq->head), &(pnd->link));
		free_process_node_t(pnd);
	}
	IRQ_RESTORE(eflags);

	return 0;
}


void remove_from_wait_queues(process_t *proc)
{

}

void release_sync_primitives(process_t *proc)
{

}


void init_sync_system()
{
	int i = 0;
	for(i = 0; i < NUM_INIT_MUTEXES; ++i)
	{
		mtx_init(&init_mutex_table[i], 0, 0);
	}

	for(i = 0; i < NUM_SCREENS; ++i)
	{
		mtx_init(&key_wait_mutex[i], 0, 0);
		sema_init(&key_read_sema[i], 0 ,0, 0);
	}

	for(i = 0; i < NUM_INIT_SEMAPHORES; ++i)
	{
		sema_init(&init_sema_table[i], 1, 0, 0);
	}

//	sema_init(&ide_sema, 1, 0, 0);
// 	mtx_init(&ide_op_mutex, 0, 0);
}





