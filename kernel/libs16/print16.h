#ifndef __print16_h
#define __print16_h

#include "libs16/code16.h"
#include "kerneltypes.h"

#include "libs/gdt.h"

// contains routines that are usable in
// loader and kernel alike

// print routines

void print_str(char* str);
void print_newline();

int print_nibble(uint8_t nibble);
int print_byte(uint8_t byte);
int print_U32(uint32_t num);

extern __NOINLINE void print_char(uint8_t ch);

void print_gdt_entry(descriptor_t* p);

void memset16(void* p, uint8_t val, uint16_t size);


#endif
