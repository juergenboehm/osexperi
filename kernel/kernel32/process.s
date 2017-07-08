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
	pushl	$374
	pushl	$.LC0
	pushl	$.LC1
	call	printf
	popl	%eax
	popl	%edx
	pushl	$104
	pushl	$.LC2
	call	printf
	addl	$12, %esp
	pushl	$375
	pushl	$.LC0
	pushl	$.LC1
	call	printf
	popl	%ecx
	popl	%eax
	pushl	$8192
	pushl	$.LC3
	call	printf
	call	get_tss_t
	movl	%eax, global_tss
	movb	$0, gdt_table_32+86
	movw	%ax, gdt_table_32+82
	movl	%eax, %edx
	shrl	$16, %edx
	movb	%dl, gdt_table_32+84
	shrl	$24, %eax
	movb	%al, gdt_table_32+87
	movw	$8191, gdt_table_32+80
	movb	$-119, gdt_table_32+85
#APP
# 383 "kernel32/process.c" 1
	movw $80, %ax 
	 ltr %ax
# 0 "" 2
#NO_APP
	addl	$12, %esp
	pushl	$385
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
# 406 "kernel32/process.c" 1
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
	.globl	schedule_2
	.type	schedule_2, @function
schedule_2:
	pushl	%ebp
	movl	%esp, %ebp
	movl	next, %eax
	movl	%eax, p_tss_next
#APP
# 418 "kernel32/process.c" 1
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
	.size	schedule_2, .-schedule_2
	.section	.rodata.str1.1
.LC5:
	.string	"schedule: current is 0.\n"
	.text
	.globl	schedule
	.type	schedule, @function
schedule:
	movl	schedule_off, %eax
	testl	%eax, %eax
	jne	.L26
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%eax
#APP
# 72 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	pushfl 
	popl %eax 
	cli 
	
# 0 "" 2
#NO_APP
	movl	%eax, %ebx
	cmpl	$0, current
	jne	.L10
	subl	$12, %esp
	pushl	$.LC5
	call	outb_printf
	movl	global_proc_list, %eax
	movl	(%eax), %eax
	movl	%eax, current_node
	addl	$16, %esp
	jmp	.L11
.L10:
	movl	current_node, %eax
	movl	8(%eax), %eax
	movl	%eax, current
	incl	116(%eax)
.L11:
	movl	current_node, %eax
.L13:
	movl	(%eax), %eax
	movl	8(%eax), %ecx
	testl	$-3, 120(%ecx)
	jne	.L13
	movl	%eax, current_node
	movl	%ecx, next
	movl	current, %edx
	testl	%edx, %edx
	je	.L14
	cmpl	$2, 120(%edx)
	jne	.L14
	movl	$0, 120(%edx)
.L14:
	movl	$2, 120(%ecx)
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
	testl	%edx, %edx
	je	.L15
	call	schedule_1
	jmp	.L16
.L15:
	call	schedule_2
.L16:
	andb	$2, %bh
	je	.L7
#APP
# 85 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	sti
# 0 "" 2
#NO_APP
.L7:
	movl	-4(%ebp), %ebx
	leave
.L26:
	ret
	.size	schedule, .-schedule
	.section	.rodata.str1.1
.LC6:
	.string	"pir = %08x\n"
.LC7:
	.string	"pir->ss = %08x\n"
.LC8:
	.string	"pir->esp = %08x\n"
.LC9:
	.string	"pir->eflags = %08x\n"
.LC10:
	.string	"pir->cs = %08x\n"
.LC11:
	.string	"pir->eip = %08x\n"
	.text
	.globl	print_iret_blk
	.type	print_iret_blk, @function
print_iret_blk:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$12, %esp
	movl	8(%ebp), %ebx
	pushl	%ebx
	pushl	$.LC6
	call	outb_printf
	popl	%eax
	popl	%edx
	movzwl	16(%ebx), %eax
	pushl	%eax
	pushl	$.LC7
	call	outb_printf
	popl	%ecx
	popl	%eax
	pushl	12(%ebx)
	pushl	$.LC8
	call	outb_printf
	popl	%eax
	popl	%edx
	pushl	8(%ebx)
	pushl	$.LC9
	call	outb_printf
	popl	%ecx
	popl	%eax
	movzwl	4(%ebx), %eax
	pushl	%eax
	pushl	$.LC10
	call	outb_printf
	popl	%eax
	popl	%edx
	pushl	(%ebx)
	pushl	$.LC11
	call	outb_printf
	addl	$16, %esp
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	print_iret_blk, .-print_iret_blk
	.section	.rodata.str1.1
.LC12:
	.string	"\n"
.LC13:
	.string	"call_user_handler: esp = %08x\n"
	.text
	.globl	call_user_handler
	.type	call_user_handler, @function
call_user_handler:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	8(%ebp), %ebx
	subl	$12, %esp
	pushl	$.LC12
	call	outb_printf
	popl	%eax
	popl	%edx
	pushl	%ebx
	pushl	$.LC13
	call	outb_printf
	leal	36(%ebx), %esi
	movl	%esi, (%esp)
	call	print_iret_blk
	addl	$16, %esp
	testb	$3, 40(%ebx)
	je	.L30
	movl	current, %eax
	movl	$0, 132(%eax)
	movl	48(%ebx), %eax
	movl	16(%ebp), %edx
	movl	%edx, -4(%eax)
	movl	36(%ebx), %edx
	movl	%edx, -8(%eax)
	subl	$8, %eax
	movl	%eax, 48(%ebx)
	movl	12(%ebp), %eax
	movl	%eax, 36(%ebx)
.L30:
	leal	-8(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	call_user_handler, .-call_user_handler
	.globl	free_user_memory
	.type	free_user_memory, @function
free_user_memory:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$28, %esp
	movl	8(%ebp), %esi
	movl	28(%esi), %eax
	leal	-1073741824(%eax), %edi
	subl	$1073738752, %eax
	movl	%eax, -28(%ebp)
	movl	%edi, %ebx
.L38:
	subl	$12, %esp
	pushl	%ebx
	call	free_page_table
	addl	$4, %ebx
	addl	$16, %esp
	cmpl	-28(%ebp), %ebx
	jne	.L38
	subl	$12, %esp
	pushl	%edi
	call	free_page_directory
#APP
# 96 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	movl %cr3, %eax
# 0 "" 2
#NO_APP
	movl	%eax, 28(%esi)
	addl	$16, %esp
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	free_user_memory, .-free_user_memory
	.globl	destroy_io_data
	.type	destroy_io_data, @function
destroy_io_data:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	movl	108(%eax), %eax
	movl	%eax, 8(%ebp)
	popl	%ebp
	jmp	free_proc_io_block_t
	.size	destroy_io_data, .-destroy_io_data
	.section	.rodata.str1.1
.LC14:
	.string	"takes proc %08x out of global proc list.\n"
.LC15:
	.string	"take_out: pid = %d\n"
	.text
	.globl	take_out_of_global_proc_list
	.type	take_out_of_global_proc_list, @function
take_out_of_global_proc_list:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	8(%ebp), %edx
	movl	global_proc_list, %eax
	testl	%eax, %eax
	je	.L43
	movl	%eax, %ebx
.L48:
	cmpl	%edx, 8(%ebx)
	jne	.L44
	pushl	%esi
	pushl	$588
	pushl	$.LC0
	pushl	$.LC1
	call	outb_printf
	popl	%eax
	popl	%edx
	pushl	8(%ebx)
	pushl	$.LC14
	call	outb_printf
	movl	global_proc_list, %edx
	movl	4(%edx), %eax
	addl	$16, %esp
	cmpl	%edx, %ebx
	jne	.L45
	cmpl	%eax, %ebx
	jne	.L46
	movl	$0, global_proc_list
	jmp	.L47
.L46:
	movl	(%ebx), %edx
	movl	%edx, (%eax)
	movl	(%ebx), %edx
	movl	%eax, 4(%edx)
	movl	%edx, global_proc_list
	jmp	.L47
.L45:
	movl	4(%ebx), %eax
	movl	(%ebx), %edx
	movl	%edx, (%eax)
	movl	(%ebx), %edx
	movl	%eax, 4(%edx)
.L47:
	subl	$12, %esp
	pushl	%ebx
	call	free_process_node_t
	addl	$16, %esp
	jmp	.L43
.L44:
	movl	(%ebx), %ebx
	cmpl	%eax, %ebx
	jne	.L48
.L43:
	movl	global_proc_list, %ebx
	xorl	%esi, %esi
	testl	%ebx, %ebx
.L58:
	je	.L42
.L55:
	pushl	%eax
	pushl	$606
	pushl	$.LC0
	pushl	$.LC1
	call	outb_printf
	popl	%edx
	popl	%ecx
	movl	8(%ebx), %eax
	pushl	112(%eax)
	pushl	$.LC15
	call	outb_printf
	movl	(%ebx), %ebx
	incl	%esi
	addl	$16, %esp
	cmpl	$7, %esi
	jle	.L55
	cmpl	global_proc_list, %ebx
	jmp	.L58
.L42:
	leal	-8(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	take_out_of_global_proc_list, .-take_out_of_global_proc_list
	.globl	free_process_block
	.type	free_process_block, @function
free_process_block:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	call	get_process_node_t
	movl	8(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	global_free_proc_list, %edx
	testl	%edx, %edx
	jne	.L60
	movl	%eax, global_free_proc_list
	movl	%eax, (%eax)
	movl	%eax, 4(%eax)
	jmp	.L59
.L60:
	movl	4(%edx), %ecx
	movl	%eax, 4(%edx)
	movl	%edx, (%eax)
	movl	%ecx, 4(%eax)
	movl	%eax, (%ecx)
	movl	%eax, global_free_proc_list
.L59:
	leave
	ret
	.size	free_process_block, .-free_process_block
	.globl	destroy_process
	.type	destroy_process, @function
destroy_process:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$32, %esp
	movl	8(%ebp), %ebx
	movl	$4, 120(%ebx)
	pushl	%ebx
	call	free_user_memory
	movl	%ebx, (%esp)
	call	destroy_io_data
	movl	%ebx, (%esp)
	call	take_out_of_global_proc_list
	movl	%ebx, (%esp)
	call	remove_from_wait_queues
	movl	%ebx, (%esp)
	call	release_sync_primitives
	movl	%ebx, (%esp)
	call	free_process_block
	movl	$0, current
#APP
# 60 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	sti
# 0 "" 2
#NO_APP
	addl	$16, %esp
	movb	$68, %al
.L65:
#APP
# 25 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	outb %al, $233
# 0 "" 2
#NO_APP
	movl	$32768, %edx
.L66:
	movl	$0, -12(%ebp)
	decl	%edx
	jne	.L66
	jmp	.L65
	.size	destroy_process, .-destroy_process
	.globl	exit_process
	.type	exit_process, @function
exit_process:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	pushl	current
	call	destroy_process
	.size	exit_process, .-exit_process
	.globl	process_signals
	.type	process_signals, @function
process_signals:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	current, %eax
	testl	%eax, %eax
	je	.L70
	cmpl	$0, 132(%eax)
	je	.L70
	movl	128(%eax), %edx
	cmpl	$999, %edx
	jne	.L72
	subl	$12, %esp
	pushl	%eax
	call	exit_process
.L72:
	movl	124(%eax), %eax
	testl	%eax, %eax
	je	.L70
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	pushl	8(%ebp)
	call	call_user_handler
	addl	$16, %esp
.L70:
	leave
	ret
	.size	process_signals, .-process_signals
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
	.comm	global_free_proc_list,4,4
	.comm	global_proc_list,4,4
	.comm	global_tss,4,4
	.comm	_usercode_phys,4,4
	.ident	"GCC: (GNU) 4.8.2 20140120 (Red Hat 4.8.2-15)"
	.section	.note.GNU-stack,"",@progbits
