	.file	"irq.c"
#APP
	.code16gcc	

#NO_APP
	.text
	.globl	dummy_handler
	.type	dummy_handler, @function
dummy_handler:
	pushl	%ebp
	movl	%esp, %ebp
	popl	%ebp
	ret
	.size	dummy_handler, .-dummy_handler
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Stack fault: errcode = %d irq_num = %d.\n"
	.text
	.globl	stack_fault_handler
	.type	stack_fault_handler, @function
stack_fault_handler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp
	pushl	12(%ebp)
	pushl	8(%ebp)
	pushl	$.LC0
	call	printf
	addl	$16, %esp
.L4:
	jmp	.L4
	.size	stack_fault_handler, .-stack_fault_handler
	.section	.rodata.str1.1
.LC1:
	.string	"Segment not present: errcode = %d irq_num = %d.\n"
	.text
	.globl	segment_not_present_handler
	.type	segment_not_present_handler, @function
segment_not_present_handler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp
	pushl	12(%ebp)
	pushl	8(%ebp)
	pushl	$.LC1
	call	printf
	addl	$16, %esp
.L8:
	jmp	.L8
	.size	segment_not_present_handler, .-segment_not_present_handler
	.section	.rodata.str1.1
.LC2:
	.string	"General Protection Fault: errcode = %d irq_num = %d.\n"
	.text
	.globl	gpf_handler
	.type	gpf_handler, @function
gpf_handler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp
	pushl	12(%ebp)
	pushl	8(%ebp)
	pushl	$.LC2
	call	printf
	addl	$16, %esp
.L11:
	jmp	.L11
	.size	gpf_handler, .-gpf_handler
	.globl	irq_dispatcher
	.type	irq_dispatcher, @function
irq_dispatcher:
	pushl	%ebp
	movl	%esp, %ebp
	movl	12(%ebp), %eax
	movl	irq_disp_table(,%eax,4), %eax
	popl	%ebp
	jmp	*%eax
	.size	irq_dispatcher, .-irq_dispatcher
	.globl	idt_set
	.type	idt_set, @function
idt_set:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movl	%edx, %ecx
	sall	$4, %ecx
	addl	$irq_no_errcode, %ecx
	movl	idt_table, %eax
	leal	(%eax,%edx,8), %eax
	movb	$0, 4(%eax)
	movw	$32, 2(%eax)
	movw	%cx, (%eax)
	shrl	$16, %ecx
	movw	%cx, 6(%eax)
	movb	$-114, 5(%eax)
	movl	12(%ebp), %eax
	movl	%eax, irq_disp_table(,%edx,4)
	popl	%ebp
	ret
	.size	idt_set, .-idt_set
	.globl	idt_set_trap
	.type	idt_set_trap, @function
idt_set_trap:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movl	%edx, %ecx
	sall	$4, %ecx
	addl	$irq_no_errcode, %ecx
	movl	idt_table, %eax
	leal	(%eax,%edx,8), %eax
	movb	$0, 4(%eax)
	movw	$32, 2(%eax)
	movw	%cx, (%eax)
	shrl	$16, %ecx
	movw	%cx, 6(%eax)
	movb	$-113, 5(%eax)
	movl	12(%ebp), %eax
	movl	%eax, irq_disp_table(,%edx,4)
	popl	%ebp
	ret
	.size	idt_set_trap, .-idt_set_trap
	.globl	idt_set_trap_user
	.type	idt_set_trap_user, @function
idt_set_trap_user:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movl	%edx, %ecx
	sall	$4, %ecx
	addl	$irq_no_errcode, %ecx
	movl	idt_table, %eax
	leal	(%eax,%edx,8), %eax
	movb	$0, 4(%eax)
	movw	$32, 2(%eax)
	movw	%cx, (%eax)
	shrl	$16, %ecx
	movw	%cx, 6(%eax)
	movb	$-17, 5(%eax)
	movl	12(%ebp), %eax
	movl	%eax, irq_disp_table(,%edx,4)
	popl	%ebp
	ret
	.size	idt_set_trap_user, .-idt_set_trap_user
	.globl	idt_set_err
	.type	idt_set_err, @function
idt_set_err:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movl	%edx, %ecx
	sall	$4, %ecx
	addl	$irq_main, %ecx
	movl	idt_table, %eax
	leal	(%eax,%edx,8), %eax
	movb	$0, 4(%eax)
	movw	$32, 2(%eax)
	movw	%cx, (%eax)
	shrl	$16, %ecx
	movw	%cx, 6(%eax)
	movb	$-114, 5(%eax)
	movl	12(%ebp), %eax
	movl	%eax, irq_disp_table(,%edx,4)
	popl	%ebp
	ret
	.size	idt_set_err, .-idt_set_err
	.globl	idt_set_err_trap
	.type	idt_set_err_trap, @function
idt_set_err_trap:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movl	%edx, %ecx
	sall	$4, %ecx
	addl	$irq_main, %ecx
	movl	idt_table, %eax
	leal	(%eax,%edx,8), %eax
	movb	$0, 4(%eax)
	movw	$32, 2(%eax)
	movw	%cx, (%eax)
	shrl	$16, %ecx
	movw	%cx, 6(%eax)
	movb	$-113, 5(%eax)
	movl	12(%ebp), %eax
	movl	%eax, irq_disp_table(,%edx,4)
	popl	%ebp
	ret
	.size	idt_set_err_trap, .-idt_set_err_trap
	.globl	init_idt_table
	.type	init_idt_table, @function
init_idt_table:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	xorl	%ebx, %ebx
.L27:
	pushl	$dummy_handler
	pushl	%ebx
	call	idt_set
	incl	%ebx
	popl	%ecx
	popl	%eax
	cmpl	$8, %ebx
	jne	.L27
.L29:
	pushl	$dummy_handler
	pushl	%ebx
	call	idt_set_err
	incl	%ebx
	popl	%eax
	popl	%edx
	cmpl	$16, %ebx
	jne	.L29
	pushl	$segment_not_present_handler
	pushl	$11
	call	idt_set_err_trap
	pushl	$stack_fault_handler
	pushl	$12
	call	idt_set_err_trap
	pushl	$gpf_handler
	pushl	$13
	call	idt_set_err_trap
	pushl	$page_fault_handler
	pushl	$14
	call	idt_set_err
	addl	$32, %esp
	pushl	$dummy_handler
	pushl	$16
	call	idt_set
	pushl	$dummy_handler
	pushl	$17
	call	idt_set_err
	addl	$16, %esp
	movb	$18, %bl
.L31:
	pushl	$dummy_handler
	pushl	%ebx
	call	idt_set
	incl	%ebx
	popl	%ecx
	popl	%eax
	cmpl	$32, %ebx
	jne	.L31
.L33:
	pushl	$dummy_handler
	pushl	%ebx
	call	idt_set
	incl	%ebx
	popl	%eax
	popl	%edx
	cmpl	$256, %ebx
	jne	.L33
	pushl	$syscall_handler
	pushl	$128
	call	idt_set_trap_user
	pushl	$timer_irq_handler
	pushl	$32
	call	idt_set
	pushl	$keyb_irq_handler
	pushl	$33
	call	idt_set
	pushl	$ide_irq_handler
	pushl	$46
	call	idt_set
	addl	$32, %esp
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	init_idt_table, .-init_idt_table
	.comm	syscall_parm,4,4
	.comm	irq_disp_table,1024,4
	.comm	idt_ptr,6,4
	.comm	idt_table,4,4
	.comm	ide_ctrl_PM,4,4
	.comm	ide_res_sema,4,4
	.comm	ide_irq_sema,4,4
	.ident	"GCC: (GNU) 4.8.2 20140120 (Red Hat 4.8.2-15)"
	.section	.note.GNU-stack,"",@progbits
