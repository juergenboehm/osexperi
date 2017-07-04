	.file	"process.c"
#APP
	.code16gcc	

	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"kernel32/process.c"
.LC1:
	.string	"[Debug: %s:%d]"
.LC2:
	.string	"sizeof(tss_t) = %d\n"
.LC3:
	.string	"sizeof(process_t) = %d\n"
.LC4:
	.string	"End of init_global_tss.\n"
#NO_APP
	.text
	.globl	init_global_tss
	.type	init_global_tss, @function
init_global_tss:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp
	pushl	$304
	pushl	$.LC0
	pushl	$.LC1
	call	printf
	popl	%eax
	popl	%edx
	pushl	$104
	pushl	$.LC2
	call	printf
	addl	$12, %esp
	pushl	$305
	pushl	$.LC0
	pushl	$.LC1
	call	printf
	popl	%ecx
	popl	%eax
	pushl	$8192
	pushl	$.LC3
	call	printf
	movl	$4096, (%esp)
	call	malloc
	movl	%eax, global_tss
	addl	$12, %esp
	pushl	$104
	pushl	$0
	pushl	%eax
	call	memset
	movb	$0, gdt_table_32+86
	movl	global_tss, %eax
	movw	%ax, gdt_table_32+82
	movl	%eax, %edx
	shrl	$16, %edx
	movb	%dl, gdt_table_32+84
	shrl	$24, %eax
	movb	%al, gdt_table_32+87
	movw	$8191, gdt_table_32+80
	movb	$-119, gdt_table_32+85
#APP
# 314 "kernel32/process.c" 1
	movw $80, %ax 
	 ltr %ax
# 0 "" 2
#NO_APP
	addl	$12, %esp
	pushl	$316
	pushl	$.LC0
	pushl	$.LC1
	call	printf
	movl	$.LC4, (%esp)
	call	printf
	xorl	%eax, %eax
	leave
	ret
	.size	init_global_tss, .-init_global_tss
	.globl	schedule_1
	.type	schedule_1, @function
schedule_1:
	pushl	%ebp
	movl	%esp, %ebp
	movl	current, %eax
	movl	%eax, p_tss_current
	movl	next, %eax
	movl	%eax, p_tss_next
#APP
# 337 "kernel32/process.c" 1
	movl p_tss_current, %edx 
	popl %ecx 
	movl %ecx, 0x3c(%edx) 
	popl %ecx 
	movl %ecx, 0x20(%edx) 
	pushl %ebx 
	pushl %ecx 
	pushl %esi 
	pushl %edi 
	pushfl 
	movl %cr3, %eax 
	pushl %eax 
	pushw %fs 
	pushw %gs 
	pushw %es 
	pushw %ss 
	pushw %cs 
	pushw %ds 
	movl %esp, 0x38(%edx) 
	movl p_tss_next, %edx 
	movl 0x38(%edx), %eax 
	movl %eax, %esp 
	movl p_tss_next, %edx 
	movl 0x04(%edx), %eax 
	movl global_tss, %edx 
	movl %eax, 0x04(%edx) 
	movl p_tss_next, %edx 
	movw 0x08(%edx), %ax 
	movl global_tss, %edx 
	movw %ax, 0x08(%edx) 
	movl p_tss_next, %edx 
	popw %ax 
	 movw %ax, %ds 
	popw %ax 
	popw %ax 
	 movw %ax, %ss 
	popw %ax 
	 movw %ax, %es 
	popw %ax 
	 movw %ax, %gs 
	popw %ax 
	 movw %ax, %fs 
	popl %eax 
	movl %eax, %cr3 
	popfl 
	movl 0x3c(%edx), %eax 
	 movl %eax, %ebp 
	movl next, %eax 
	movl %eax, current 
	popl %edi 
	popl %esi 
	popl %ecx 
	popl %ebx 
	movl 0x20(%edx), %eax 
	pushl %eax 
	ret 
	
# 0 "" 2
#NO_APP
	popl	%ebp
	ret
	.size	schedule_1, .-schedule_1
	.globl	schedule
	.type	schedule, @function
schedule:
	movl	schedule_off, %eax
	testl	%eax, %eax
	jne	.L14
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
#APP
# 72 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	pushfl 
	popl %eax 
	cli 
	
# 0 "" 2
#NO_APP
	movl	%eax, %ebx
	movl	current_node, %eax
	movl	8(%eax), %edx
	movl	%edx, current
	incl	116(%edx)
	movl	(%eax), %edx
	movl	8(%edx), %eax
	movl	%eax, next
	movl	%edx, current_node
	incl	proc_switch_count
	movb	$72, %al
#APP
# 25 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	outb %al, $233
# 0 "" 2
# 25 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	outb %al, $233
# 0 "" 2
#NO_APP
	call	schedule_1
	andb	$2, %bh
	je	.L5
#APP
# 85 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	sti
# 0 "" 2
#NO_APP
.L5:
	popl	%ebx
	popl	%ebp
.L14:
	ret
	.size	schedule, .-schedule
	.comm	num_procs,4,4
	.comm	schedule_off,4,4
	.comm	proc_switch_count,4,4
	.comm	p_new_esp0,4,4
	.comm	p_tss_next,4,4
	.comm	p_tss_current,4,4
	.comm	next_node,4,4
	.comm	current_node,4,4
	.comm	next,4,4
	.comm	current,4,4
	.comm	process_node_list_head,4,4
	.comm	global_tss,4,4
	.comm	_usercode_phys,4,4
	.ident	"GCC: (GNU) 4.8.2 20140120 (Red Hat 4.8.2-15)"
	.section	.note.GNU-stack,"",@progbits
