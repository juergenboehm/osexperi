#ifndef __kernel32_baseprocs_h
#define __kernel32_baseprocs_h


#include "kerneltypes.h"
#include "kernel32/process.h"


void display_tss(tss_t* tss);

void idle_process();
void kernel_shell_proc();
void idle_screen();

extern int ext2_system_on;
















#endif
