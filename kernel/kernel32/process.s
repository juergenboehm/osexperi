	.file	"process.c"
#APP
	.code16gcc	

	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"error: can not get new pid. all slots full.\n"
.LC1:
	.string	"get_new_pid: pidbuf = %08x pid_index = %d\n"
#NO_APP
	.text
	.globl	get_new_pid
	.type	get_new_pid, @function
get_new_pid:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$28, %esp
	movl	pid_index, %eax
	movl	$32, %edx
	movl	$1, %esi
.L2:
	movl	%eax, %ebx
	shrl	$3, %ebx
	movb	pidbuf(%ebx), %cl
	movb	%cl, -25(%ebp)
	movl	%eax, %edi
	andl	$7, %edi
	movl	%edi, %ecx
	movl	%esi, %edi
	sall	%cl, %edi
	movl	%edi, %ecx
	testb	%cl, -25(%ebp)
	je	.L13
	incl	%eax
	cmpl	$32, %eax
	jne	.L3
	movl	$1, %eax
.L3:
	decl	%edx
	jne	.L2
	movl	%eax, pid_index
	subl	$12, %esp
	pushl	$.LC0
	call	printf
	addl	$16, %esp
.L8:
	jmp	.L8
.L13:
	movl	%eax, pid_index
	movb	-25(%ebp), %dl
	orl	%edi, %edx
	movb	%dl, pidbuf(%ebx)
	pushl	%edx
	pushl	%eax
	pushl	pidbuf
	pushl	$.LC1
	call	outb_printf
	movl	pid_index, %eax
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	get_new_pid, .-get_new_pid
	.globl	release_pid
	.type	release_pid, @function
release_pid:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %ecx
	movl	%ecx, %edx
	shrl	$3, %edx
	andl	$7, %ecx
	movl	$1, %eax
	sall	%cl, %eax
	notl	%eax
	andb	%al, pidbuf(%edx)
	popl	%ebp
	ret
	.size	release_pid, .-release_pid
	.section	.rodata.str1.1
.LC2:
	.string	"kernel32/process.c"
.LC3:
	.string	"[Debug: %s:%d]"
.LC4:
	.string	"sizeof(tss_t) = %d\n"
.LC5:
	.string	"sizeof(process_t) = %d\n"
.LC6:
	.string	"End of init_global_tss.\n"
	.text
	.globl	init_global_tss
	.type	init_global_tss, @function
init_global_tss:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp
	pushl	$412
	pushl	$.LC2
	pushl	$.LC3
	call	printf
	popl	%eax
	popl	%edx
	pushl	$104
	pushl	$.LC4
	call	printf
	addl	$12, %esp
	pushl	$413
	pushl	$.LC2
	pushl	$.LC3
	call	printf
	popl	%ecx
	popl	%eax
	pushl	$8192
	pushl	$.LC5
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
# 421 "kernel32/process.c" 1
	movw $80, %ax 
	 ltr %ax
# 0 "" 2
#NO_APP
	addl	$12, %esp
	pushl	$423
	pushl	$.LC2
	pushl	$.LC3
	call	printf
	movl	$.LC6, (%esp)
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
# 444 "kernel32/process.c" 1
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
# 456 "kernel32/process.c" 1
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
.LC7:
	.string	"schedule: current is 0.\n"
	.text
	.globl	schedule
	.type	schedule, @function
schedule:
	movl	schedule_off, %eax
	testl	%eax, %eax
	jne	.L41
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
	jne	.L25
	subl	$12, %esp
	pushl	$.LC7
	call	outb_printf
	movl	global_proc_list, %eax
	movl	%eax, current_node
	addl	$16, %esp
	jmp	.L26
.L25:
	movl	current_node, %eax
	movl	8(%eax), %eax
	movl	%eax, current
	incl	116(%eax)
.L26:
	movl	current_node, %eax
.L28:
	movl	(%eax), %eax
	movl	8(%eax), %ecx
	testl	$-3, 120(%ecx)
	jne	.L28
	movl	%eax, current_node
	movl	%ecx, next
	movl	current, %edx
	testl	%edx, %edx
	je	.L29
	cmpl	$2, 120(%edx)
	jne	.L29
	movl	$0, 120(%edx)
.L29:
	movl	$2, 120(%ecx)
	incl	proc_switch_count
	testl	%edx, %edx
	je	.L30
	call	schedule_1
	jmp	.L31
.L30:
	call	schedule_2
.L31:
	andb	$2, %bh
	je	.L22
#APP
# 94 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	sti
# 0 "" 2
#NO_APP
.L22:
	movl	-4(%ebp), %ebx
	leave
.L41:
	ret
	.size	schedule, .-schedule
	.section	.rodata.str1.1
.LC8:
	.string	"pir = %08x\n"
.LC9:
	.string	"pir->ss = %08x\n"
.LC10:
	.string	"pir->esp = %08x\n"
.LC11:
	.string	"pir->eflags = %08x\n"
.LC12:
	.string	"pir->cs = %08x\n"
.LC13:
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
	pushl	$.LC8
	call	outb_printf
	popl	%eax
	popl	%edx
	movzwl	16(%ebx), %eax
	pushl	%eax
	pushl	$.LC9
	call	outb_printf
	popl	%ecx
	popl	%eax
	pushl	12(%ebx)
	pushl	$.LC10
	call	outb_printf
	popl	%eax
	popl	%edx
	pushl	8(%ebx)
	pushl	$.LC11
	call	outb_printf
	popl	%ecx
	popl	%eax
	movzwl	4(%ebx), %eax
	pushl	%eax
	pushl	$.LC12
	call	outb_printf
	popl	%eax
	popl	%edx
	pushl	(%ebx)
	pushl	$.LC13
	call	outb_printf
	addl	$16, %esp
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	print_iret_blk, .-print_iret_blk
	.section	.rodata.str1.1
.LC14:
	.string	"\n"
.LC15:
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
	pushl	$.LC14
	call	outb_printf
	popl	%eax
	popl	%edx
	pushl	%ebx
	pushl	$.LC15
	call	outb_printf
	leal	36(%ebx), %esi
	movl	%esi, (%esp)
	call	print_iret_blk
	addl	$16, %esp
	testb	$3, 40(%ebx)
	je	.L44
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
.L44:
	leal	-8(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	call_user_handler, .-call_user_handler
	.section	.rodata.str1.1
.LC16:
	.string	"freeing page_directory = %08x\n"
	.text
	.globl	free_page_directory
	.type	free_page_directory, @function
free_page_directory:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	8(%ebp), %esi
	movl	12(%ebp), %ebx
	pushl	%eax
	pushl	$603
	pushl	$.LC2
	pushl	$.LC3
	call	outb_printf
	popl	%edx
	popl	%ecx
	pushl	%ebx
	pushl	$.LC16
	call	outb_printf
	addl	$16, %esp
	cmpl	current, %esi
	jne	.L51
	subl	$12, %esp
	movl	global_page_dir_sys, %eax
	addl	$1073741824, %eax
	pushl	%eax
	call	set_cr3
	addl	$16, %esp
.L51:
	movl	%ebx, 8(%ebp)
	leal	-8(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	jmp	free
	.size	free_page_directory, .-free_page_directory
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
.L55:
	subl	$12, %esp
	pushl	%ebx
	call	free_page_table
	addl	$4, %ebx
	addl	$16, %esp
	cmpl	-28(%ebp), %ebx
	jne	.L55
	pushl	%eax
	pushl	%eax
	pushl	%edi
	pushl	%esi
	call	free_page_directory
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
.LC17:
	.string	"takes proc %08x out of global proc list.\n"
.LC18:
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
	je	.L60
	movl	%eax, %ebx
.L65:
	cmpl	%edx, 8(%ebx)
	jne	.L61
	pushl	%esi
	pushl	$646
	pushl	$.LC2
	pushl	$.LC3
	call	outb_printf
	popl	%eax
	popl	%edx
	pushl	8(%ebx)
	pushl	$.LC17
	call	outb_printf
	movl	global_proc_list, %edx
	movl	4(%edx), %eax
	addl	$16, %esp
	cmpl	%edx, %ebx
	jne	.L62
	cmpl	%eax, %ebx
	jne	.L63
	movl	$0, global_proc_list
	jmp	.L64
.L63:
	movl	(%ebx), %edx
	movl	%edx, (%eax)
	movl	(%ebx), %edx
	movl	%eax, 4(%edx)
	movl	%edx, global_proc_list
	jmp	.L64
.L62:
	movl	4(%ebx), %eax
	movl	(%ebx), %edx
	movl	%edx, (%eax)
	movl	(%ebx), %edx
	movl	%eax, 4(%edx)
.L64:
	subl	$12, %esp
	pushl	%ebx
	call	free_process_node_t
	addl	$16, %esp
	jmp	.L60
.L61:
	movl	(%ebx), %ebx
	cmpl	%eax, %ebx
	jne	.L65
.L60:
	movl	global_proc_list, %ebx
	xorl	%esi, %esi
	testl	%ebx, %ebx
.L75:
	je	.L59
.L72:
	pushl	%eax
	pushl	$664
	pushl	$.LC2
	pushl	$.LC3
	call	outb_printf
	popl	%edx
	popl	%ecx
	movl	8(%ebx), %eax
	pushl	112(%eax)
	pushl	$.LC18
	call	outb_printf
	movl	(%ebx), %ebx
	incl	%esi
	addl	$16, %esp
	cmpl	$7, %esi
	jle	.L72
	cmpl	global_proc_list, %ebx
	jmp	.L75
.L59:
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
	jne	.L77
	movl	%eax, global_free_proc_list
	movl	%eax, (%eax)
	movl	%eax, 4(%eax)
	jmp	.L76
.L77:
	movl	4(%edx), %ecx
	movl	%eax, 4(%edx)
	movl	%edx, (%eax)
	movl	%ecx, 4(%eax)
	movl	%eax, (%ecx)
	movl	%eax, global_free_proc_list
.L76:
	leave
	ret
	.size	free_process_block, .-free_process_block
	.section	.rodata.str1.1
.LC19:
	.string	"destroy_process: current = %08x proc = %08x\n"
	.text
	.globl	destroy_process
	.type	destroy_process, @function
destroy_process:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$32, %esp
	movl	8(%ebp), %ebx
	pushl	%ebx
	pushl	current
	pushl	$.LC19
	call	outb_printf
#APP
# 72 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	pushfl 
	popl %eax 
	cli 
	
# 0 "" 2
#NO_APP
	movl	%eax, %esi
	movl	$4, 120(%ebx)
	movl	112(%ebx), %edi
	movl	%ebx, (%esp)
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
	movl	%edi, (%esp)
	call	release_pid
	addl	$16, %esp
	andl	$512, %esi
	je	.L81
#APP
# 94 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	sti
# 0 "" 2
#NO_APP
.L81:
	cmpl	%ebx, current
	jne	.L80
	movl	$0, current
#APP
# 60 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	sti
# 0 "" 2
#NO_APP
	movb	$68, %al
.L84:
#APP
# 25 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	outb %al, $233
# 0 "" 2
#NO_APP
	movl	$32768, %edx
.L85:
	movl	$0, -28(%ebp)
	decl	%edx
	jne	.L85
	jmp	.L84
.L80:
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	destroy_process, .-destroy_process
	.globl	exit_process
	.type	exit_process, @function
exit_process:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	pushl	current
	call	destroy_process
	addl	$16, %esp
	leave
	ret
	.size	exit_process, .-exit_process
	.globl	process_signals
	.type	process_signals, @function
process_signals:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %ecx
	movl	current, %eax
	testl	%eax, %eax
	je	.L92
	cmpl	$0, 132(%eax)
	je	.L92
	movl	128(%eax), %edx
	cmpl	$999, %edx
	jne	.L94
	movl	%eax, 8(%ebp)
	leave
	jmp	exit_process
.L94:
	movl	124(%eax), %eax
	testl	%eax, %eax
	je	.L92
	subl	$4, %esp
	pushl	%edx
	pushl	%eax
	pushl	%ecx
	call	call_user_handler
	addl	$16, %esp
.L92:
	leave
	ret
	.size	process_signals, .-process_signals
	.section	.rodata.str1.1
.LC20:
	.string	"clone_file_t: sizeof(file_t) = %d\n"
.LC21:
	.string	"clone_file_t: after memcpy.\n"
.LC22:
	.string	"clone_file_t: leave clone_file_t.\n"
	.text
	.globl	clone_file_t
	.type	clone_file_t, @function
clone_file_t:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$16, %esp
	movl	8(%ebp), %esi
	movl	12(%ebp), %edi
	pushl	$721
	pushl	$.LC2
	pushl	$.LC3
	call	outb_printf
	popl	%edx
	popl	%ecx
	pushl	$28
	pushl	$.LC20
	call	outb_printf
	addl	$16, %esp
	testl	%esi, %esi
	jne	.L103
	movl	$0, (%edi)
	jmp	.L104
.L103:
	call	get_file_t
	movl	%eax, %ebx
	pushl	%eax
	pushl	$28
	pushl	%esi
	pushl	%ebx
	call	memcpy
	addl	$12, %esp
	pushl	$733
	pushl	$.LC2
	pushl	$.LC3
	call	outb_printf
	movl	$.LC21, (%esp)
	call	outb_printf
	movl	12(%esi), %eax
	movl	%eax, 12(%ebx)
	movl	$0, 24(%ebx)
	movl	%ebx, (%edi)
	addl	$12, %esp
	pushl	$741
	pushl	$.LC2
	pushl	$.LC3
	call	outb_printf
	movl	$.LC22, (%esp)
	call	outb_printf
	addl	$16, %esp
.L104:
	xorl	%eax, %eax
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	clone_file_t, .-clone_file_t
	.globl	clone_proc_t
	.type	clone_proc_t, @function
clone_proc_t:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%edx
	call	get_process_t
	movl	%eax, %ebx
	testl	%eax, %eax
	je	.L108
	pushl	%eax
	pushl	$8192
	pushl	8(%ebp)
	pushl	%ebx
	call	memcpy
	movl	12(%ebp), %eax
	movl	%ebx, (%eax)
	addl	$16, %esp
	xorl	%eax, %eax
	jmp	.L107
.L108:
	orl	$-1, %eax
.L107:
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	clone_proc_t, .-clone_proc_t
	.globl	clone_proc_io_block_t
	.type	clone_proc_io_block_t, @function
clone_proc_io_block_t:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$12, %esp
	call	get_proc_io_block_t
	movl	%eax, %edi
	movl	%eax, %esi
	xorl	%ebx, %ebx
.L113:
	pushl	%eax
	pushl	%eax
	pushl	%esi
	movl	8(%ebp), %eax
	pushl	(%eax,%ebx,4)
	call	clone_file_t
	movl	(%esi), %edx
	addl	$16, %esp
	testl	%edx, %edx
	je	.L111
	incl	24(%edx)
.L111:
	incl	%ebx
	addl	$4, %esi
	cmpl	$16, %ebx
	jne	.L113
	movl	12(%ebp), %eax
	movl	%edi, (%eax)
	xorl	%eax, %eax
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	clone_proc_io_block_t, .-clone_proc_io_block_t
	.globl	build_artificial_switch_save_block
	.type	build_artificial_switch_save_block, @function
build_artificial_switch_save_block:
	pushl	%ebp
	movl	%esp, %ebp
	movl	28(%ebp), %eax
	leal	-36(%eax), %edx
#APP
# 126 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	movw %ds, %cx
# 0 "" 2
#NO_APP
	movw	%cx, -36(%eax)
#APP
# 119 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	movw %cs, %ax
# 0 "" 2
#NO_APP
	movw	%ax, 2(%edx)
#APP
# 154 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	movw %ss, %ax
# 0 "" 2
#NO_APP
	movw	%ax, 4(%edx)
#APP
# 133 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	movw %es, %ax
# 0 "" 2
#NO_APP
	movw	%ax, 6(%edx)
#APP
# 140 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	movw %fs, %ax
# 0 "" 2
#NO_APP
	movw	%ax, 10(%edx)
#APP
# 147 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	movw %gs, %ax
# 0 "" 2
#NO_APP
	movw	%ax, 8(%edx)
	movl	24(%ebp), %eax
	movl	%eax, 12(%edx)
#APP
# 83 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	pushfl 
	popl %eax 
	
# 0 "" 2
#NO_APP
	orb	$2, %ah
	movl	%eax, 16(%edx)
	movl	20(%ebp), %eax
	movl	%eax, 20(%edx)
	movl	16(%ebp), %eax
	movl	%eax, 24(%edx)
	movl	12(%ebp), %eax
	movl	%eax, 28(%edx)
	movl	8(%ebp), %eax
	movl	%eax, 32(%edx)
	movl	32(%ebp), %eax
	movl	%edx, (%eax)
	popl	%ebp
	ret
	.size	build_artificial_switch_save_block, .-build_artificial_switch_save_block
	.section	.rodata.str1.1
.LC23:
	.string	"fork_process start: current = %08x"
.LC24:
	.string	"fork_process renew: ret_eip = %08x, old_bp = %08x\n"
.LC25:
	.string	"proc_t cloned.\n"
.LC26:
	.string	"before prepare fork_stack...\n"
.LC27:
	.string	"ret eip = %08x, old_bp = %08x\n"
.LC28:
	.string	"leaving fork parent.\n"
	.text
	.globl	fork_process
	.type	fork_process, @function
fork_process:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$48, %esp
	pushl	$819
	pushl	$.LC2
	pushl	$.LC3
	call	outb_printf
	popl	%esi
	popl	%edi
	pushl	current
	pushl	$.LC23
	call	outb_printf
	movl	current, %esi
#APP
# 72 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	pushfl 
	popl %eax 
	cli 
	
# 0 "" 2
#NO_APP
	movl	%eax, -48(%ebp)
	addl	$12, %esp
	pushl	$1
	leal	-40(%ebp), %eax
	pushl	%eax
	pushl	%esi
	call	copy_page_tables
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L122
	pushl	%ebx
	pushl	%ebx
	leal	-36(%ebp), %eax
	pushl	%eax
	pushl	%esi
	call	clone_proc_t
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L122
	movl	-36(%ebp), %ecx
	leal	8116(%ecx), %edi
	movl	%ecx, -52(%ebp)
	movl	8120(%ecx), %ebx
	pushl	%edx
	pushl	$862
	pushl	$.LC2
	pushl	$.LC3
	call	outb_printf
	addl	$12, %esp
	pushl	%edi
	pushl	%ebx
	pushl	$.LC24
	call	outb_printf
	addl	$12, %esp
	pushl	$865
	pushl	$.LC2
	pushl	$.LC3
	call	outb_printf
	movl	$.LC25, (%esp)
	call	outb_printf
	popl	%ecx
	popl	%eax
	leal	-32(%ebp), %eax
	pushl	%eax
	pushl	108(%esi)
	call	clone_proc_io_block_t
	movl	-32(%ebp), %esi
	movl	-36(%ebp), %eax
	movl	%esi, 108(%eax)
	call	get_new_pid
	movl	%eax, -44(%ebp)
	addl	$12, %esp
	pushl	$0
	pushl	%eax
	pushl	-36(%ebp)
	call	init_proc_basic
	movl	-36(%ebp), %eax
	movl	$0, 120(%eax)
	popl	%edx
	popl	%ecx
	pushl	-40(%ebp)
	pushl	%eax
	call	init_proc_cr3
	movl	-36(%ebp), %eax
	movl	$0, 8164(%eax)
	leal	8192(%eax), %esi
	movl	%esi, 4(%eax)
	movw	$40, 8(%eax)
	movw	$40, 80(%eax)
	movl	$0, 60(%eax)
	addl	$12, %esp
	pushl	$903
	pushl	$.LC2
	pushl	$.LC3
	call	outb_printf
	movl	$.LC26, (%esp)
	call	outb_printf
	addl	$12, %esp
	leal	-28(%ebp), %eax
	pushl	%eax
	movl	-52(%ebp), %ecx
	addl	$8124, %ecx
	pushl	%ecx
	pushl	-40(%ebp)
	pushl	$0
	pushl	$0
	pushl	$0
	pushl	$0
	call	build_artificial_switch_save_block
	movl	-36(%ebp), %eax
	movl	-28(%ebp), %ecx
	movl	%ecx, 56(%eax)
	addl	$28, %esp
	pushl	$0
	pushl	%ebx
	pushl	%eax
	call	init_proc_eip
	addl	$12, %esp
	pushl	$916
	pushl	$.LC2
	pushl	$.LC3
	call	outb_printf
	addl	$12, %esp
	pushl	%edi
	pushl	%ebx
	pushl	$.LC27
	call	outb_printf
	call	get_process_node_t
	movl	-36(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	global_proc_list, %edx
	addl	$16, %esp
	testl	%edx, %edx
	jne	.L124
	movl	%eax, global_proc_list
	movl	%eax, (%eax)
	movl	%eax, 4(%eax)
	jmp	.L122
.L124:
	movl	4(%edx), %ecx
	movl	%eax, 4(%edx)
	movl	%edx, (%eax)
	movl	%ecx, 4(%eax)
	movl	%eax, (%ecx)
	movl	%eax, global_proc_list
.L122:
	pushl	%eax
	pushl	$926
	pushl	$.LC2
	pushl	$.LC3
	call	outb_printf
	movl	$.LC28, (%esp)
	call	outb_printf
	addl	$16, %esp
	testl	$512, -48(%ebp)
	je	.L125
#APP
# 94 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	sti
# 0 "" 2
#NO_APP
.L125:
	movl	-44(%ebp), %eax
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	fork_process, .-fork_process
	.local	pid_index
	.comm	pid_index,4,4
	.comm	pidbuf,4,4
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
