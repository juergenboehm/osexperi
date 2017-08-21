#ifndef __fs_vfsext2_h
#define __fs_vfsext2_h

#include "kerneltypes.h"
#include "fs/ext2.h"
#include "fs/vfs.h"


extern file_ops_t ext2_file_ops;

extern inode_ops_t ext2_inode_ops;

#define EXT2_FS_CODE	1


int init_inode_from_ext2(inode_t* inode, file_ext2_t* file_ext2);


int ext2_create(inode_t* dir, dentry_t* dentry, uint32_t mode);

dentry_t* ext2_lookup(inode_t* dir, dentry_t* dentry);

int ext2_unlink(inode_t* dir, dentry_t* dentry);

int ext2_mkdir(inode_t* dir, dentry_t* dentry, uint32_t mode);

int ext2_rmdir(inode_t* dir, dentry_t* dentry);

int ext2_mknod(inode_t* dir, dentry_t* dentry, uint32_t mode, uint32_t rdev);

int ext2_rename(inode_t* old_dir, dentry_t* old_dentry, inode_t* new_dir, dentry_t* new_dentry);



int ext2_llseek(file_t* fil, off_t offset, size_t origin);
int ext2_read(file_t* fil, char* buf, size_t count, size_t* offset);
int ext2_write(file_t* fil, char* buf, size_t count, size_t* offset);

int ext2_open(inode_t* inode, file_t* fil);

int ext2_readdir(file_t* file, void* dirent, filldir_t filldir);






















#endif

