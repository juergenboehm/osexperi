
#include "libs32/klib.h"
#include "drivers/vga.h"
#include "drivers/keyb_decode.h"
#include "drivers/ide.h"
#include "fs/bufcache.h"
#include "fs/vfs.h"
#include "fs/gendrivers.h"


device_driver_t dev_drv_table[DEV_DRIVER_TABLE_LEN];

file_ops_t vga_driver_ops;
file_ops_t keyb_driver_ops;
file_ops_t ide_driver_ops;
file_ops_t tty_driver_ops;

void init_file_ops_line(file_ops_t *pddops,
		void* llseek_proc,
		void* read_proc, void* write_proc,
		void* ioctl_proc,
		void* open_proc, void* release_proc, void* readdir_proc,
		void* readblk, void* writeblk, void* readpage, void* writepage)
{
	pddops->llseek = llseek_proc;
	pddops->read = read_proc;
	pddops->write = write_proc;
	pddops->ioctl = ioctl_proc;
	pddops->open = open_proc;
	pddops->release = release_proc;
	pddops->readdir = readdir_proc;

	pddops->readblk = readblk;
	pddops->writeblk = writeblk;

	pddops->readpage = readpage;
	pddops->writepage = writepage;
}


void init_file_ops()
{
	init_file_ops_line(&vga_driver_ops, NULL, NULL, &vga_write, NULL, &vga_open, NULL, NULL,
			NULL, NULL, NULL, NULL);
	init_file_ops_line(&keyb_driver_ops, NULL, &keyb_read, NULL, NULL, NULL, NULL, NULL,
			NULL, NULL, NULL, NULL);
	init_file_ops_line(&ide_driver_ops, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
			&readblk_ide_cached, &writeblk_ide_cached, NULL, NULL);
	init_file_ops_line(&tty_driver_ops, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
			NULL, NULL, NULL, NULL);



}


void init_device(device_driver_t* pdd, uint32_t rdev, uint32_t pos, file_ops_t* pddfops)
{
	pdd->dd_rdev = rdev;
	pdd->dd_pos = 0;
	pdd->dd_blksize = 0;
	pdd->dd_fops = pddfops;
}

void init_blk_device(device_driver_t* pdd, uint32_t rdev, uint32_t blksize,
		uint32_t pos, file_ops_t* pddfops)
{
	pdd->dd_rdev = rdev;
	pdd->dd_pos = 0;
	pdd->dd_blksize = blksize;
	pdd->dd_fops = pddfops;
}


void init_device_table()
{
	init_file_ops();

	init_device(&dev_drv_table[DEV_VGA_INDEX], MAKE_DEVICE_NUMBER(DEV_VGA_INDEX,0), 0, &vga_driver_ops);

	init_device(&dev_drv_table[DEV_KBD_INDEX], MAKE_DEVICE_NUMBER(DEV_KBD_INDEX,0), 0, &keyb_driver_ops);
	init_device(&dev_drv_table[DEV_TTY_INDEX], MAKE_DEVICE_NUMBER(DEV_TTY_INDEX,0), 0, &tty_driver_ops);

	init_blk_device(&dev_drv_table[DEV_IDE_INDEX], MAKE_DEVICE_NUMBER(DEV_IDE_INDEX,0),
			IDE_BLKSIZE, 0, &ide_driver_ops);

}
