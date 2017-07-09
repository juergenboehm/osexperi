#ifndef __kernel32_proclife_h
#define __kernel32_proclife_h

#include "kerneltypes.h"


void init_proc_cr3(process_t* proc, uint32_t new_cr3);

void init_proc_eip(process_t* proc, uint32_t new_eip, uint32_t new_ebp);

void init_proc_eflags(process_t* proc, uint32_t new_eflags);


void init_proc_basic(process_t* proc, uint32_t pid, uint32_t ticks);
void init_proc_handler(process_t* proc);
void init_proc_tss_stacks(process_t* proc,  uint32_t esp_system, uint32_t esp_user);
void init_proc_tss_segments(process_t* proc, uint32_t is_user_mode);


























#endif
