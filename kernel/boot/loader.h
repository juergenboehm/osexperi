#ifndef __kernel_h
#define __kernel_h

#include "libs16/code16.h"
#include "kerneltypes.h"

#define	LOADER_SEG	0x1000
#define KERNEL16_SEG 0x2000


// contains loader only routines
// supposing real mode and BIOS
// accessible

int lmain();
int test_disk();
#endif
