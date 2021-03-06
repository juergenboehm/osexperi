	.file	"process.c"
	.comm	global_in_de_hash_headers,2164,32
	.comm	global_in_de_lru_list,4,4
/APP
	.code16gcc	

/NO_APP
	.text
	.type	outb, @function
outb:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	movw	%dx, -4(%ebp)
	movb	%al, -8(%ebp)
	movzwl	-4(%ebp), %edx
	movzbl	-8(%ebp), %eax
/APP
/  25 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	outb %al, %dx
/  0 "" 2
/NO_APP
	leave
	ret
	.size	outb, .-outb
	.type	sti, @function
sti:
	pushl	%ebp
	movl	%esp, %ebp
/APP
/  60 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	sti
/  0 "" 2
/NO_APP
	popl	%ebp
	ret
	.size	sti, .-sti
	.type	irq_cli_save, @function
irq_cli_save:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
/APP
/  72 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	pushfl 
	popl %eax 
	cli 
	
/  0 "" 2
/NO_APP
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	leave
	ret
	.size	irq_cli_save, .-irq_cli_save
	.type	get_eflags, @function
get_eflags:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
/APP
/  83 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	pushfl 
	popl %eax 
	
/  0 "" 2
/NO_APP
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	leave
	ret
	.size	get_eflags, .-get_eflags
	.type	irq_restore, @function
irq_restore:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	andl	$512, %eax
	testl	%eax, %eax
	je	.L7
/APP
/  94 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	sti
/  0 "" 2
/NO_APP
.L7:
	popl	%ebp
	ret
	.size	irq_restore, .-irq_restore
	.type	get_cs, @function
get_cs:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
/APP
/  119 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	movw %cs, %ax
/  0 "" 2
/NO_APP
	movw	%ax, -2(%ebp)
	movzwl	-2(%ebp), %eax
	leave
	ret
	.size	get_cs, .-get_cs
	.type	get_ds, @function
get_ds:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
/APP
/  126 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	movw %ds, %ax
/  0 "" 2
/NO_APP
	movw	%ax, -2(%ebp)
	movzwl	-2(%ebp), %eax
	leave
	ret
	.size	get_ds, .-get_ds
	.type	get_es, @function
get_es:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
/APP
/  133 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	movw %es, %ax
/  0 "" 2
/NO_APP
	movw	%ax, -2(%ebp)
	movzwl	-2(%ebp), %eax
	leave
	ret
	.size	get_es, .-get_es
	.type	get_fs, @function
get_fs:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
/APP
/  140 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	movw %fs, %ax
/  0 "" 2
/NO_APP
	movw	%ax, -2(%ebp)
	movzwl	-2(%ebp), %eax
	leave
	ret
	.size	get_fs, .-get_fs
	.type	get_gs, @function
get_gs:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
/APP
/  147 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	movw %gs, %ax
/  0 "" 2
/NO_APP
	movw	%ax, -2(%ebp)
	movzwl	-2(%ebp), %eax
	leave
	ret
	.size	get_gs, .-get_gs
	.type	get_ss, @function
get_ss:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
/APP
/  154 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	movw %ss, %ax
/  0 "" 2
/NO_APP
	movw	%ax, -2(%ebp)
	movzwl	-2(%ebp), %eax
	leave
	ret
	.size	get_ss, .-get_ss
	.comm	_usercode_phys,4,4
	.comm	global_tss,4,4
	.comm	global_proc_list,4,4
	.comm	global_free_proc_list,4,4
	.comm	current,4,4
	.comm	next,4,4
	.comm	current_node,4,4
	.comm	next_node,4,4
	.comm	p_tss_current,4,4
	.comm	p_tss_next,4,4
	.comm	p_new_esp0,4,4
	.comm	proc_switch_count,4,4
	.comm	schedule_off,4,4
	.comm	num_procs,4,4
	.comm	pidbuf,4,1
	.local	pid_index
	.comm	pid_index,4,4
	.section	.rodata
	.align 4
.LC0:
	.string	"error: can not get new pid. all slots full.\n"
	.align 4
.LC1:
	.string	"get_new_pid: pidbuf = %08x pid_index = %d\n"
	.text
	.globl	get_new_pid
	.type	get_new_pid, @function
get_new_pid:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$32, %esp
	movl	$0, -12(%ebp)
	jmp	.L22
.L25:
	movl	pid_index, %eax
	addl	$1, %eax
	movl	%eax, pid_index
	addl	$1, -12(%ebp)
	movl	pid_index, %eax
	cmpl	$32, %eax
	jne	.L23
	movl	$1, pid_index
.L23:
	cmpl	$31, -12(%ebp)
	jle	.L22
	jmp	.L24
.L22:
	movl	pid_index, %eax
	shrl	$3, %eax
	movzbl	pidbuf(%eax), %edx
	movl	pid_index, %eax
	andl	$7, %eax
	movl	$1, %ebx
	movl	%eax, %ecx
	sall	%cl, %ebx
	movl	%ebx, %eax
	andl	%edx, %eax
	testb	%al, %al
	jne	.L25
.L24:
	cmpl	$31, -12(%ebp)
	jle	.L26
	movl	$.LC0, (%esp)
	call	printf
.L27:
	jmp	.L27
.L26:
	movl	pid_index, %eax
	shrl	$3, %eax
	movl	%eax, %edx
	movl	pid_index, %eax
	shrl	$3, %eax
	movzbl	pidbuf(%eax), %ebx
	movl	pid_index, %eax
	andl	$7, %eax
	movl	$1, %esi
	movl	%eax, %ecx
	sall	%cl, %esi
	movl	%esi, %eax
	orl	%ebx, %eax
	movb	%al, pidbuf(%edx)
	movl	pid_index, %edx
	movl	$pidbuf, %eax
	movl	(%eax), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$.LC1, (%esp)
	call	outb_printf
	movl	pid_index, %eax
	addl	$32, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	get_new_pid, .-get_new_pid
	.globl	release_pid
	.type	release_pid, @function
release_pid:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	8(%ebp), %eax
	shrl	$3, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	shrl	$3, %eax
	movzbl	pidbuf(%eax), %eax
	movl	8(%ebp), %ecx
	andl	$7, %ecx
	movl	$1, %ebx
	sall	%cl, %ebx
	movl	%ebx, %ecx
	notl	%ecx
	andl	%ecx, %eax
	movb	%al, pidbuf(%edx)
	popl	%ebx
	popl	%ebp
	ret
	.size	release_pid, .-release_pid
	.section	.rodata
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
	subl	$24, %esp
	movl	$412, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	$104, 4(%esp)
	movl	$.LC4, (%esp)
	call	outb_printf
	movl	$413, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	$8192, 4(%esp)
	movl	$.LC5, (%esp)
	call	outb_printf
	call	get_tss_t
	movl	%eax, global_tss
	movw	$0, gdt_table_32+82
	movb	$0, gdt_table_32+84
	movb	$0, gdt_table_32+87
	movw	$0, gdt_table_32+80
	movzbl	gdt_table_32+86, %eax
	andl	$-16, %eax
	movb	%al, gdt_table_32+86
	movzbl	gdt_table_32+86, %eax
	andl	$127, %eax
	movb	%al, gdt_table_32+86
	movzbl	gdt_table_32+86, %eax
	andl	$-65, %eax
	movb	%al, gdt_table_32+86
	movzbl	gdt_table_32+86, %eax
	andl	$-33, %eax
	movb	%al, gdt_table_32+86
	movzbl	gdt_table_32+86, %eax
	andl	$-17, %eax
	movb	%al, gdt_table_32+86
	movzbl	gdt_table_32+85, %eax
	andl	$-17, %eax
	movb	%al, gdt_table_32+85
	movzbl	gdt_table_32+85, %eax
	andl	$127, %eax
	movb	%al, gdt_table_32+85
	movzbl	gdt_table_32+85, %eax
	andl	$-97, %eax
	movb	%al, gdt_table_32+85
	movzbl	gdt_table_32+85, %eax
	andl	$-15, %eax
	movb	%al, gdt_table_32+85
	movl	global_tss, %eax
	movw	%ax, gdt_table_32+82
	movl	global_tss, %eax
	shrl	$16, %eax
	movb	%al, gdt_table_32+84
	movl	global_tss, %eax
	shrl	$24, %eax
	movb	%al, gdt_table_32+87
	movw	$8191, gdt_table_32+80
	movzbl	gdt_table_32+86, %eax
	andl	$-16, %eax
	movb	%al, gdt_table_32+86
	movzbl	gdt_table_32+86, %eax
	andl	$127, %eax
	movb	%al, gdt_table_32+86
	movzbl	gdt_table_32+86, %eax
	andl	$-65, %eax
	movb	%al, gdt_table_32+86
	movzbl	gdt_table_32+86, %eax
	andl	$-33, %eax
	movb	%al, gdt_table_32+86
	movzbl	gdt_table_32+85, %eax
	orl	$-128, %eax
	movb	%al, gdt_table_32+85
	movzbl	gdt_table_32+85, %eax
	andl	$-97, %eax
	movb	%al, gdt_table_32+85
	movzbl	gdt_table_32+85, %eax
	andl	$-17, %eax
	movb	%al, gdt_table_32+85
	movzbl	gdt_table_32+85, %eax
	andl	$-16, %eax
	orl	$9, %eax
	movb	%al, gdt_table_32+85
/APP
/  421 "kernel32/process.c" 1
	movw $80, %ax 
	 ltr %ax
/  0 "" 2
/NO_APP
	movl	$423, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	$.LC6, (%esp)
	call	outb_printf
	movl	$0, %eax
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
/APP
/  444 "kernel32/process.c" 1
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
	
/  0 "" 2
/NO_APP
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
/APP
/  456 "kernel32/process.c" 1
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
	
/  0 "" 2
/NO_APP
	popl	%ebp
	ret
	.size	schedule_2, .-schedule_2
	.section	.rodata
.LC7:
	.string	"schedule: current is 0.\n"
	.text
	.globl	schedule
	.type	schedule, @function
schedule:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	schedule_off, %eax
	testl	%eax, %eax
	je	.L35
	jmp	.L34
.L35:
	call	irq_cli_save
	movl	%eax, -12(%ebp)
	movl	current, %eax
	testl	%eax, %eax
	jne	.L37
	movl	$.LC7, (%esp)
	call	outb_printf
	movl	global_proc_list, %eax
	movl	%eax, current_node
	jmp	.L38
.L37:
	movl	current_node, %eax
	movl	8(%eax), %eax
	movl	%eax, current
	movl	current, %eax
	movl	116(%eax), %edx
	addl	$1, %edx
	movl	%edx, 116(%eax)
.L38:
	movl	current_node, %eax
	movl	(%eax), %eax
	movl	8(%eax), %eax
	movl	%eax, next
	movl	current_node, %eax
	movl	(%eax), %eax
	movl	%eax, current_node
	movl	next, %eax
	movl	120(%eax), %eax
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	je	.L39
	cmpl	$2, -16(%ebp)
	jne	.L38
.L39:
	movl	current, %eax
	testl	%eax, %eax
	je	.L40
	movl	current, %eax
	movl	120(%eax), %eax
	cmpl	$2, %eax
	jne	.L40
	movl	current, %eax
	movl	$0, 120(%eax)
.L40:
	movl	next, %eax
	movl	$2, 120(%eax)
	movl	proc_switch_count, %eax
	addl	$1, %eax
	movl	%eax, proc_switch_count
	movl	current, %eax
	testl	%eax, %eax
	je	.L41
	call	schedule_1
	jmp	.L42
.L41:
	call	schedule_2
.L42:
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	irq_restore
.L34:
	leave
	ret
	.size	schedule, .-schedule
	.globl	process_signals
	.type	process_signals, @function
process_signals:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	current, %eax
	testl	%eax, %eax
	je	.L43
	movl	current, %eax
	movl	132(%eax), %eax
	testl	%eax, %eax
	je	.L43
	movl	current, %eax
	movl	128(%eax), %eax
	cmpl	$999, %eax
	jne	.L45
	movl	current, %eax
	movl	%eax, (%esp)
	call	exit_process
	jmp	.L43
.L45:
	movl	current, %eax
	movl	124(%eax), %eax
	testl	%eax, %eax
	je	.L43
	movl	current, %eax
	movl	128(%eax), %edx
	movl	current, %eax
	movl	124(%eax), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	call_user_handler
.L43:
	leave
	ret
	.size	process_signals, .-process_signals
	.section	.rodata
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
	subl	$24, %esp
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC8, (%esp)
	call	outb_printf
	movl	8(%ebp), %eax
	movzwl	16(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, 4(%esp)
	movl	$.LC9, (%esp)
	call	outb_printf
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC10, (%esp)
	call	outb_printf
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC11, (%esp)
	call	outb_printf
	movl	8(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, 4(%esp)
	movl	$.LC12, (%esp)
	call	outb_printf
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC13, (%esp)
	call	outb_printf
	leave
	ret
	.size	print_iret_blk, .-print_iret_blk
	.section	.rodata
.LC14:
	.string	"\n"
	.align 4
.LC15:
	.string	"call_user_handler: esp = %08x\n"
	.text
	.globl	call_user_handler
	.type	call_user_handler, @function
call_user_handler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$.LC14, (%esp)
	call	outb_printf
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC15, (%esp)
	call	outb_printf
	movl	8(%ebp), %eax
	addl	$36, %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	andl	$3, %eax
	testl	%eax, %eax
	sete	%al
	movzbl	%al, %eax
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	je	.L48
	jmp	.L47
.L48:
	movl	current, %eax
	movl	$0, 132(%eax)
	movl	-12(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, -20(%ebp)
	subl	$4, -20(%ebp)
	movl	-20(%ebp), %eax
	movl	16(%ebp), %edx
	movl	%edx, (%eax)
	subl	$4, -20(%ebp)
	movl	-12(%ebp), %eax
	movl	(%eax), %edx
	movl	-20(%ebp), %eax
	movl	%edx, (%eax)
	movl	-20(%ebp), %edx
	movl	-12(%ebp), %eax
	movl	%edx, 12(%eax)
	movl	-12(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, (%eax)
.L47:
	leave
	ret
	.size	call_user_handler, .-call_user_handler
	.globl	exit_process
	.type	exit_process, @function
exit_process:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	current, %eax
	movl	%eax, (%esp)
	call	destroy_process
	leave
	ret
	.size	exit_process, .-exit_process
	.section	.rodata
	.align 4
.LC16:
	.string	"freeing page_directory = %08x\n"
	.text
	.globl	free_page_directory
	.type	free_page_directory, @function
free_page_directory:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$616, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC16, (%esp)
	call	outb_printf
	movl	current, %eax
	cmpl	%eax, 8(%ebp)
	jne	.L52
	movl	global_page_dir_sys, %eax
	addl	$1073741824, %eax
	movl	%eax, (%esp)
	call	set_cr3
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	free
	jmp	.L51
.L52:
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	free
.L51:
	leave
	ret
	.size	free_page_directory, .-free_page_directory
	.globl	free_user_memory
	.type	free_user_memory, @function
free_user_memory:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	28(%eax), %eax
	subl	$1073741824, %eax
	movl	%eax, -16(%ebp)
	movl	$0, -12(%ebp)
	jmp	.L55
.L56:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	-16(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, (%esp)
	call	free_page_table
	addl	$1, -12(%ebp)
.L55:
	cmpl	$767, -12(%ebp)
	jle	.L56
	movl	-16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	free_page_directory
	leave
	ret
	.size	free_user_memory, .-free_user_memory
	.globl	destroy_io_data
	.type	destroy_io_data, @function
destroy_io_data:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	108(%eax), %eax
	movl	%eax, -16(%ebp)
	movl	$0, -12(%ebp)
	jmp	.L58
.L59:
	movl	-16(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	8(%eax,%edx,4), %eax
	movl	%eax, (%esp)
	call	unlink_file_t
	addl	$1, -12(%ebp)
.L58:
	cmpl	$15, -12(%ebp)
	jle	.L59
	movl	-16(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	unlink_dentry_t
	movl	-16(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, (%esp)
	call	unlink_dentry_t
	movl	8(%ebp), %eax
	movl	108(%eax), %eax
	movl	%eax, (%esp)
	call	free_proc_io_block_t
	leave
	ret
	.size	destroy_io_data, .-destroy_io_data
	.section	.rodata
	.align 4
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
	subl	$56, %esp
	movl	global_proc_list, %eax
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	je	.L61
.L67:
	movl	-12(%ebp), %eax
	movl	%eax, -20(%ebp)
	movl	-20(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	8(%ebp), %eax
	jne	.L62
	movl	$670, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	-20(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC17, (%esp)
	call	outb_printf
	movl	-20(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	global_proc_list, %eax
	movl	%eax, -28(%ebp)
	movl	global_proc_list, %eax
	movl	4(%eax), %eax
	movl	%eax, -32(%ebp)
	movl	-24(%ebp), %eax
	cmpl	-28(%ebp), %eax
	jne	.L63
	movl	-28(%ebp), %eax
	cmpl	-32(%ebp), %eax
	jne	.L64
	movl	$0, global_proc_list
	jmp	.L66
.L64:
	movl	-28(%ebp), %eax
	movl	(%eax), %edx
	movl	-32(%ebp), %eax
	movl	%edx, (%eax)
	movl	-28(%ebp), %eax
	movl	(%eax), %eax
	movl	-32(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	-28(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, global_proc_list
	jmp	.L66
.L63:
	movl	-24(%ebp), %eax
	movl	4(%eax), %eax
	movl	-24(%ebp), %edx
	movl	(%edx), %edx
	movl	%edx, (%eax)
	movl	-24(%ebp), %eax
	movl	(%eax), %eax
	movl	-24(%ebp), %edx
	movl	4(%edx), %edx
	movl	%edx, 4(%eax)
.L66:
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	free_process_node_t
	jmp	.L61
.L62:
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	global_proc_list, %eax
	cmpl	%eax, -12(%ebp)
	jne	.L67
.L61:
	movl	$0, -16(%ebp)
	movl	global_proc_list, %eax
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	je	.L60
.L69:
	movl	-12(%ebp), %eax
	movl	%eax, -36(%ebp)
	movl	$688, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	-36(%ebp), %eax
	movl	8(%eax), %eax
	movl	112(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC18, (%esp)
	call	outb_printf
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)
	addl	$1, -16(%ebp)
	cmpl	$7, -16(%ebp)
	jle	.L69
	movl	global_proc_list, %eax
	cmpl	%eax, -12(%ebp)
	jne	.L69
.L60:
	leave
	ret
	.size	take_out_of_global_proc_list, .-take_out_of_global_proc_list
	.globl	free_process_block
	.type	free_process_block, @function
free_process_block:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	call	get_process_node_t
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	-12(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	global_free_proc_list, %eax
	testl	%eax, %eax
	jne	.L71
	movl	-16(%ebp), %eax
	movl	%eax, global_free_proc_list
	movl	-16(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, (%eax)
	movl	-16(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, 4(%eax)
	jmp	.L70
.L71:
	movl	global_free_proc_list, %eax
	movl	%eax, -20(%ebp)
	movl	global_free_proc_list, %eax
	movl	4(%eax), %eax
	movl	%eax, -24(%ebp)
	movl	-20(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	-16(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	%edx, (%eax)
	movl	-16(%ebp), %eax
	movl	-24(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	-24(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, (%eax)
	movl	-16(%ebp), %eax
	movl	%eax, global_free_proc_list
.L70:
	leave
	ret
	.size	free_process_block, .-free_process_block
	.section	.rodata
	.align 4
.LC19:
	.string	"destroy_process: current = %08x proc = %08x\n"
	.text
	.globl	destroy_process
	.type	destroy_process, @function
destroy_process:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	8(%ebp), %edx
	movl	current, %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$.LC19, (%esp)
	call	outb_printf
	call	irq_cli_save
	movl	%eax, -16(%ebp)
	movl	8(%ebp), %eax
	movl	$4, 120(%eax)
	movl	8(%ebp), %eax
	movl	112(%eax), %eax
	movl	%eax, -20(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	free_user_memory
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	destroy_io_data
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	take_out_of_global_proc_list
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	remove_from_wait_queues
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	release_sync_primitives
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	free_process_block
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	release_pid
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	irq_restore
	movl	current, %eax
	cmpl	8(%ebp), %eax
	jne	.L73
	movl	$0, current
	call	sti
.L77:
	movl	$68, 4(%esp)
	movl	$233, (%esp)
	call	outb
	movl	$0, -12(%ebp)
	jmp	.L75
.L76:
	movl	$0, -24(%ebp)
	addl	$1, -12(%ebp)
.L75:
	cmpl	$32767, -12(%ebp)
	jle	.L76
	jmp	.L77
.L73:
	leave
	ret
	.size	destroy_process, .-destroy_process
	.section	.rodata
	.align 4
.LC20:
	.string	"clone_file_t: sizeof(file_t) = %d\n"
.LC21:
	.string	"clone_file_t: after memcpy.\n"
	.align 4
.LC22:
	.string	"clone_file_t: leave clone_file_t.\n"
	.text
	.globl	clone_file_t
	.type	clone_file_t, @function
clone_file_t:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$745, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	$28, 4(%esp)
	movl	$.LC20, (%esp)
	call	outb_printf
	cmpl	$0, 8(%ebp)
	jne	.L79
	movl	12(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, (%eax)
	movl	$0, %eax
	jmp	.L80
.L79:
	call	get_file_t
	movl	%eax, -12(%ebp)
	movl	$28, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
	movl	$757, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	$.LC21, (%esp)
	call	outb_printf
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	movl	-12(%ebp), %edx
	addl	$12, %edx
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	link_dentry_t
	movl	12(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	%edx, (%eax)
	movl	$763, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	$.LC22, (%esp)
	call	outb_printf
	movl	$0, %eax
.L80:
	leave
	ret
	.size	clone_file_t, .-clone_file_t
	.globl	clone_proc_t
	.type	clone_proc_t, @function
clone_proc_t:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	call	get_process_t
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L82
	movl	$-1, %eax
	jmp	.L83
.L82:
	movl	$8192, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
	movl	12(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	%edx, (%eax)
	movl	$0, %eax
.L83:
	leave
	ret
	.size	clone_proc_t, .-clone_proc_t
	.globl	clone_proc_io_block_t
	.type	clone_proc_io_block_t, @function
clone_proc_io_block_t:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	call	get_proc_io_block_t
	movl	%eax, -16(%ebp)
	movl	$0, -12(%ebp)
	jmp	.L85
.L87:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	-16(%ebp), %eax
	addl	%edx, %eax
	leal	8(%eax), %ecx
	movl	8(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	8(%eax,%edx,4), %eax
	movl	%ecx, 4(%esp)
	movl	%eax, (%esp)
	call	clone_file_t
	movl	%eax, -20(%ebp)
	movl	-16(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	8(%eax,%edx,4), %eax
	testl	%eax, %eax
	je	.L86
	movl	-16(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	8(%eax,%edx,4), %eax
	movl	24(%eax), %edx
	addl	$1, %edx
	movl	%edx, 24(%eax)
.L86:
	addl	$1, -12(%ebp)
.L85:
	cmpl	$15, -12(%ebp)
	jle	.L87
	movl	8(%ebp), %eax
	movl	(%eax), %edx
	movl	-16(%ebp), %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	link_dentry_t
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	-16(%ebp), %edx
	addl	$4, %edx
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	link_dentry_t
	movl	12(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, (%eax)
	movl	$0, %eax
	leave
	ret
	.size	clone_proc_io_block_t, .-clone_proc_io_block_t
	.globl	build_artificial_switch_save_block
	.type	build_artificial_switch_save_block, @function
build_artificial_switch_save_block:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	28(%ebp), %eax
	subl	$36, %eax
	movl	%eax, -4(%ebp)
	call	get_ds
	movl	-4(%ebp), %edx
	movw	%ax, (%edx)
	call	get_cs
	movl	-4(%ebp), %edx
	movw	%ax, 2(%edx)
	call	get_ss
	movl	-4(%ebp), %edx
	movw	%ax, 4(%edx)
	call	get_es
	movl	-4(%ebp), %edx
	movw	%ax, 6(%edx)
	call	get_fs
	movl	-4(%ebp), %edx
	movw	%ax, 10(%edx)
	call	get_gs
	movl	-4(%ebp), %edx
	movw	%ax, 8(%edx)
	movl	-4(%ebp), %eax
	movl	24(%ebp), %edx
	movl	%edx, 12(%eax)
	call	get_eflags
	orb	$2, %ah
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	movl	%edx, 16(%eax)
	movl	-4(%ebp), %eax
	movl	20(%ebp), %edx
	movl	%edx, 20(%eax)
	movl	-4(%ebp), %eax
	movl	16(%ebp), %edx
	movl	%edx, 24(%eax)
	movl	-4(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, 28(%eax)
	movl	-4(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, 32(%eax)
	movl	28(%ebp), %eax
	leal	-36(%eax), %edx
	movl	32(%ebp), %eax
	movl	%edx, (%eax)
	nop
	leave
	ret
	.size	build_artificial_switch_save_block, .-build_artificial_switch_save_block
	.globl	clone_wq
	.type	clone_wq, @function
clone_wq:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	136(%eax), %eax
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	je	.L91
	call	get_process_node_t
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	-16(%ebp), %eax
	movl	%eax, -20(%ebp)
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L93
	movl	-12(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	%edx, (%eax)
	movl	-20(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	%edx, (%eax)
	movl	-20(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	%edx, 4(%eax)
	jmp	.L94
.L93:
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	movl	4(%eax), %eax
	movl	%eax, -24(%ebp)
	movl	-24(%ebp), %eax
	movl	(%eax), %edx
	movl	-20(%ebp), %eax
	movl	%edx, (%eax)
	movl	-20(%ebp), %eax
	movl	-24(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	-24(%ebp), %eax
	movl	(%eax), %eax
	movl	-20(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	%edx, (%eax)
.L94:
	movl	8(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	%edx, 136(%eax)
.L91:
	leave
	ret
	.size	clone_wq, .-clone_wq
	.section	.rodata
	.align 4
.LC23:
	.string	"fork_process start: current = %08x"
	.align 4
.LC24:
	.string	"fork_process renew: ret_eip = %08x, old_bp = %08x\ngoal_sp = %08x\n"
.LC25:
	.string	"proc_t cloned.\n"
.LC26:
	.string	"before prepare fork_stack...\n"
	.align 4
.LC27:
	.string	"ret eip = %08x, old_bp = %08x\n"
	.align 4
.LC28:
	.string	"new_proc signal handler = %08x\n"
.LC29:
	.string	"leaving fork parent.\n"
	.text
	.globl	fork_process
	.type	fork_process, @function
fork_process:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$120, %esp
	call	irq_cli_save
	movl	%eax, -16(%ebp)
	movl	$858, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	current, %eax
	movl	%eax, 4(%esp)
	movl	$.LC23, (%esp)
	call	outb_printf
	movl	$-1, -20(%ebp)
	movl	current, %eax
	movl	%eax, -24(%ebp)
	movl	$76, -28(%ebp)
	movl	-28(%ebp), %eax
	subl	$8, %eax
	movl	%eax, -32(%ebp)
	movl	$1, 8(%esp)
	leal	-64(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	copy_page_tables
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	je	.L96
	jmp	.L97
.L96:
	leal	-68(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	clone_proc_t
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	je	.L98
	jmp	.L97
.L98:
	movl	-68(%ebp), %eax
	movl	-24(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	clone_wq
	movl	-68(%ebp), %eax
	addl	$8192, %eax
	subl	-28(%ebp), %eax
	movl	%eax, -28(%ebp)
	movl	-68(%ebp), %eax
	addl	$8192, %eax
	subl	-32(%ebp), %eax
	movl	%eax, -32(%ebp)
	movl	-28(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	movl	%eax, -36(%ebp)
	movl	$903, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	printf
	movl	-32(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-36(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC24, (%esp)
	call	printf
	movl	$906, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	$.LC25, (%esp)
	call	outb_printf
	movl	-24(%ebp), %eax
	movl	108(%eax), %eax
	leal	-72(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	clone_proc_io_block_t
	movl	%eax, -20(%ebp)
	movl	-68(%ebp), %eax
	movl	-72(%ebp), %edx
	movl	%edx, 108(%eax)
	call	get_new_pid
	movl	%eax, -12(%ebp)
	movl	-68(%ebp), %eax
	movl	$0, 8(%esp)
	movl	-12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	init_proc_basic
	movl	-68(%ebp), %eax
	movl	$3, 120(%eax)
	movl	-64(%ebp), %edx
	movl	-68(%ebp), %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	init_proc_cr3
	movl	-68(%ebp), %eax
	addl	$8192, %eax
	movl	%eax, -40(%ebp)
	movl	-40(%ebp), %eax
	movl	%eax, -44(%ebp)
	movl	-44(%ebp), %eax
	subl	$28, %eax
	movl	$0, (%eax)
	movl	-68(%ebp), %eax
	movl	-40(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	-68(%ebp), %eax
	movw	$40, 8(%eax)
	movl	-68(%ebp), %eax
	movw	$40, 80(%eax)
	movl	-68(%ebp), %eax
	movl	$0, 60(%eax)
	movl	$944, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	$.LC26, (%esp)
	call	outb_printf
	movl	-64(%ebp), %eax
	leal	-76(%ebp), %edx
	movl	%edx, 24(%esp)
	movl	-32(%ebp), %edx
	movl	%edx, 20(%esp)
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	movl	$0, 4(%esp)
	movl	$0, (%esp)
	call	build_artificial_switch_save_block
	movl	-68(%ebp), %eax
	movl	-76(%ebp), %edx
	movl	%edx, 56(%eax)
	movl	-68(%ebp), %eax
	movl	$0, 8(%esp)
	movl	-36(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	init_proc_eip
	movl	$957, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	-68(%ebp), %eax
	movl	32(%eax), %eax
	movl	-28(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$.LC27, (%esp)
	call	outb_printf
	call	get_process_node_t
	movl	%eax, -48(%ebp)
	movl	-68(%ebp), %edx
	movl	-48(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	-48(%ebp), %eax
	movl	%eax, -52(%ebp)
	movl	global_proc_list, %eax
	testl	%eax, %eax
	jne	.L99
	movl	-52(%ebp), %eax
	movl	%eax, global_proc_list
	movl	-52(%ebp), %eax
	movl	-52(%ebp), %edx
	movl	%edx, (%eax)
	movl	-52(%ebp), %eax
	movl	-52(%ebp), %edx
	movl	%edx, 4(%eax)
	jmp	.L100
.L99:
	movl	global_proc_list, %eax
	movl	%eax, -56(%ebp)
	movl	global_proc_list, %eax
	movl	4(%eax), %eax
	movl	%eax, -60(%ebp)
	movl	-56(%ebp), %eax
	movl	-52(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	-52(%ebp), %eax
	movl	-56(%ebp), %edx
	movl	%edx, (%eax)
	movl	-52(%ebp), %eax
	movl	-60(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	-60(%ebp), %eax
	movl	-52(%ebp), %edx
	movl	%edx, (%eax)
	movl	-52(%ebp), %eax
	movl	%eax, global_proc_list
.L100:
	movl	$965, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	-68(%ebp), %eax
	movl	124(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC28, (%esp)
	call	outb_printf
.L97:
	movl	$969, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	$.LC29, (%esp)
	call	outb_printf
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	irq_restore
	movl	-12(%ebp), %eax
	leave
	ret
	.size	fork_process, .-fork_process
	.ident	"GCC: (GNU) 4.8.2"
