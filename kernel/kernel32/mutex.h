

#ifndef __kernel32_mutex_h
#define __kernel32_mutex_h

#include "libs/lists.h"
#include "drivers/vga.h"


typedef struct wq
{
	list_head_t *head;
} wq_t;

/*
typedef struct wq_node {
	list_head_t link;
	process_t *proc;
} wq_node_t;
*/

typedef struct mutex_s
{
	uint32_t val;
	wq_t *wq;
} mutex_t;

typedef struct semaphore_s
{
	uint32_t val;
	wq_t *wq;
} semaphore_t;

int mtx_init(mutex_t *mtx, uint32_t type, char* desc);
int mtx_destroy(mutex_t *mtx);

int mtx_lock(mutex_t *mtx);
int mtx_unlock(mutex_t *mtx);


int sema_init(semaphore_t *sema, uint32_t start_val, uint32_t type, char* desc);
int sema_destroy(semaphore_t *sema);

uint32_t sema_down(semaphore_t *sema);
uint32_t sema_up(semaphore_t *sema);





int wq_init(wq_t* wq);
int wq_free(wq_t* wq);

int wq_wait(wq_t* wq);
int wq_wakeup(wq_t* wq);

typedef union process_u process_t;

void remove_from_wait_queues(process_t *proc);
void release_sync_primitives(process_t *proc);

void init_sync_system();


#define NUM_INIT_MUTEXES	8
#define NUM_INIT_SEMAPHORES	8

extern mutex_t init_mutex_table[NUM_INIT_MUTEXES];
extern semaphore_t init_sema_table[NUM_INIT_SEMAPHORES];

extern semaphore_t ide_irq_sema;
extern mutex_t ide_op_mutex;
extern mutex_t ide_buf_mutex;

extern mutex_t key_wait_mutex[NUM_SCREENS];

extern semaphore_t key_read_sema[NUM_SCREENS];

#endif /* __kernel32_mutex_h */
