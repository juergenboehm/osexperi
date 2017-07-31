#ifndef __kernel_user_stdlib_h
#define __kernel_user_stdlib_h

#include "kerneltypes.h"
#include "drivers/keyb.h"


// some typical defines

#define	MAX_INT			((int)(~(unsigned int)(1 << (sizeof(int) - 1))))
#define MAX_UINT    (~((unsigned int)(0)))

typedef unsigned int uint;



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


// random numbers

// syscalls

int register_handler(void *address_of_handler);
int fork();





#endif
