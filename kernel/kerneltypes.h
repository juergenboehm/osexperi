#ifndef __kerneltypes_h
#define __kerneltypes_h

// put further general utilities there
#include "libs/utils.h"

typedef unsigned long long uint64_t;
typedef	unsigned int uint32_t; 
typedef unsigned short uint16_t;
typedef unsigned char uint8_t;

typedef unsigned int uint_t;

typedef uint_t size_t;
typedef long long loff_t;

typedef uint32_t physaddr_t;


typedef int bool;

#define true		1
#define false		0



#define	NULL 0

//#define SIMULATOR 1


#ifdef SIMULATOR
#define outb_0xe9(val) outb(0xe9, val)
#define uoutb_0xe9(val) uoutb(0xe9, val)
#endif

#ifndef SIMULATOR
#define outb_0xe9(val) do {} while (0)
#define uoutb_0xe9(val) do {} while (0)
#endif

#endif
