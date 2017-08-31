#ifndef __kernel_user_stdlib_h
#define __kernel_user_stdlib_h

#include "kerneltypes.h"
//#include "drivers/keyb.h"

#include "fs/fcntl.h"


// some typical defines

#define	MAX_INT			((int)(~(unsigned int)(1 << (sizeof(int) - 1))))
#define MAX_UINT    (~((unsigned int)(0)))

typedef unsigned int uint;


#define	ASCII_CR			0x0d
#define ASCII_BS			0x08
#define ASCII_DEL			0x7f



// some things from several other .h collected here preliminarily


static inline int is_digit(char c)
{
	return ((c >= '0') && (c <= '9'));
}


//
// the following should normally be contained
// in stdarg.h
// it is needed for variadic functions like
// printf or scanf
//

// a type definition first

typedef __builtin_va_list __gnuc_va_list;
typedef __gnuc_va_list va_list;

// the access macros

#define va_start(v,l)	__builtin_va_start(v,l)
#define va_end(v)	__builtin_va_end(v)
#define va_arg(v,l)	__builtin_va_arg(v,l)

// the following is Non-ANSI

#define va_copy(d,s)	__builtin_va_copy(d,s)



// some general types
// some of them preliminary only as stubs defined

uint32_t FILE;


// print main routines

int printf(char* format, ... );
int outb_printf(char* format, ... );

int fprintf(int fd, char* format, ... );


// read from keyboard

int getc(uint32_t fd);


// some machine-level functions

static inline uint16_t get_cs()
{
		uint16_t cs_val;
		asm __volatile__("movw %%cs, %0": "=r"(cs_val));
		return cs_val;
}

static inline uint16_t get_ds()
{
		uint16_t ds_val;
		asm __volatile__("movw %%ds, %0": "=r"(ds_val));
		return ds_val;
}

static inline void outb(uint16_t port, uint8_t val)
{
	asm __volatile__ ( "outb %1, %0" :
				 : "Nd"(port), "a"(val) );
}


// the putc, getc functions






// some string routines

// memcpy

int strlen(char *str);



// old print routines written initially

// some lowlevel io functions


// fs defines

#define EXT2_S_IFSOCK	0xC000
#define EXT2_S_IFLNK	0xA000
#define EXT2_S_IFREG	0x8000
#define EXT2_S_IFBLK	0x6000
#define EXT2_S_IFDIR	0x4000
#define EXT2_S_IFCHR	0x2000
#define EXT2_S_IFIFO	0x1000

#define EXT2_S_IRUSR	0x0100
#define EXT2_S_IWUSR	0x0080
#define EXT2_S_IXUSR	0x0040
#define EXT2_S_IRGRP	0x0020
#define EXT2_S_IWGRP	0x0010
#define EXT2_S_IXGRP	0x0008
#define EXT2_S_IROTH	0x0004
#define EXT2_S_IWOTH	0x0002
#define EXT2_S_IXOTH	0x0001

#define EXT2_FT_UNKNOWN		0
#define EXT2_FT_REG_FILE	1
#define EXT2_FT_DIR				2

#define EXT2_NAMELEN		255



// structures for system calls


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



#define FILE_NAMELEN	255

typedef struct dirent_s {

	uint64_t d_inode;
	uint8_t d_type;
	char d_name[FILE_NAMELEN];

} dirent_t;



// syscalls

int register_handler(void *address_of_handler);
int fork();


int open(char *pathname, int flags, ...);
int close(int fd);


int read(int fd, void *buf, size_t count);
int write(int fd, const void *buf, size_t count);

int chdir(char* pathname);

int readdir(int fd, dirent_t* dirent);

int unlink(char *pathname);

int mkdir(char *pathname, mode_t mode);
int rmdir(char *pathname);




#endif
