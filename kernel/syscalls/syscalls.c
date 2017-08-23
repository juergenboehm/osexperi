

#include "drivers/hardware.h"

#include "fs/fcntl.h"
#include "fs/vfsext2.h"
#include "fs/ext2.h"
#include "fs/vfs.h"

#include "mem/malloc.h"

#include "kernel32/objects.h"
#include "kernel32/irq.h"
#include "kernel32/process.h"
#include "libs32/klib.h"

#include "syscalls/syscalls.h"

#define GET_REG_32(ptr,offset) ((uint32_t*) (((uint8_t*) ptr) + offset))

typedef struct syscall_info_s {
	void* sys_fun;
	int no_parms;
} syscall_info_t;

syscall_info_t syscall_list[] =
{
		{.sys_fun = sys_open, .no_parms = 2 },
		{.sys_fun = sys_open_3, .no_parms = 3},
		{.sys_fun = sys_creat, .no_parms = 2 },

		{.sys_fun = sys_unlink, .no_parms = 1},
		{.sys_fun = sys_mkdir, .no_parms = 2},
		{.sys_fun = sys_rmdir, .no_parms = 1},
		{.sys_fun = sys_rename, .no_parms = 2},

		{.sys_fun = sys_lseek, .no_parms = 3},
		{.sys_fun = sys_read, .no_parms = 3 },
		{.sys_fun = sys_write, .no_parms = 3 },

		{.sys_fun = sys_register_handler, .no_parms = 1},
		{.sys_fun = sys_fork, .no_parms = 1 },

		{.sys_fun = sys_close, .no_parms = 1}

};

typedef int (*sys_fun_1_t)(uint32_t );
typedef int (*sys_fun_2_t)(uint32_t, uint32_t );
typedef int (*sys_fun_3_t)(uint32_t, uint32_t, uint32_t );
typedef int (*sys_fun_4_t)(uint32_t, uint32_t, uint32_t, uint32_t );
typedef int (*sys_fun_5_t)(uint32_t, uint32_t, uint32_t, uint32_t, uint32_t );



void syscall_handler(uint32_t errcode, uint32_t irq_num, void* esp)
{
	//outb_0xe9( 'S');

	volatile uint32_t eax = *GET_REG_32(esp, IRQ_REG_OFFSET_AX);
	volatile uint32_t ebx = *GET_REG_32(esp, IRQ_REG_OFFSET_BX);
	volatile uint32_t ecx = *GET_REG_32(esp, IRQ_REG_OFFSET_CX);
	volatile uint32_t edx = *GET_REG_32(esp, IRQ_REG_OFFSET_DX);
	volatile uint32_t esi = *GET_REG_32(esp, IRQ_REG_OFFSET_SI);
	volatile uint32_t edi = *GET_REG_32(esp, IRQ_REG_OFFSET_DI);

	volatile uint32_t retval = 0;

	//outb_printf("syscall handler:\n eax = %08x\n ebx = %08x\n ecx = %08x\n edx = %08x\n esi = %08x\n\n",
	//		eax, ebx, ecx, edx, esi);


	void* sys_fun = syscall_list[eax].sys_fun;
	int no_parms = syscall_list[eax].no_parms;

	switch (no_parms)
	{
		case 1: retval = (*((sys_fun_1_t)(sys_fun)))(ebx);
						break;
		case 2: retval = (*((sys_fun_2_t)(sys_fun)))(ebx, ecx);
						break;
		case 3: retval = (*((sys_fun_3_t)(sys_fun)))(ebx, ecx, edx);
						break;
		case 4: retval = (*((sys_fun_4_t)(sys_fun)))(ebx, ecx, edx, esi);
						break;
		case 5: retval = (*((sys_fun_5_t)(sys_fun)))(ebx, ecx, edx, esi, edi);
						break;
		default:
						retval = -1;
						break;
	}

	 *(GET_REG_32(esp, IRQ_REG_OFFSET_AX)) = retval;

	 process_signals((uint32_t)esp);

}



int sys_open(char *pathname, int flags)
{
	int retval = -1;
	retval = sys_open_3(pathname, flags, 0);
	return retval;
}

int sys_open_3(char *pathname, int flags, mode_t mode)
{

	int retval = -1;
	char* last_fname = malloc(FILE_NAMELEN);

	outb_printf("enter: sys_open\n");

	int i;
	int fd_new = -1;
	for(i = 0; i < NUM_BASE_FD_PROC; ++i)
	{
		if (!current->proc_data.io_block->base_fd_arr[i])
		{
			fd_new = i;
			break;
		}
	}
	if (fd_new < 0)
	{
		retval = -1;
		goto ende;
	}

	dentry_t* current_root_dentry = current->proc_data.io_block->root_dentry;
	dentry_t* current_pwd_dentry = current->proc_data.io_block->pwd_dentry;

	dentry_t* found_dentry = 0;

	outb_printf("sys_open:pathname = >%s< flags = %d\n",
			pathname, flags);

	if (flags & (O_WRONLY | O_RDWR))
	{
		int ret = get_parse_path(current_root_dentry, 0x01, pathname, &found_dentry, last_fname);

		if (ret < 0)
		{
			retval = -1;
			goto ende;
		}
		dentry_t aux_dentry;

		aux_dentry.d_name = last_fname;

		inode_t *aux_inode = found_dentry->d_inode;

		dentry_t* final_found_dentry = gen_lookup(aux_inode, &aux_dentry);

		if (final_found_dentry)
		{
			if ((flags & O_CREAT) && (flags & O_EXCL))
			{
				retval = -1;
				goto ende;
			}
			if (flags & O_TRUNC)
			{
				//TODO: implement trunc
			}
			found_dentry = final_found_dentry;
		}
		else
		{
			if (flags & O_CREAT)
			{

				retval = aux_inode->i_ops->create(aux_inode, &aux_dentry, mode);

				if (retval < 0)
				{
					retval = -1;
					goto ende;
				}

				found_dentry = gen_lookup(aux_inode, &aux_dentry);

				if (!found_dentry)
				{
					retval = -1;
					goto ende;
				}
			}
		}

	}
	else if ((flags & O_ACCMODE) == O_RDONLY)
	{
		int ret = get_parse_path(current_root_dentry, 0, pathname, &found_dentry, last_fname);
		if (ret < 0)
		{
			retval = -1;
			goto ende;
		}

		if (!found_dentry)
		{
			retval = -1;
			goto ende;
		}
	}

	file_ext2_t* new_file_ext2 = ((file_ext2_t*)found_dentry->d_inode->i_concrete_inode);

	outb_printf("inode found = %d\n", new_file_ext2->inode_index);

	file_t* new_file = get_file_t();

	new_file->f_pos = 0;

	link_dentry_t(&new_file->f_dentry, found_dentry);

	new_file->f_fops = found_dentry->d_inode->i_fops;
	new_file->f_flags = flags;

	link_file_t(&current->proc_data.io_block->base_fd_arr[fd_new], new_file);
	retval = fd_new;

	ende:

	free(last_fname);
	return retval;
}

int sys_creat(char *pathname, mode_t mode)
{
	return -1;
}

int sys_unlink(char *pathname)
{
	return -1;
}

int sys_mkdir(char *pathname, mode_t mode)
{
	return -1;
}

int sys_rmdir(char *pathname)
{
	return -1;
}

int sys_rename(char *oldpath, const char *newpath)
{
	return -1;
}

int sys_lseek(int fd, off_t offset, int whence)
{
	return -1;
}


int sys_read(int fd, void *buf, size_t count)
{
	int ret;
	file_t* p_file = current->proc_data.io_block->base_fd_arr[fd];

	if (p_file)
	{
		if (p_file->f_fops->read) {
			ret =  p_file->f_fops->read(p_file, buf, count, 0);
		}
		else
		{
			ret = -1;
		}
	}
	else
	{
		ret = -1;
	}
	return ret;
}

int sys_write(int fd, void *buf, size_t count)
{
	int ret;

	file_t* p_file = current->proc_data.io_block->base_fd_arr[fd];

	if (p_file)
	{
		if (p_file->f_fops->write)
		{
			ret = p_file->f_fops->write(p_file, buf, count, 0);
		}
		else
		{
			ret = -1;
		}
	}
	else
	{
		ret = -1;
	}

	return ret;
}


int sys_register_handler(uint32_t handler_address)
{
	current->proc_data.handler = handler_address;
	outb_printf("sys_register_handler: registered = %08x\n", handler_address);
	return 0;
}

int sys_fork(uint32_t arg)
{
	int ret;
	ret = fork_process();
	return ret;
}


int sys_close(int fd)
{
	return -1;
}
