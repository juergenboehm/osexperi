

#include "drivers/hardware.h"

#include "fs/vfs.h"

#include "kernel32/irq.h"
#include "kernel32/process.h"
#include "libs32/klib.h"

#include "syscalls/syscalls.h"

#define GET_REG_32(ptr,offset) ((uint32_t*) (((uint8_t*) ptr) + offset))


void syscall_handler(uint32_t errcode, uint32_t irq_num, void* esp)
{
	outb(0xe9, 'S');

	uint32_t eax = *GET_REG_32(esp, IRQ_REG_OFFSET_AX);
	uint32_t ebx = *GET_REG_32(esp, IRQ_REG_OFFSET_BX);
	uint32_t ecx = *GET_REG_32(esp, IRQ_REG_OFFSET_CX);
	uint32_t edx = *GET_REG_32(esp, IRQ_REG_OFFSET_DX);
	uint32_t esi = *GET_REG_32(esp, IRQ_REG_OFFSET_SI);
	uint32_t edi = *GET_REG_32(esp, IRQ_REG_OFFSET_DI);

	uint32_t retval = 0;
/*
	kprintf("syscall handler:\n eax = %08x\n ebx = %08x\n ecx = %08x\n edx = %08x\n esi = %08x\n\n",
			eax, ebx, ecx, edx, esi);
*/
	switch (eax)
	{
		case SC_SYS_OPEN_NO: retval = sys_open((char*) ebx, (uint32_t) ecx);
				break;
		case SC_SYS_READ_NO: retval = sys_read((uint32_t) ebx, (char*) ecx, (size_t) edx);
				break;
		case SC_SYS_WRITE_NO: retval = sys_write((uint32_t) ebx, (char*) ecx, (size_t) edx);
				break;
		case SC_SYS_REGISTER_HANDLER: retval = sys_register_handler((uint32_t) ebx);
				break;
		default:
			break;
	}

	*(GET_REG_32(esp, IRQ_REG_OFFSET_AX)) = retval;

}

int sys_open(char* fname, uint32_t fmode)
{
	return -1;
}

int sys_read(uint32_t fd, char* buf, size_t count)
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
			ret = ENOREAD;
		}
	}
	else
	{
		ret = ENOFILE;
	}
	return ret;
}

int sys_write(uint32_t fd, char* buf, size_t count)
{
	int ret;

/*
	outb_printf("fd = %d current = %08x io_block = %08x base_fd_arr = %08x\n",
			fd,
			(uint32_t) current, (uint32_t) current->proc_data.io_block,
			(uint32_t) current->proc_data.io_block->base_fd_arr);
*/

	file_t* p_file = current->proc_data.io_block->base_fd_arr[fd];

/*
	outb(0xe9, 'W');

	outb_printf("fd = %d\n buf = %s \n count = %d \n", fd, buf, count);
	outb_printf("p_file = %08x fixed_file[] = %08x\n", (uint32_t) p_file, (uint32_t) &fixed_file_list[0] );
*/
	if (p_file)
	{
		if (p_file->f_fops->write)
		{
			ret = p_file->f_fops->write(p_file, buf, count, 0);
		}
		else
		{
			ret = ENOWRITE;
		}
	}
	else
	{
		ret = ENOFILE;
	}

	return ret;
}


int sys_register_handler(uint32_t handler_address)
{
	current->proc_data.handler = handler_address;
	outb_printf("sys_register_handler: registered = %08x\n", handler_address);
	return 0;
}



