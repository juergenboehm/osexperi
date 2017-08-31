	.file	"userproc.c"
	.comm	FILE,4,4
	.text
	.type	get_cs, @function
get_cs:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
/APP
/  81 "/home/juergen/osexperi/kernel/kernel_user/stdlib.h" 1
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
/  88 "/home/juergen/osexperi/kernel/kernel_user/stdlib.h" 1
	movw %ds, %ax
/  0 "" 2
/NO_APP
	movw	%ax, -2(%ebp)
	movzwl	-2(%ebp), %eax
	leave
	ret
	.size	get_ds, .-get_ds
	.section	.rodata
	.align 4
.LC0:
	.string	"usage: cp <pathname_from> <pathname_to>\n"
.LC1:
	.string	"\n\nopen done: fd = %d\n"
.LC2:
	.string	"\nopen done: fd_out = %d\n"
	.text
	.globl	execute_cp
	.type	execute_cp, @function
execute_cp:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$184, %esp
	movl	$-1, -12(%ebp)
	cmpl	$2, 8(%ebp)
	jg	.L6
	movl	$.LC0, 4(%esp)
	movl	$3, (%esp)
	call	fprintf
	jmp	.L7
.L6:
	movl	12(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	open
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC1, 4(%esp)
	movl	$3, (%esp)
	call	fprintf
	movl	12(%ebp), %eax
	addl	$8, %eax
	movl	(%eax), %eax
	movl	$420, 8(%esp)
	movl	$65, 4(%esp)
	movl	%eax, (%esp)
	call	open
	movl	%eax, -20(%ebp)
	movl	-20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC2, 4(%esp)
	movl	$3, (%esp)
	call	fprintf
	movl	$127, -24(%ebp)
	movl	$0, -28(%ebp)
.L11:
	movl	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-156(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	read
	movl	%eax, -28(%ebp)
	cmpl	$0, -28(%ebp)
	jns	.L8
	jmp	.L9
.L8:
	cmpl	$0, -28(%ebp)
	jle	.L10
	leal	-156(%ebp), %edx
	movl	-28(%ebp), %eax
	addl	%edx, %eax
	movb	$0, (%eax)
	movl	-28(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-156(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	write
.L10:
	cmpl	$0, -28(%ebp)
	jne	.L11
.L9:
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	close
.L7:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	execute_cp, .-execute_cp
	.section	.rodata
.LC3:
	.string	"usage: cd <dirname>\n"
	.text
	.globl	execute_cd
	.type	execute_cd, @function
execute_cd:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$-1, -12(%ebp)
	cmpl	$1, 8(%ebp)
	jg	.L14
	movl	$.LC3, 4(%esp)
	movl	$3, (%esp)
	call	fprintf
	jmp	.L15
.L14:
	movl	12(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	chdir
	movl	%eax, -12(%ebp)
.L15:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	execute_cd, .-execute_cd
	.section	.rodata
.LC4:
	.string	"usage: rm <pathname>\n"
	.text
	.globl	execute_rm
	.type	execute_rm, @function
execute_rm:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$-1, -12(%ebp)
	cmpl	$1, 8(%ebp)
	jg	.L18
	movl	$.LC4, 4(%esp)
	movl	$3, (%esp)
	call	fprintf
	jmp	.L19
.L18:
	movl	12(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	unlink
	movl	%eax, -12(%ebp)
.L19:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	execute_rm, .-execute_rm
	.section	.rodata
.LC5:
	.string	"usage: rmdir <dir_pathname>\n"
	.text
	.globl	execute_rmdir
	.type	execute_rmdir, @function
execute_rmdir:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$-1, -12(%ebp)
	cmpl	$1, 8(%ebp)
	jg	.L22
	movl	$.LC5, 4(%esp)
	movl	$3, (%esp)
	call	fprintf
	jmp	.L23
.L22:
	movl	12(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	rmdir
	movl	%eax, -12(%ebp)
.L23:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	execute_rmdir, .-execute_rmdir
	.section	.rodata
.LC6:
	.string	"usage: mkdir <dir_pathname>\n"
	.text
	.globl	execute_mkdir
	.type	execute_mkdir, @function
execute_mkdir:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$-1, -12(%ebp)
	cmpl	$1, 8(%ebp)
	jg	.L26
	movl	$.LC6, 4(%esp)
	movl	$3, (%esp)
	call	fprintf
	jmp	.L27
.L26:
	movl	12(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	movl	$484, 4(%esp)
	movl	%eax, (%esp)
	call	mkdir
	movl	%eax, -12(%ebp)
.L27:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	execute_mkdir, .-execute_mkdir
	.section	.rodata
.LC7:
	.string	"usage: ls <dirname>\n"
.LC8:
	.string	"\nfd_dir = %d\n"
.LC9:
	.string	"%c %s\n"
	.text
	.globl	execute_ls
	.type	execute_ls, @function
execute_ls:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$296, %esp
	movl	$-1, -12(%ebp)
	cmpl	$1, 8(%ebp)
	jg	.L30
	movl	$.LC7, 4(%esp)
	movl	$3, (%esp)
	call	fprintf
	jmp	.L31
.L30:
	movl	12(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	open
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC8, 4(%esp)
	movl	$3, (%esp)
	call	fprintf
	cmpl	$0, -16(%ebp)
	jns	.L32
	jmp	.L31
.L32:
	leal	-280(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	readdir
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jg	.L33
	nop
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	jmp	.L31
.L33:
	movzbl	-272(%ebp), %eax
	cmpb	$2, %al
	jne	.L35
	movl	$100, %eax
	jmp	.L36
.L35:
	movl	$114, %eax
.L36:
	leal	-280(%ebp), %edx
	addl	$9, %edx
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC9, 4(%esp)
	movl	$3, (%esp)
	call	fprintf
	jmp	.L32
.L31:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	execute_ls, .-execute_ls
	.globl	my_commands
	.section	.rodata
.LC10:
	.string	"ls"
.LC11:
	.string	"cd"
.LC12:
	.string	"cp"
.LC13:
	.string	"rm"
.LC14:
	.string	"rmdir"
.LC15:
	.string	"mkdir"
	.data
	.align 32
	.type	my_commands, @object
	.size	my_commands, 48
my_commands:
	.long	.LC10
	.long	execute_ls
	.long	.LC11
	.long	execute_cd
	.long	.LC12
	.long	execute_cp
	.long	.LC13
	.long	execute_rm
	.long	.LC14
	.long	execute_rmdir
	.long	.LC15
	.long	execute_mkdir
	.text
	.globl	dispatch_op
	.type	dispatch_op, @function
dispatch_op:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$0, -12(%ebp)
	movl	$0, -12(%ebp)
	jmp	.L39
.L41:
	movl	20(%ebp), %eax
	movl	(%eax), %edx
	movl	-12(%ebp), %eax
	leal	0(,%eax,8), %ecx
	movl	8(%ebp), %eax
	addl	%ecx, %eax
	movl	(%eax), %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L40
	movl	-12(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	4(%eax), %eax
	movl	20(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	16(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
.L40:
	addl	$1, -12(%ebp)
.L39:
	movl	-12(%ebp), %eax
	cmpl	12(%ebp), %eax
	jl	.L41
	leave
	ret
	.size	dispatch_op, .-dispatch_op
	.section	.rodata
.LC16:
	.string	"\nmy handler_called: arg = %d\n"
	.text
	.globl	my_handler
	.type	my_handler, @function
my_handler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC16, (%esp)
	call	printf
	leave
	ret
	.size	my_handler, .-my_handler
	.globl	fak
	.type	fak, @function
fak:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	cmpl	$1, 8(%ebp)
	jne	.L44
	movl	$1, %eax
	jmp	.L45
.L44:
	movl	8(%ebp), %eax
	subl	$1, %eax
	movl	%eax, (%esp)
	call	fak
	imull	8(%ebp), %eax
.L45:
	leave
	ret
	.size	fak, .-fak
	.section	.rodata
.LC17:
	.string	"%c"
.LC18:
	.string	"\n"
	.text
	.globl	readline_echo
	.type	readline_echo, @function
readline_echo:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	$65, -24(%ebp)
	movl	20(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -28(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	$-1, -16(%ebp)
	movl	-12(%ebp), %eax
	movb	$0, (%eax)
	movl	$0, -20(%ebp)
.L55:
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	getc
	movl	%eax, -32(%ebp)
	movl	-32(%ebp), %eax
	shrl	$16, %eax
	movb	%al, -33(%ebp)
	cmpb	$0, -33(%ebp)
	je	.L47
	movl	$32, %eax
	movzbl	-33(%ebp), %edx
	cmpb	$32, -33(%ebp)
	cmovae	%edx, %eax
	movb	%al, -34(%ebp)
	cmpb	$13, -33(%ebp)
	jne	.L48
	jmp	.L57
.L48:
	cmpb	$8, -33(%ebp)
	jne	.L50
	cmpl	$0, -20(%ebp)
	jle	.L47
	cmpl	$-1, -16(%ebp)
	je	.L52
	cmpl	$0, -16(%ebp)
	jle	.L47
.L52:
	movzbl	-33(%ebp), %eax
	movb	%al, -34(%ebp)
	subl	$1, -20(%ebp)
	subl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	movb	$0, (%eax)
	cmpl	$0, -16(%ebp)
	jle	.L53
	subl	$1, -16(%ebp)
.L53:
	movzbl	-34(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC17, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	fprintf
	jmp	.L55
.L50:
	movl	-20(%ebp), %eax
	cmpl	-28(%ebp), %eax
	jge	.L47
	movzbl	-34(%ebp), %edx
	movl	-12(%ebp), %eax
	movb	%dl, (%eax)
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	movb	$0, (%eax)
	addl	$1, -20(%ebp)
	cmpl	$0, -16(%ebp)
	js	.L54
	addl	$1, -16(%ebp)
.L54:
	movzbl	-34(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC17, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	fprintf
	cmpl	$0, -20(%ebp)
	je	.L47
	movl	-20(%ebp), %eax
	cltd
	idivl	-24(%ebp)
	movl	%edx, %eax
	testl	%eax, %eax
	jne	.L47
	movl	$0, -16(%ebp)
	movl	$.LC18, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	fprintf
	jmp	.L55
.L47:
	jmp	.L55
.L57:
.L49:
	movl	20(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	%edx, (%eax)
	movl	$0, %eax
	leave
	ret
	.size	readline_echo, .-readline_echo
	.globl	testq
	.data
	.align 4
	.type	testq, @object
	.size	testq, 4
testq:
	.long	1
	.section	.rodata
	.align 4
.LC19:
	.string	"proc_1: presenting: the primes: cs = 0x%08x ds = 0x%08x\n"
	.align 4
.LC20:
	.string	"                                                       \n"
.LC21:
	.string	"proc1: forking\n"
.LC22:
	.string	"after fork: ret = %d\n"
.LC23:
	.string	"proc1: fork done.\n"
.LC24:
	.string	"fak(%d) = %d\n"
.LC25:
	.string	"\r\n"
.LC26:
	.string	">"
.LC27:
	.string	" "
.LC28:
	.string	"arg[%d] = %s\n"
.LC29:
	.string	"len = %d\n"
	.text
	.globl	uproc_1
	.type	uproc_1, @function
uproc_1:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$852, %esp
	movl	$0, -24(%ebp)
	movl	$2, -12(%ebp)
	movl	$1610612736, %eax
	movl	(%eax), %eax
	movl	%eax, -28(%ebp)
	movl	$my_handler, (%esp)
	call	register_handler
	call	get_ds
	movzwl	%ax, %ebx
	call	get_cs
	movzwl	%ax, %eax
	movl	%ebx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$.LC19, (%esp)
	call	outb_printf
	movl	$.LC20, (%esp)
	call	outb_printf
	movl	$.LC20, (%esp)
	call	outb_printf
	call	get_ds
	movzwl	%ax, %ebx
	call	get_cs
	movzwl	%ax, %eax
	movl	%ebx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$.LC19, (%esp)
	call	printf
	movl	$.LC20, (%esp)
	call	printf
	movl	$.LC20, (%esp)
	call	printf
	movl	$.LC21, (%esp)
	call	printf
	call	fork
	movl	%eax, -32(%ebp)
	movl	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC22, (%esp)
	call	printf
	movl	$.LC23, (%esp)
	call	printf
	cmpl	$0, -32(%ebp)
	jne	.L59
	movl	$1, -16(%ebp)
	jmp	.L60
.L61:
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	fak
	movl	%eax, 8(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC24, (%esp)
	call	printf
	addl	$1, -16(%ebp)
.L60:
	cmpl	$9, -16(%ebp)
	jle	.L61
	movl	$998, testq
	movl	$0, -20(%ebp)
.L66:
	movl	$0, -20(%ebp)
	jmp	.L62
.L63:
	movl	$0, (%esp)
	call	getc
	movl	%eax, -20(%ebp)
.L62:
	movl	-20(%ebp), %eax
	shrl	$16, %eax
	movzbl	%al, %eax
	testl	%eax, %eax
	je	.L63
	movl	-20(%ebp), %eax
	shrl	$16, %eax
	movb	%al, -33(%ebp)
	cmpb	$13, -33(%ebp)
	jne	.L64
	movl	$.LC25, (%esp)
	call	printf
	jmp	.L66
.L64:
	movzbl	-33(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC17, (%esp)
	call	printf
	jmp	.L66
.L59:
	movl	$256, -296(%ebp)
	movl	$.LC26, 4(%esp)
	movl	$3, (%esp)
	call	fprintf
	leal	-296(%ebp), %eax
	movl	%eax, 12(%esp)
	leal	-289(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$3, 4(%esp)
	movl	$2, (%esp)
	call	readline_echo
	movl	$.LC18, 4(%esp)
	movl	$3, (%esp)
	call	fprintf
	movl	-296(%ebp), %eax
	leal	-816(%ebp), %edx
	movl	%edx, 16(%esp)
	leal	-300(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	$.LC27, 8(%esp)
	movl	%eax, 4(%esp)
	leal	-289(%ebp), %eax
	movl	%eax, (%esp)
	call	parse_buf
	movl	$0, -12(%ebp)
	jmp	.L67
.L68:
	movl	-12(%ebp), %eax
	movl	-816(%ebp,%eax,4), %eax
	movl	%eax, 12(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC28, 4(%esp)
	movl	$3, (%esp)
	call	fprintf
	addl	$1, -12(%ebp)
.L67:
	movl	-300(%ebp), %eax
	cmpl	-12(%ebp), %eax
	ja	.L68
	movl	-300(%ebp), %eax
	testl	%eax, %eax
	jle	.L69
	movl	-300(%ebp), %eax
	leal	-816(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$6, 4(%esp)
	movl	$my_commands, (%esp)
	call	dispatch_op
.L69:
	movl	-296(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC29, 4(%esp)
	movl	$3, (%esp)
	call	fprintf
	jmp	.L59
	.size	uproc_1, .-uproc_1
	.ident	"GCC: (GNU) 4.8.2"
