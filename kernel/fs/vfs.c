
#include "libs32/klib.h"
#include "drivers/vga.h"
#include "fs/gendrivers.h"
#include "fs/vfs.h"


file_t fixed_file_list[INIT_FIXED_LISTS_LEN];
dentry_t fixed_dentry_list[INIT_FIXED_LISTS_LEN];
inode_t fixed_inode_list[INIT_FIXED_LISTS_LEN];


file_ops_t device_driver_file_ops;

file_ops_t device_driver_blk_file_ops;

file_ops_t ext2_file_ops;



int ddriv_llseek(file_t* fil, size_t offset, size_t origin)
{
	int ret = -1;

	fil->f_pos = offset;

	ret = 0;

	uint32_t dev_major = GET_MAJOR_DEVICE_NUMBER(fil->f_dentry->d_inode->i_device);
	device_driver_t* pdd = &dev_drv_table[dev_major];
	file_ops_t* pfops = pdd->dd_fops;

	if (pfops && pfops->llseek)
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

	if (pfops && pfops->read)
	{
		ret = pfops->read(fil, buf, count, offset);
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

	if (pfops && pfops->write)
	{
		ret = pfops->write(fil, buf, count, offset);
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

	if (pfops && pfops->open)
	{
		ret = pfops->open(inode, fil);
	}
	return ret;
}


int ddriv_release(inode_t* inode, file_t* fil)
{
	int ret = -1;
	uint32_t dev_major = GET_MAJOR_DEVICE_NUMBER(inode->i_device);
	device_driver_t* pdd = &dev_drv_table[dev_major];

	file_ops_t* pfops = pdd->dd_fops;

	if (pfops && pfops->release)
	{
		ret = pfops->release(inode, fil);
	}

	return -1;
}

int ddriv_readdir(file_t* file, void* dirent, filldir_t filldir)
{
	return -1;
}

//TO DO: test the code, first test done
int ddriv_read_blk(file_t* fil, char* buf, size_t count, size_t* offset)
{
	int ret = -1;

	uint32_t dev_major = GET_MAJOR_DEVICE_NUMBER(fil->f_dentry->d_inode->i_device);
	device_driver_t* pdd = &dev_drv_table[dev_major];

	file_ops_t* pfops = pdd->dd_fops;

	uint32_t offset_akt = fil->f_pos;

	uint32_t blksize = pdd->dd_blksize;

	uint32_t akt_count = count;

	char* blk_buf = (char*)malloc(blksize);
	char* pbuf = buf;

	uint32_t nrd_total = 0;

	while (akt_count > 0)
	{

		uint32_t blk_rd_index = offset_akt/blksize;
		uint32_t blk_offset = offset_akt % blksize;

		uint32_t ncnt = min(blksize - blk_offset, akt_count);

		int nrd = pfops->readblk(fil, blk_rd_index, &blk_buf);

		if (nrd < 0)
		{
			goto ende;
		}

		nrd = min(nrd, ncnt);

		//outb_printf("ddrv_read_blk: nrd = %d, blk_rd_index = %d, blk_offset = %d\n",
		//		nrd, blk_rd_index, blk_offset);

		memcpy(pbuf, &blk_buf[blk_offset], nrd );

		pbuf += nrd;

		offset_akt += nrd;
		akt_count -= nrd;

		nrd_total += nrd;
	}

ende:
	free(blk_buf);

	fil->f_pos = offset_akt;

	return nrd_total;
}

//
// for block devices some driver functions are special
//

//TO DO: test the code, doing first test
int ddriv_write_blk(file_t* fil, char* buf, size_t count, size_t* offset)
{
	int ret = -1;

	uint32_t dev_major = GET_MAJOR_DEVICE_NUMBER(fil->f_dentry->d_inode->i_device);
	device_driver_t* pdd = &dev_drv_table[dev_major];

	//outb_printf("ddriv_write reached: dev_major = %d ", dev_major);

	file_ops_t* pfops = pdd->dd_fops;

	uint32_t offset_akt = fil->f_pos;
	uint32_t blksize = pdd->dd_blksize;

	uint32_t akt_count = count;

	char* blk_buf = (char*)malloc(blksize);
	char* pbuf = buf;

	uint32_t nwrt_total = 0;

	while (akt_count > 0)
	{

		uint32_t blk_wrt_index = offset_akt/blksize;
		uint32_t blk_offset = offset_akt % blksize;

		uint32_t ncnt = min(blksize - blk_offset, akt_count);

		int nrd;
		if (ncnt < blksize)
		{
			nrd = pfops->readblk(fil, blk_wrt_index, &blk_buf);
		}

		if (nrd < 0)
		{
			goto ende;
		}


		memcpy(&blk_buf[blk_offset], pbuf, ncnt );

		uint32_t nwrt = blksize;
		//outb_printf("simu writeblk: pbo = %d blk_wrt_index = %d : ",
		//		(uint32_t)(pbuf - buf), blk_wrt_index);
		nwrt = pfops->writeblk(fil, blk_wrt_index, blk_buf);

		if (nwrt < 0)
		{
			goto ende;
		}

		nwrt_total += ncnt;

		pbuf += ncnt;

		offset_akt += ncnt;
		akt_count -= ncnt;
	}

ende:

	free(blk_buf);

	fil->f_pos = offset_akt;


	return nwrt_total;
}



int ddriv_readblk(file_t* fil, uint32_t blk_index, char **buf)
{
	int ret = -1;

	uint32_t dev_major = GET_MAJOR_DEVICE_NUMBER(fil->f_dentry->d_inode->i_device);
	device_driver_t* pdd = &dev_drv_table[dev_major];

	file_ops_t* pfops = pdd->dd_fops;

	if (pfops && pfops->readblk)
	{
		ret = pfops->readblk(fil, blk_index, buf);
	}
	return ret;
}

int ddriv_writeblk(file_t* fil, uint32_t blk_index, char *buf)
{
	int ret = -1;

	uint32_t dev_major = GET_MAJOR_DEVICE_NUMBER(fil->f_dentry->d_inode->i_device);
	device_driver_t* pdd = &dev_drv_table[dev_major];

	file_ops_t* pfops = pdd->dd_fops;

	if (pfops && pfops->writeblk)
	{
		ret = pfops->writeblk(fil, blk_index, buf);
	}
	return ret;
}



int set_file_ops(file_ops_t* fops,
		void *llseek,
		void *read,
		void *write,
		void *ioctl,
		void *open,
		void *release,
		void *readdir,
		void *readblk,
		void *writeblk,
		void *readpage,
		void *writepage)
{
	fops->llseek = llseek;
	fops->read = read;
	fops->write = write;
	fops->ioctl = ioctl;
	fops->open = open;
	fops->release = release;
	fops->readdir = readdir;

	fops->readblk = readblk;
	fops->writeblk = writeblk;
	fops->readpage = readpage;
	fops->writepage = writepage;

	return 0;
}

void create_device_driver_file_ops(file_ops_t* fops)
{
	set_file_ops(fops, &ddriv_llseek, &ddriv_read, &ddriv_write, &ddriv_ioctl, &ddriv_open, NULL, NULL,
			NULL, NULL, NULL, NULL);
}

void create_device_driver_blk_file_ops(file_ops_t* fops)
{
	set_file_ops(fops, &ddriv_llseek, &ddriv_read_blk, &ddriv_write_blk, &ddriv_ioctl, &ddriv_open, NULL, NULL,
			&ddriv_readblk, &ddriv_writeblk, NULL, NULL);
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
	create_device_driver_blk_file_ops(&device_driver_blk_file_ops);

	int i;

	int dev_vga_code[4] = { DEV_VGA0, DEV_VGA1, DEV_VGA2, DEV_VGA3 };
	int dev_kbd_code[4] = { DEV_KBD0, DEV_KBD1, DEV_KBD2, DEV_KBD3 };
	int dev_ide_code[2] = { DEV_IDE, DEV_IDE1 };

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

	for(i = 0; i < 2; ++i)
	{
		// make inode for /dev/ide<i>

		inode_t * dev_ide_inode;

		dev_ide_inode = &fixed_inode_list[dev_ide_code[i]];

		dev_ide_inode->i_device = MAKE_DEVICE_NUMBER(DEV_IDE_INDEX, i);
		dev_ide_inode->i_fops = &device_driver_blk_file_ops;
		dev_ide_inode->i_ino = i;

		dentry_t* dev_ide_dentry = &fixed_dentry_list[dev_ide_code[i]];

		dev_ide_dentry->d_inode = dev_ide_inode;

		file_t* dev_ide_file = &fixed_file_list[dev_ide_code[i]];

		dev_ide_file->f_pos = 0;
		dev_ide_file->f_dentry = dev_ide_dentry;
		dev_ide_file->f_fops = dev_ide_dentry->d_inode->i_fops;


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
