	.file	"syscalls.c"
/APP
	.code16gcc	

/NO_APP
	.text
	.globl	syscall_handler
	.type	syscall_handler, @function
syscall_handler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	16(%ebp), %eax
	movl	28(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	16(%ebp), %eax
	movl	24(%eax), %eax
	movl	%eax, -16(%ebp)
	movl	16(%ebp), %eax
	movl	20(%eax), %eax
	movl	%eax, -20(%ebp)
	movl	16(%ebp), %eax
	movl	16(%eax), %eax
	movl	%eax, -24(%ebp)
	movl	16(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, -28(%ebp)
	movl	16(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, -32(%ebp)
	movl	$0, -36(%ebp)
	movl	-12(%ebp), %eax
	cmpl	$4, %eax
	ja	.L10
	movl	.L4(,%eax,4), %eax
	jmp	*%eax
	.section	.rodata
	.align 4
	.align 4
.L4:
	.long	.L3
	.long	.L5
	.long	.L6
	.long	.L7
	.long	.L8
	.text
.L3:
	movl	-20(%ebp), %edx
	movl	-16(%ebp), %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	sys_open
	movl	%eax, -36(%ebp)
	jmp	.L9
.L5:
	movl	-24(%ebp), %ecx
	movl	-20(%ebp), %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	sys_read
	movl	%eax, -36(%ebp)
	jmp	.L9
.L6:
	movl	-24(%ebp), %ecx
	movl	-20(%ebp), %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	sys_write
	movl	%eax, -36(%ebp)
	jmp	.L9
.L7:
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	sys_register_handler
	movl	%eax, -36(%ebp)
	jmp	.L9
.L8:
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	sys_fork
	movl	%eax, -36(%ebp)
	jmp	.L9
.L10:
	nop
.L9:
	movl	16(%ebp), %eax
	leal	28(%eax), %edx
	movl	-36(%ebp), %eax
	movl	%eax, (%edx)
	movl	16(%ebp), %eax
	movl	%eax, (%esp)
	call	process_signals
	leave
	ret
	.size	syscall_handler, .-syscall_handler
	.globl	sys_open
	.type	sys_open, @function
sys_open:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$-1, %eax
	popl	%ebp
	ret
	.size	sys_open, .-sys_open
	.globl	sys_read
	.type	sys_read, @function
sys_read:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	current, %eax
	movl	108(%eax), %eax
	movl	8(%ebp), %edx
	movl	(%eax,%edx,4), %eax
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	je	.L14
	movl	-16(%ebp), %eax
	movl	16(%eax), %eax
	movl	4(%eax), %eax
	testl	%eax, %eax
	je	.L15
	movl	-16(%ebp), %eax
	movl	16(%eax), %eax
	movl	4(%eax), %eax
	movl	$0, 12(%esp)
	movl	16(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	-16(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -12(%ebp)
	jmp	.L17
.L15:
	movl	$-1, -12(%ebp)
	jmp	.L17
.L14:
	movl	$-3, -12(%ebp)
.L17:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	sys_read, .-sys_read
	.globl	sys_write
	.type	sys_write, @function
sys_write:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	current, %eax
	movl	108(%eax), %eax
	movl	8(%ebp), %edx
	movl	(%eax,%edx,4), %eax
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	je	.L20
	movl	-16(%ebp), %eax
	movl	16(%eax), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L21
	movl	-16(%ebp), %eax
	movl	16(%eax), %eax
	movl	8(%eax), %eax
	movl	$0, 12(%esp)
	movl	16(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	-16(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -12(%ebp)
	jmp	.L23
.L21:
	movl	$-2, -12(%ebp)
	jmp	.L23
.L20:
	movl	$-3, -12(%ebp)
.L23:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	sys_write, .-sys_write
	.section	.rodata
	.align 4
.LC0:
	.string	"sys_register_handler: registered = %08x\n"
	.text
	.globl	sys_register_handler
	.type	sys_register_handler, @function
sys_register_handler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	current, %eax
	movl	8(%ebp), %edx
	movl	%edx, 124(%eax)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC0, (%esp)
	call	outb_printf
	movl	$0, %eax
	leave
	ret
	.size	sys_register_handler, .-sys_register_handler
	.globl	sys_fork
	.type	sys_fork, @function
sys_fork:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	call	fork_process
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	leave
	ret
	.size	sys_fork, .-sys_fork
	.ident	"GCC: (GNU) 4.8.2"
