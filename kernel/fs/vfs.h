#ifndef __fs_file_h
#define __fs_file_h

#include "kerneltypes.h"
#include "libs32/utils32.h"
#include "libs/lists.h"


#define FI_KEYB				0
#define	FI_SCREEN			1
#define FI_ERR				-1

#define INODE_TYPE_GENERIC		0

#define DEV_FS_CODE		0


#define MAX_PATH_COMPONENTS 32

#define FILE_NAMELEN	255


#define SEEK_SET	0	/* seek relative to beginning of file */
#define SEEK_CUR	1	/* seek relative to current file position */
#define SEEK_END	2	/* seek relative to end of file */





struct superblk_ops_s;
struct inode_ops_s;
struct dentry_ops_s;
struct file_ops_s;

struct dentry_s;
struct inode_s;

typedef struct dentry_s dentry_t;
typedef struct inode_s inode_t;


typedef struct superblock_s {

	uint32_t	s_device_id;
	inode_t* s_first_inode;
	inode_t* s_mount_point;

	dentry_t* s_root;

	short s_blocksize;
	short s_blocksize_bits;  // blocksize in bits;
	
	uint32_t	s_filesystem_type;
	struct superblk_ops_s* s_ops;
	
} superblock_t;


typedef struct superblk_ops_s {

	int (*read_inode)(inode_t* inode);
	int (*write_inode)(inode_t* inode);
} superblk_ops_t;


#define MK_INO_NO(fs_code, ino_code) ((((uint64_t) (fs_code)) << 32) + (ino_code))
#define GET_FS_CODE(ino) ((uint32_t)(((ino) >> 32)))
#define GET_INO_CODE(ino) ((uint32_t)((ino) & ((((uint64_t)1) << 32) - 1)))


typedef	struct inode_s {

	uint64_t i_ino;				// inode number !! uniquely identifies this inode !!

	uint32_t	i_device;								// device number of device holding this inode
	
	uint32_t i_mode;									// mode of this inode
	
	uint32_t i_user;									// user who owns this inode
	uint32_t i_group;								// group who owns this inode
	
	uint32_t i_creat_time;						// creation time
	uint32_t i_mod_time;							// modification time
	uint32_t i_write_time;						// last write time

	struct inode_ops_s* i_ops;	// inode operations
	struct file_ops_s* i_fops;	// associated file operations
	
	list_head_t		i_hash_link;		// links inode in hash table bucket
	uint32_t i_dentries_refcnt; // how many dentrys point to this inode
	list_head_t** i_hash_header; // hash bucket header of inode

	unsigned int i_blkbits;	 		// blocksize in bits

	uint64_t	i_blocks;	 		// number of blocks in file
	uint32_t i_bytes;  		// number of bytes in last block
	loff_t i_size;					 		// file size in bytes


	void*	i_concrete_inode;

} inode_t;


typedef struct inode_ops_s {

	int (*create)(inode_t* dir, dentry_t* dentry, uint32_t mode);
	dentry_t* (*lookup)(inode_t* dir, dentry_t* dentry);
	int (*unlink)(inode_t* dir, dentry_t* dentry);
	int (*mkdir)(inode_t* dir, dentry_t* dentry, uint32_t mode);
	int (*rmdir)(inode_t* dir, dentry_t* dentry);
	int (*mknod)(inode_t* dir, dentry_t* dentry, uint32_t mode, uint32_t rdev);
	int (*rename)(inode_t* old_dir, dentry_t* old_dentry, inode_t* new_dir, dentry_t* new_dentry);
	int (*permission)(inode_t* ino, int mask);
	int (*refresh)(inode_t* ino);
	int (*destroy)(inode_t* ino);
	
} inode_ops_t;


typedef struct dentry_s {

	char* d_name;
	
	dentry_t* d_parent;
	
	list_head_t d_subdirs;
	list_head_t d_siblings;

	list_head_t d_link;
	list_head_t d_lru_link;
	list_head_t **d_hash_header;

	inode_t* d_inode;
	
	uint64_t d_parent_inode_no;

	int	d_refcount; // how many pointers refer to this dentry

} dentry_t;


typedef struct dentry_ops_s {


} dentry_ops_t;




typedef struct file_s {
	
	uint32_t f_mode;
	loff_t f_pos;									// current file offset
	
	struct dentry_s* f_dentry;
	
	struct file_ops_s* f_fops;

	uint32_t f_flags;

	int f_refcount;  // how many pointers from proc_io_blks point to this file

} file_t;


typedef struct dirent_s {
	
	uint64_t d_inode;
	uint8_t d_type;
	char d_name[FILE_NAMELEN];

} dirent_t;

typedef int (*filldir_t)(void* dirent,
		const char* fname, int fname_len, loff_t pos, uint32_t inode , uint32_t file_type);

typedef struct file_ops_s {

	int (*llseek)(file_t* fil, off_t offset, size_t origin);
	int (*read)(file_t* fil, char* buf, size_t count, size_t* offset);
	int (*write)(file_t* fil, char* buf, size_t count, size_t* offset);
	int (*ioctl)(inode_t* inode, file_t* fil, uint32_t cmd, uint32_t arg);
	int (*open)(inode_t* inode, file_t* fil);
	int (*release)(inode_t* inode, file_t* fil);
	int (*readdir)(file_t* file, void* dirent, filldir_t filldir);

	//device driver operations for blockdrivers (dd_blksize > 0)
	//readblk, writeblk communicate with the hardware
	//in implementations of concrete drivers
	//read and write are programmed generically to use
	//readblk, writeblk
	// fil is here for example
	// a file pointing to a dentry pointing to the inode /dev/sda<x>
	// or /dev/sda
	int (*readblk)(file_t* fil, uint32_t blk_index, char **buf);
	int (*writeblk)(file_t* fil, uint32_t blk_index, char *buf);
	//TODO: the following is not implemented yet, and will perhaps
	//not be used anymore in the future.
	//readpage and writepage use readblk and writeblk,
	//readpage and writepage are part of the
	//global buffer system
	int (*readpage)(file_t* fil, uint32_t page_index, char **buf);
	int (*writepage)(file_t* fil, uint32_t page_index, char *buf);



} file_ops_t;


// 541 is 100th prime

#define NUM_INDE_HASH	541

list_head_t* global_in_de_hash_headers[NUM_INDE_HASH];

list_head_t* global_in_de_lru_list;

int display_in_de_hash();

int delete_in_de_hash_elem(dentry_t* del_dentry);




#define NUM_INO_HASH	541

list_head_t* global_ino_hash_headers[NUM_INO_HASH];

int find_ino(uint64_t inode_no, inode_t** found_inode);
int insert_ino_hash(inode_t* ino);

int display_ino_hash();




dentry_t* gen_lookup(inode_t* dir, dentry_t* dentry);

int get_parse_path(dentry_t* root_dentry, dentry_t* pwd_dentry, uint32_t mode, char* path,
		dentry_t** found_dentry, char* last_fname);



int do_open(char* fname, uint32_t fmode);

void init_base_files();

int link_dentry_t(dentry_t** p, dentry_t* dentry);
int link_file_t(file_t** p, file_t* fil);


int unlink_dentry_t(dentry_t* dentry);
int unlink_file_t(file_t* fil);




#define INIT_FIXED_LISTS_LEN 32

#define DEV_VGA0	20
#define DEV_VGA1	21
#define DEV_VGA2	22
#define DEV_VGA3	23

#define DEV_KBD0		12
#define DEV_KBD1		13
#define DEV_KBD2		14
#define DEV_KBD3		15

#define DEV_TTY0	4
#define DEV_TTY1	5
#define DEV_TTY2	6
#define DEV_TTY3	7

#define DEV_IDE		8
#define DEV_IDE1	9




extern file_t fixed_file_list[INIT_FIXED_LISTS_LEN];
extern dentry_t fixed_dentry_list[INIT_FIXED_LISTS_LEN];
extern inode_t fixed_inode_list[INIT_FIXED_LISTS_LEN];

#define MAX_NUM_FILE_OPS_TYPES 16

extern file_ops_t file_ops_table[MAX_NUM_FILE_OPS_TYPES];

extern dentry_t global_root_dentry;
extern inode_t global_root_inode;



#endif
