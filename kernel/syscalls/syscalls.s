	.file	"syscalls.c"
#APP
	.code16gcc	

#NO_APP
	.text
	.globl	sys_open
	.type	sys_open, @function
sys_open:
	pushl	%ebp
	movl	%esp, %ebp
	orl	$-1, %eax
	popl	%ebp
	ret
	.size	sys_open, .-sys_open
	.globl	sys_read
	.type	sys_read, @function
sys_read:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	current, %eax
	movl	108(%eax), %eax
	movl	8(%ebp), %edx
	movl	(%eax,%edx,4), %eax
	testl	%eax, %eax
	je	.L5
	movl	16(%eax), %edx
	movl	4(%edx), %edx
	testl	%edx, %edx
	je	.L6
	pushl	$0
	pushl	16(%ebp)
	pushl	12(%ebp)
	pushl	%eax
	call	*%edx
	addl	$16, %esp
	jmp	.L4
.L5:
	movl	$-3, %eax
	jmp	.L4
.L6:
	orl	$-1, %eax
.L4:
	leave
	ret
	.size	sys_read, .-sys_read
	.globl	sys_write
	.type	sys_write, @function
sys_write:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	current, %eax
	movl	108(%eax), %eax
	movl	8(%ebp), %edx
	movl	(%eax,%edx,4), %eax
	testl	%eax, %eax
	je	.L11
	movl	16(%eax), %edx
	movl	8(%edx), %edx
	testl	%edx, %edx
	je	.L12
	pushl	$0
	pushl	16(%ebp)
	pushl	12(%ebp)
	pushl	%eax
	call	*%edx
	addl	$16, %esp
	jmp	.L10
.L11:
	movl	$-3, %eax
	jmp	.L10
.L12:
	movl	$-2, %eax
.L10:
	leave
	ret
	.size	sys_write, .-sys_write
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"sys_register_handler: registered = %08x\n"
	.text
	.globl	sys_register_handler
	.type	sys_register_handler, @function
sys_register_handler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	current, %edx
	movl	%eax, 124(%edx)
	pushl	%eax
	pushl	$.LC0
	call	outb_printf
	xorl	%eax, %eax
	leave
	ret
	.size	sys_register_handler, .-sys_register_handler
	.globl	syscall_handler
	.type	syscall_handler, @function
syscall_handler:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	16(%ebp), %ebx
	movb	$83, %al
#APP
# 25 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	outb %al, $233
# 0 "" 2
#NO_APP
	movl	24(%ebx), %eax
	movl	20(%ebx), %edx
	movl	16(%ebx), %ecx
	cmpl	$4, 28(%ebx)
	ja	.L17
	movl	28(%ebx), %esi
	jmp	*.L19(,%esi,4)
	.section	.rodata
	.align 4
	.align 4
.L19:
	.long	.L24
	.long	.L20
	.long	.L21
	.long	.L22
	.long	.L23
	.text
.L17:
	xorl	%eax, %eax
	jmp	.L18
.L20:
	pushl	%esi
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	call	sys_read
	jmp	.L26
.L21:
	pushl	%esi
	pushl	%ecx
	pushl	%edx
	pushl	%eax
	call	sys_write
.L26:
	addl	$16, %esp
	jmp	.L18
.L22:
	subl	$12, %esp
	pushl	%eax
	call	sys_register_handler
	jmp	.L26
.L23:
	call	fork_process
	jmp	.L18
.L24:
	orl	$-1, %eax
.L18:
	movl	%eax, 28(%ebx)
	leal	-8(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	syscall_handler, .-syscall_handler
	.globl	sys_fork
	.type	sys_fork, @function
sys_fork:
	pushl	%ebp
	movl	%esp, %ebp
	popl	%ebp
	jmp	fork_process
	.size	sys_fork, .-sys_fork
	.ident	"GCC: (GNU) 4.8.2 20140120 (Red Hat 4.8.2-15)"
	.section	.note.GNU-stack,"",@progbits
