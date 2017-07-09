

#include "libs/kerneldefs.h"
#include "kernel32/process.h"

#include "kernel32/proclife.h"



void init_proc_eip(process_t* proc, uint32_t new_eip, uint32_t new_ebp)
{
	proc->proc_data.tss.eip = new_eip;
	proc->proc_data.tss.ebp = new_ebp;
}

void init_proc_eflags(process_t* proc, uint32_t new_eflags)
{
	proc->proc_data.tss.eflags = new_eflags;
}

void init_proc_cr3(process_t* proc, uint32_t new_cr3)
{
	proc->proc_data.tss.cr3 = new_cr3;
}

void init_proc_basic(process_t* proc, uint32_t pid, uint32_t ticks)
{
	proc->proc_data.pid = pid;
	proc->proc_data.ticks = ticks;
}

void init_proc_handler(process_t* proc)
{
	proc->proc_data.handler = 0;
	proc->proc_data.signal_pending = 0;
	proc->proc_data.handler_arg = 0;
}

void init_proc_tss_stacks(process_t* proc, uint32_t esp_system, uint32_t esp_user)
{
	proc->proc_data.tss.esp0 = esp_system;
	proc->proc_data.tss.ss0 = KERNEL32_DS;

	proc->proc_data.tss.ss = USER32_DS;
	proc->proc_data.tss.esp = esp_user;

	proc->proc_data.tss.ebp = 0;

}

void init_proc_tss_segments(process_t* proc, uint32_t is_user_mode)
{
	uint32_t seg_ds = is_user_mode ? USER32_DS : KERNEL32_DS;
	uint32_t seg_cs = is_user_mode ? USER32_CS : KERNEL32_CS;

	proc->proc_data.tss.ds = seg_ds;
	proc->proc_data.tss.es = seg_ds;
	proc->proc_data.tss.fs = seg_ds;
	proc->proc_data.tss.gs = seg_ds;
	proc->proc_data.tss.ss = seg_ds;

	proc->proc_data.tss.cs = seg_cs;
}
