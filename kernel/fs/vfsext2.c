
#include "libs32/klib.h"
#include "kernel32/objects.h"

#include "mem/malloc.h"

#include "fs/bufcache.h"

#include "fs/vfs.h"
#include "fs/ext2.h"

#include "fs/vfsext2.h"


file_ops_t ext2_file_ops;
inode_ops_t ext2_inode_ops;

int init_inode_from_ext2(inode_t* inode, file_ext2_t* file_ext2)
{
	//inode->i_ino = MK_INO_NO(EXT2_FS_CODE, file_ext2->inode_index);
	inode->i_concrete_inode = file_ext2;

	inode->i_ops = &ext2_inode_ops;
	inode->i_fops = &ext2_file_ops;

	return 0;

}

int ext2_refresh(inode_t* ino)
{
	int retval = -1;

	file_ext2_t* ino_ext2 = (file_ext2_t*) ino->i_concrete_inode;

	retval = read_inode_ext2(ino_ext2, ino_ext2->inode_index);

	return retval;

}

int ext2_destroy(inode_t* ino)
{
	int retval = -1;

	file_ext2_t* ino_ext2 = (file_ext2_t*) ino->i_concrete_inode;

	retval = destroy_file_ext2(ino_ext2);

	free(ino_ext2);

	return retval;
}





int ext2_create(inode_t* dir, dentry_t* dentry, uint32_t mode)
{
	int retval = -1;

	ext2_refresh(dir);

	file_ext2_t* dir_file_ext2 = (file_ext2_t*)(dir->i_concrete_inode);

	file_ext2_t* filp_new_file = alloc_file_ext2();
	init_file_ext2(filp_new_file, dir_file_ext2->dev_file, dir_file_ext2->sb);

	outb_printf("ext2_create: dentry->d_name = >%s<\n", dentry->d_name);

	retval = create_file_ext2(dir_file_ext2, filp_new_file, dentry->d_name, EXT2_S_IFREG | mode, 0);

	destroy_file_ext2(filp_new_file);
	free(filp_new_file);

	return retval;
}

dentry_t* ext2_lookup(inode_t* dir, dentry_t* dentry)
{

	outb_printf("ext2_lookup: inode_no = %016lx, dentry_name = >%s<\n",
			dir->i_ino, dentry->d_name);

	ext2_refresh(dir);

	file_ext2_t* dir_file_ext2 = (file_ext2_t*)(dir->i_concrete_inode);


	dir_entry_ext2_t found_entry;
	uint32_t offset;
	uint32_t offset_before;

	int ret = lookup_name_in_dir_ext2(dir_file_ext2, dentry->d_name,
			&found_entry, &offset, &offset_before);

	// ret == 1: found entry
	if (ret == 1)
	{
		uint32_t inode_no_ext2 = found_entry.inode;

		uint64_t ino_no = MK_INO_NO(EXT2_FS_CODE, inode_no_ext2);

		inode_t* found_inode = 0;

		find_ino(ino_no, &found_inode);

		if (!found_inode)
		{
			found_inode = get_inode_t();

			found_inode->i_ino = ino_no;

			insert_ino_hash(found_inode);

			file_ext2_t* new_file_ext2 = alloc_file_ext2();

			init_file_ext2(new_file_ext2, dir_file_ext2->dev_file, dir_file_ext2->sb);

			read_inode_ext2(new_file_ext2, inode_no_ext2);

			init_inode_from_ext2(found_inode, new_file_ext2);

		}

		dentry_t* new_akt_dentry = get_dentry_t();

		new_akt_dentry->d_inode = found_inode;
		new_akt_dentry->d_parent_inode_no = dir->i_ino;

		char* new_name = strcpy_alloc(dentry->d_name);

		new_akt_dentry->d_name = new_name;

		++found_inode->i_dentries_refcnt;

		return new_akt_dentry;

	}
	else
	{
		return NULL;
	}


}

int ext2_unlink(inode_t* dir, dentry_t* dentry)
{
	int retval = -1;

	outb_printf("ext2_unlink: dentry->d_name = >%s<\n", dentry->d_name);

	ext2_refresh(dir);

	file_ext2_t* par_dir_ext2 = (file_ext2_t*)(dir->i_concrete_inode);

	retval = unlink_file_ext2(par_dir_ext2, dentry->d_name);

	return retval;
}

int ext2_mkdir(inode_t* dir, dentry_t* dentry, uint32_t mode)
{
	int retval = -1;

	outb_printf("ext2_mkdir: dentry->d_name = >%s<\n", dentry->d_name);

	ext2_refresh(dir);

	file_ext2_t* par_dir_ext2 = (file_ext2_t*)(dir->i_concrete_inode);

	outb_printf("ext2_mkdir: inode index = %d\n", par_dir_ext2->inode_index);

	file_ext2_t filp_new_dir;

	init_file_ext2(&filp_new_dir, par_dir_ext2->dev_file, par_dir_ext2->sb);

	retval = create_directory_ext2(par_dir_ext2, &filp_new_dir, dentry->d_name, mode, 0);

	outb_printf("ext2_mkdir: inode i_links_count = %d\n", par_dir_ext2->pinode->i_links_count);

	destroy_file_ext2(&filp_new_dir);

	return retval;
}

int ext2_rmdir(inode_t* dir, dentry_t* dentry)
{
	int retval = -1;

	outb_printf("ext2_rmdir: dentry->d_name = >%s<\n", dentry->d_name);

	ext2_refresh(dir);

	file_ext2_t* par_dir_ext2 = (file_ext2_t*)(dir->i_concrete_inode);

	retval = delete_directory_ext2(par_dir_ext2, dentry->d_name);

	return retval;
}

int ext2_mknod(inode_t* dir, dentry_t* dentry, uint32_t mode, uint32_t rdev)
{
	return -1;
}

int ext2_rename(inode_t* old_dir, dentry_t* old_dentry, inode_t* new_dir, dentry_t* new_dentry)
{
	return -1;
}

int ext2_permission(inode_t* ino, int mask)
{
	return -1;
}



int ext2_llseek(file_t* fil, off_t offset, size_t origin)
{

	int ret = -1;

	size_t offset_new = fil->f_pos;

	file_ext2_t* fil_ext2 = (file_ext2_t*)fil->f_dentry->d_inode->i_concrete_inode;
	uint32_t fil_size = fil_ext2->pinode->i_size;

	switch (origin)
	{
		case SEEK_SET: offset_new = offset;
										break;
		case SEEK_CUR: offset_new = fil->f_pos + offset;
										break;
		case SEEK_END: offset_new = fil_size + offset;
										break;
		default:	return -1;
	}

	fil->f_pos = offset_new;

	return 0;
}

int ext2_read(file_t* fil, char* buf, size_t count, size_t* offset)
{
	int retval = -1;
	uint32_t offset_akt = offset ? *offset : fil->f_pos;

	file_ext2_t* ext2_file = (file_ext2_t*)fil->f_dentry->d_inode->i_concrete_inode;

	int nrd = read_file_ext2(ext2_file, buf, count, offset_akt);

	if (nrd < 0)
	{
		retval = -1;
		goto ende;
	}

	offset_akt += nrd;

	if (offset)
	{
		*offset = offset_akt;
	}

	fil->f_pos = offset_akt;
	retval = nrd;

	ende:
	return retval;
}

int ext2_write(file_t* fil, char* buf, size_t count, size_t* offset)
{
	int retval = -1;
	uint32_t offset_akt = offset ? *offset : fil->f_pos;

	file_ext2_t* ext2_file = (file_ext2_t*)fil->f_dentry->d_inode->i_concrete_inode;

	int nwrt = write_file_ext2(ext2_file, buf, count, offset_akt);

	if (nwrt < 0)
	{
		retval = -1;
		goto ende;
	}

	offset_akt += nwrt;

	if (offset)
	{
		*offset = offset_akt;
	}

	fil->f_pos = offset_akt;
	retval = nwrt;

	ende:
	return retval;
}

int ext2_open(inode_t* inode, file_t* fil)
{
	return -1;
}

int ext2_readdir(file_t* file, void* dirent, filldir_t filldir)
{
	int retval = -1;

	file_ext2_t *ext2_file = (file_ext2_t*)file->f_dentry->d_inode->i_concrete_inode;
	dir_entry_ext2_t akt_dentry;

	char* namebuf = malloc(EXT2_NAMELEN);
	uint32_t dir_offset = file->f_pos;

	if (dir_offset == ext2_file->pinode->i_size)
	{
		retval = 0;
		goto ende;
	}

	retval = readdir_ext2(ext2_file, &akt_dentry, namebuf, &dir_offset);

	if (retval < 0)
	{
		goto ende;
	}

	dirent_t *akt_dirent = (dirent_t*) dirent;

	akt_dirent->d_inode = akt_dentry.inode;
	akt_dirent->d_type = akt_dentry.file_type;
	strcpy(akt_dirent->d_name, namebuf);


	retval = 1;


	file->f_pos = dir_offset;

	ende:

	free(namebuf);

	return retval;
}


















