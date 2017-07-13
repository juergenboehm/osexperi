	.file	"irq.c"
#APP
	.code16gcc	

#NO_APP
	.comm	ide_irq_sema,4,4
	.comm	ide_res_sema,4,4
	.comm	ide_ctrl_PM,4,4
	.comm	idt_table,4,4
	.comm	idt_ptr,6,1
	.comm	irq_disp_table,1024,32
	.comm	syscall_parm,4,4
	.text
	.globl	irq_dispatcher
	.type	irq_dispatcher, @function
irq_dispatcher:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	irq_disp_table(,%eax,4), %eax
	movl	16(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	8(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
	leave
	ret
	.size	irq_dispatcher, .-irq_dispatcher
	.globl	idt_set
	.type	idt_set, @function
idt_set:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	$irq_no_errcode, %eax
	addl	%edx, %eax
	movl	%eax, -4(%ebp)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$0, (%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$0, 2(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movb	$0, 4(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movb	$0, 5(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$0, 6(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$32, 2(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	-4(%ebp), %eax
	movw	%ax, (%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	-4(%ebp), %eax
	shrl	$16, %eax
	movw	%ax, 6(%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	idt_table, %eax
	movl	8(%ebp), %ecx
	sall	$3, %ecx
	addl	%ecx, %eax
	movb	5(%eax), %al
	orl	$-128, %eax
	movb	%al, 5(%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movl	idt_table, %edx
	movl	8(%ebp), %ecx
	sall	$3, %ecx
	addl	%ecx, %edx
	movb	5(%edx), %dl
	andl	$-97, %edx
	movb	%dl, 5(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	idt_table, %eax
	movl	8(%ebp), %ecx
	sall	$3, %ecx
	addl	%ecx, %eax
	movb	5(%eax), %al
	andl	$-16, %eax
	orl	$14, %eax
	movb	%al, 5(%edx)
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, irq_disp_table(,%eax,4)
	leave
	ret
	.size	idt_set, .-idt_set
	.globl	idt_set_trap
	.type	idt_set_trap, @function
idt_set_trap:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	$irq_no_errcode, %eax
	addl	%edx, %eax
	movl	%eax, -4(%ebp)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$0, (%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$0, 2(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movb	$0, 4(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movb	$0, 5(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$0, 6(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$32, 2(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	-4(%ebp), %eax
	movw	%ax, (%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	-4(%ebp), %eax
	shrl	$16, %eax
	movw	%ax, 6(%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	idt_table, %eax
	movl	8(%ebp), %ecx
	sall	$3, %ecx
	addl	%ecx, %eax
	movb	5(%eax), %al
	orl	$-128, %eax
	movb	%al, 5(%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movl	idt_table, %edx
	movl	8(%ebp), %ecx
	sall	$3, %ecx
	addl	%ecx, %edx
	movb	5(%edx), %dl
	andl	$-97, %edx
	movb	%dl, 5(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	idt_table, %eax
	movl	8(%ebp), %ecx
	sall	$3, %ecx
	addl	%ecx, %eax
	movb	5(%eax), %al
	orl	$15, %eax
	movb	%al, 5(%edx)
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, irq_disp_table(,%eax,4)
	leave
	ret
	.size	idt_set_trap, .-idt_set_trap
	.globl	idt_set_trap_user
	.type	idt_set_trap_user, @function
idt_set_trap_user:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	$irq_no_errcode, %eax
	addl	%edx, %eax
	movl	%eax, -4(%ebp)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$0, (%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$0, 2(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movb	$0, 4(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movb	$0, 5(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$0, 6(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$32, 2(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	-4(%ebp), %eax
	movw	%ax, (%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	-4(%ebp), %eax
	shrl	$16, %eax
	movw	%ax, 6(%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	idt_table, %eax
	movl	8(%ebp), %ecx
	sall	$3, %ecx
	addl	%ecx, %eax
	movb	5(%eax), %al
	orl	$-128, %eax
	movb	%al, 5(%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	idt_table, %eax
	movl	8(%ebp), %ecx
	sall	$3, %ecx
	addl	%ecx, %eax
	movb	5(%eax), %al
	orl	$96, %eax
	movb	%al, 5(%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	idt_table, %eax
	movl	8(%ebp), %ecx
	sall	$3, %ecx
	addl	%ecx, %eax
	movb	5(%eax), %al
	orl	$15, %eax
	movb	%al, 5(%edx)
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, irq_disp_table(,%eax,4)
	leave
	ret
	.size	idt_set_trap_user, .-idt_set_trap_user
	.globl	idt_set_err
	.type	idt_set_err, @function
idt_set_err:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	$irq_main, %eax
	addl	%edx, %eax
	movl	%eax, -4(%ebp)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$0, (%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$0, 2(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movb	$0, 4(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movb	$0, 5(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$0, 6(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$32, 2(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	-4(%ebp), %eax
	movw	%ax, (%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	-4(%ebp), %eax
	shrl	$16, %eax
	movw	%ax, 6(%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	idt_table, %eax
	movl	8(%ebp), %ecx
	sall	$3, %ecx
	addl	%ecx, %eax
	movb	5(%eax), %al
	orl	$-128, %eax
	movb	%al, 5(%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movl	idt_table, %edx
	movl	8(%ebp), %ecx
	sall	$3, %ecx
	addl	%ecx, %edx
	movb	5(%edx), %dl
	andl	$-97, %edx
	movb	%dl, 5(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	idt_table, %eax
	movl	8(%ebp), %ecx
	sall	$3, %ecx
	addl	%ecx, %eax
	movb	5(%eax), %al
	andl	$-16, %eax
	orl	$14, %eax
	movb	%al, 5(%edx)
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, irq_disp_table(,%eax,4)
	leave
	ret
	.size	idt_set_err, .-idt_set_err
	.globl	idt_set_err_trap
	.type	idt_set_err_trap, @function
idt_set_err_trap:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	$irq_main, %eax
	addl	%edx, %eax
	movl	%eax, -4(%ebp)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$0, (%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$0, 2(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movb	$0, 4(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movb	$0, 5(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$0, 6(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movw	$32, 2(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	-4(%ebp), %eax
	movw	%ax, (%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	-4(%ebp), %eax
	shrl	$16, %eax
	movw	%ax, 6(%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	idt_table, %eax
	movl	8(%ebp), %ecx
	sall	$3, %ecx
	addl	%ecx, %eax
	movb	5(%eax), %al
	orl	$-128, %eax
	movb	%al, 5(%edx)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%edx, %eax
	movl	idt_table, %edx
	movl	8(%ebp), %ecx
	sall	$3, %ecx
	addl	%ecx, %edx
	movb	5(%edx), %dl
	andl	$-97, %edx
	movb	%dl, 5(%eax)
	movl	idt_table, %eax
	movl	8(%ebp), %edx
	sall	$3, %edx
	addl	%eax, %edx
	movl	idt_table, %eax
	movl	8(%ebp), %ecx
	sall	$3, %ecx
	addl	%ecx, %eax
	movb	5(%eax), %al
	orl	$15, %eax
	movb	%al, 5(%edx)
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, irq_disp_table(,%eax,4)
	leave
	ret
	.size	idt_set_err_trap, .-idt_set_err_trap
	.globl	dummy_handler
	.type	dummy_handler, @function
dummy_handler:
	pushl	%ebp
	movl	%esp, %ebp
	popl	%ebp
	ret
	.size	dummy_handler, .-dummy_handler
	.section	.rodata
	.align 4
.LC0:
	.string	"Stack fault: errcode = %d irq_num = %d.\n"
	.text
	.globl	stack_fault_handler
	.type	stack_fault_handler, @function
stack_fault_handler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC0, (%esp)
	call	printf
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC0, (%esp)
	call	outb_printf
.L9:
	jmp	.L9
	.size	stack_fault_handler, .-stack_fault_handler
	.section	.rodata
	.align 4
.LC1:
	.string	"Segment not present: errcode = %d irq_num = %d.\n"
	.text
	.globl	segment_not_present_handler
	.type	segment_not_present_handler, @function
segment_not_present_handler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC1, (%esp)
	call	outb_printf
.L11:
	jmp	.L11
	.size	segment_not_present_handler, .-segment_not_present_handler
	.section	.rodata
	.align 4
.LC2:
	.string	"General Protection Fault: errcode = %d irq_num = %d.\n"
	.text
	.globl	gpf_handler
	.type	gpf_handler, @function
gpf_handler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC2, (%esp)
	call	printf
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC2, (%esp)
	call	outb_printf
.L13:
	jmp	.L13
	.size	gpf_handler, .-gpf_handler
	.globl	init_idt_table
	.type	init_idt_table, @function
init_idt_table:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$0, -4(%ebp)
	movl	$0, -4(%ebp)
	jmp	.L15
.L16:
	movl	$dummy_handler, 4(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	idt_set
	incl	-4(%ebp)
.L15:
	cmpl	$7, -4(%ebp)
	jle	.L16
	movl	$8, -4(%ebp)
	jmp	.L17
.L18:
	movl	$dummy_handler, 4(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	idt_set_err
	incl	-4(%ebp)
.L17:
	cmpl	$15, -4(%ebp)
	jle	.L18
	movl	$segment_not_present_handler, 4(%esp)
	movl	$11, (%esp)
	call	idt_set_err_trap
	movl	$stack_fault_handler, 4(%esp)
	movl	$12, (%esp)
	call	idt_set_err_trap
	movl	$gpf_handler, 4(%esp)
	movl	$13, (%esp)
	call	idt_set_err_trap
	movl	$page_fault_handler, 4(%esp)
	movl	$14, (%esp)
	call	idt_set_err
	movl	$dummy_handler, 4(%esp)
	movl	$16, (%esp)
	call	idt_set
	movl	$dummy_handler, 4(%esp)
	movl	$17, (%esp)
	call	idt_set_err
	movl	$18, -4(%ebp)
	jmp	.L19
.L20:
	movl	$dummy_handler, 4(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	idt_set
	incl	-4(%ebp)
.L19:
	cmpl	$31, -4(%ebp)
	jle	.L20
	movl	$32, -4(%ebp)
	jmp	.L21
.L22:
	movl	$dummy_handler, 4(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	idt_set
	incl	-4(%ebp)
.L21:
	cmpl	$255, -4(%ebp)
	jle	.L22
	movl	$syscall_handler, 4(%esp)
	movl	$128, (%esp)
	call	idt_set_trap_user
	movl	$timer_irq_handler, 4(%esp)
	movl	$32, (%esp)
	call	idt_set
	movl	$keyb_irq_handler, 4(%esp)
	movl	$33, (%esp)
	call	idt_set
	movl	$ide_irq_handler, 4(%esp)
	movl	$46, (%esp)
	call	idt_set
	leave
	ret
	.size	init_idt_table, .-init_idt_table
	.ident	"GCC: (GNU) 4.8.2 20140120 (Red Hat 4.8.2-15)"
	.section	.note.GNU-stack,"",@progbits
