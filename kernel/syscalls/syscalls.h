#ifndef __syscalls_syscalls_h
#define __syscalls_syscalls_h

#include "kerneltypes.h"
#include "libs/kerneldefs.h"

void syscall_handler(uint32_t errcode, uint32_t irq_num, void* esp);

#define SC_SYS_OPEN_NO 				0
#define SC_SYS_READ_NO 				1
#define SC_SYS_WRITE_NO 			2


int sys_open(char* fname, uint32_t fmode);
int sys_read(uint32_t fd, char* buf, size_t count);
int sys_write(uint32_t fd, char* buf, size_t count);






#endif
