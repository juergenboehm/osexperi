
#include "libs32/klib.h"
#include "drivers/vga.h"
#include "fs/gendrivers.h"
#include "fs/vfs.h"


file_t fixed_file_list[INIT_FIXED_LISTS_LEN];
dentry_t fixed_dentry_list[INIT_FIXED_LISTS_LEN];
inode_t fixed_inode_list[INIT_FIXED_LISTS_LEN];


file_ops_t device_driver_file_ops;
file_ops_t ext2_file_ops;



int ddriv_llseek(file_t* fil, size_t offset, size_t origin)
{
	int ret = -1;

	fil->f_pos = offset;
	uint32_t dev_major = GET_MAJOR_DEVICE_NUMBER(fil->f_dentry->d_inode->i_device);
	device_driver_t* pdd = &dev_drv_table[dev_major];
	file_ops_t* pfops = pdd->dd_fops;

	if (pfops)
	{
		ret = pfops->llseek(fil, offset, origin);
	}
	return ret;
}

int ddriv_read(file_t* fil, char* buf, size_t count, size_t* offset)
{
	int ret = -1;

	uint32_t dev_major = GET_MAJOR_DEVICE_NUMBER(fil->f_dentry->d_inode->i_device);
	device_driver_t* pdd = &dev_drv_table[dev_major];

	//outb_printf("ddriv_write reached: dev_major = %d ", dev_major);

	file_ops_t* pfops = pdd->dd_fops;

	if (pfops)
	{
		ret = pdd->dd_fops->read(fil, buf, count, offset);
	}
	return ret;
}

int ddriv_write(file_t* fil, char* buf, size_t count, size_t* offset)
{
	int ret = -1;

	uint32_t dev_major = GET_MAJOR_DEVICE_NUMBER(fil->f_dentry->d_inode->i_device);
	device_driver_t* pdd = &dev_drv_table[dev_major];

	//outb_printf("ddriv_write reached: dev_major = %d ", dev_major);

	file_ops_t* pfops = pdd->dd_fops;

	if (pfops)
	{
		ret = pdd->dd_fops->write(fil, buf, count, offset);
	}
	return ret;
}

int ddriv_ioctl(inode_t* inode, file_t* fil, uint32_t cmd, uint32_t arg)
{
	return -1;
}

int ddriv_open(inode_t* inode, file_t* fil)
{
	int ret = -1;
	uint32_t dev_major = GET_MAJOR_DEVICE_NUMBER(inode->i_device);
	device_driver_t* pdd = &dev_drv_table[dev_major];

	file_ops_t* pfops = pdd->dd_fops;

	if (pfops)
	{
		ret = pdd->dd_fops->open(inode, fil);
	}
	return ret;
}


int ddriv_release(inode_t* inode, file_t* fil)
{
	int ret = -1;
	uint32_t dev_major = GET_MAJOR_DEVICE_NUMBER(inode->i_device);
	device_driver_t* pdd = &dev_drv_table[dev_major];

	file_ops_t* pfops = pdd->dd_fops;

	if (pfops)
	{
		ret = pdd->dd_fops->release(inode, fil);
	}

	return -1;
}

int ddriv_readdir(file_t* file, void* dirent, filldir_t filldir)
{
	return -1;
}

int set_file_ops(file_ops_t* fops,
		void *llseek,
		void *read,
		void *write,
		void *ioctl,
		void *open,
		void *release,
		void *readdir )
{
	fops->llseek = llseek;
	fops->read = read;
	fops->write = write;
	fops->ioctl = ioctl;
	fops->open = open;
	fops->release = release;
	fops->readdir = readdir;

	return 0;
}

void create_device_driver_file_ops(file_ops_t* fops)
{
	set_file_ops(fops, &ddriv_llseek, &ddriv_read, &ddriv_write, &ddriv_ioctl, ddriv_open, NULL, NULL);
}

/*

#define INODE_TYPE_GENERIC		0

inode_t * create_inode(int type, inode_t* buf)
{
	return buf;
}

file_t* create_file(int type, file_t* buf)
{
	return buf;
}

dirent_t* create_dirent(int type, dirent_t* buf)
{
	return buf;
}

file_ops_t* create_file_ops(int type, file_ops_t* buf)
{
	return buf;
}

*/

void init_base_files()
{

	init_device_table();

	create_device_driver_file_ops(&device_driver_file_ops);

	int i;

	int dev_vga_code[4] = { DEV_VGA0, DEV_VGA1, DEV_VGA2, DEV_VGA3 };
	int dev_kbd_code[4] = { DEV_KBD0, DEV_KBD1, DEV_KBD2, DEV_KBD3 };

	for(i = 0; i < 4; ++i)
	{

		// make inode for /dev/vga<i>

		inode_t * dev_vga_inode;

		dev_vga_inode = &fixed_inode_list[dev_vga_code[i]];

		dev_vga_inode->i_device = MAKE_DEVICE_NUMBER(DEV_VGA_INDEX, i);
		dev_vga_inode->i_fops = &device_driver_file_ops;
		dev_vga_inode->i_ino = i;

		dentry_t* dev_vga_dentry = &fixed_dentry_list[dev_vga_code[i]];

		dev_vga_dentry->d_inode = dev_vga_inode;

		file_t* dev_vga_file = &fixed_file_list[dev_vga_code[i]];

		dev_vga_file->f_pos = 0;
		dev_vga_file->f_dentry = dev_vga_dentry;
		dev_vga_file->f_fops = dev_vga_dentry->d_inode->i_fops;

	}

	for(i = 0; i < 4; ++i)
	{
		// make inode for /dev/vga<i>

		inode_t * dev_keyb_inode;

		dev_keyb_inode = &fixed_inode_list[dev_kbd_code[i]];

		dev_keyb_inode->i_device = MAKE_DEVICE_NUMBER(DEV_KBD_INDEX, i);
		dev_keyb_inode->i_fops = &device_driver_file_ops;
		dev_keyb_inode->i_ino = i;

		dentry_t* dev_keyb_dentry = &fixed_dentry_list[dev_kbd_code[i]];

		dev_keyb_dentry->d_inode = dev_keyb_inode;

		file_t* dev_keyb_file = &fixed_file_list[dev_kbd_code[i]];

		dev_keyb_file->f_pos = 0;
		dev_keyb_file->f_dentry = dev_keyb_dentry;
		dev_keyb_file->f_fops = dev_keyb_dentry->d_inode->i_fops;


	}

}




int do_open(char* fname, uint32_t fmode)
{
	
	if (strcmp(fname, "/dev/keyb") == 0)
	{
		return FI_KEYB;
	}
	if (strcmp(fname, "/dev/vga0") == 0)
	{
		file_t* p_file = &fixed_file_list[DEV_VGA0];
		inode_t* p_inode = p_file->f_dentry->d_inode;
		p_file->f_fops->open(p_inode, p_file);
		return FI_SCREEN;
	}
	if (strcmp(fname, "/dev/vga1") == 0)
	{
		file_t* p_file = &fixed_file_list[DEV_VGA1];
		inode_t* p_inode = p_file->f_dentry->d_inode;
		p_file->f_fops->open(p_inode, p_file);
		return FI_SCREEN;
	}
	if (strcmp(fname, "/dev/vga2") == 0)
	{
		file_t* p_file = &fixed_file_list[DEV_VGA2];
		inode_t* p_inode = p_file->f_dentry->d_inode;
		p_file->f_fops->open(p_inode, p_file);
		return FI_SCREEN;
	}
	if (strcmp(fname, "/dev/vga3") == 0)
	{
		file_t* p_file = &fixed_file_list[DEV_VGA3];
		inode_t* p_inode = p_file->f_dentry->d_inode;
		p_file->f_fops->open(p_inode, p_file);
		return FI_SCREEN;
	}
	return FI_ERR;
}
