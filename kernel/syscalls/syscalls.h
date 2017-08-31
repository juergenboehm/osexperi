#ifndef __syscalls_syscalls_h
#define __syscalls_syscalls_h

#include "kerneltypes.h"
#include "libs/kerneldefs.h"
#include "fs/vfs.h"

void syscall_handler(uint32_t errcode, uint32_t irq_num, void* esp);


#define SC_SYS_OPEN_NO 				0
#define SC_SYS_OPEN_3_NO			1
#define SC_SYS_CREAT_NO				2

#define SC_SYS_UNLINK_NO			3
#define SC_SYS_MKDIR_NO				4
#define SC_SYS_RMDIR_NO				5
#define SC_SYS_RENAME_NO			6

#define SC_SYS_LSEEK_NO				7
#define SC_SYS_READ_NO				8
#define SC_SYS_WRITE_NO				9

#define SC_SYS_REGISTER_HANDLER_NO	10
#define SC_SYS_FORK_NO							11

#define SC_SYS_CLOSE_NO			12

#define SC_SYS_CHDIR_NO			13
#define SC_SYS_READDIR_NO		14





int sys_open(char *pathname, int flags);

int sys_open_3(char *pathname, int flags, mode_t mode);

int sys_creat(char *pathname, mode_t mode);

int sys_unlink(char *pathname);

int sys_mkdir(char *pathname, mode_t mode);

int sys_rmdir(char *pathname);

int sys_rename(char *oldpath, const char *newpath);

int sys_lseek(int fd, off_t offset, int whence);

int sys_read(int fd, void *buf, size_t count);

int sys_write(int fd, void *buf, size_t count);

int sys_register_handler(uint32_t handler_address);

int sys_fork(uint32_t arg);

int sys_close(int fd);

int sys_chdir(char* pathname);

int sys_readdir(int fd, dirent_t* dirent);



#endif
