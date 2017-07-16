#ifndef __libs32_klib_h
#define __libs32_klib_h

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

typedef uint32_t FILE;


// print main routines

// for system use, prints raw on the screen
int kprintf(char* format, ... );
int outb_printf(char* format, ... );
int raw_printf(char* format, ... );


int printf(char* format, ... );

int fprintf(FILE fd, char* format, ... );

int sprintf(char* s, char* format, ... );

int scanf(char* format, ... );

int fscanf(FILE fd, char* format, ... );

int sscanf(char* s, char* format, ... );


// the putc, getc functions

int getc(uint32_t fd);

int fgetc(FILE fd);

int fputc(int c, FILE fd);

char* fgets(char* s, int n, FILE fd);

int fputs(char* s, FILE fd);


// some string routines

int strcmp(const char* str1, const char* str2);
char* strcpy(char* str1, char* str2);
char* strncpy(char* str1, char* str2, size_t n);
char* strcat(char* str1, char* str2);
int strlen(char* str);

int atoi(char* str);

// memcpy

void* memcpy(void* dest, void* src, size_t n);
void* memset(void* dest, uint8_t val, size_t n);


// new print with file descriptors

int kprint_str(uint32_t fd, char* str);

// old print routines written initially


void kprint_str_raw(char* str);

void kprint_newline();

int kprint_nibble(uint8_t nibble);
int kprint_byte(uint8_t byte);
int kprint_U32(uint32_t num);

void kprint_char(uint8_t ch);

// some lowlevel io functions

void waitkey();

// random numbers

uint32_t rand();


#endif
