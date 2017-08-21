	.file	"userproc.c"
/APP
	.code16gcc	

/NO_APP
	.comm	global_in_de_hash_headers,2164,32
	.comm	global_in_de_lru_list,4,4
	.comm	FILE,4,4
	.text
	.type	get_cs, @function
get_cs:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
/APP
/  76 "/home/juergen/osexperi/kernel/kernel_user/stdlib.h" 1
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
/  83 "/home/juergen/osexperi/kernel/kernel_user/stdlib.h" 1
	movw %ds, %ax
/  0 "" 2
/NO_APP
	movw	%ax, -2(%ebp)
	movzwl	-2(%ebp), %eax
	leave
	ret
	.size	get_ds, .-get_ds
	.section	.rodata
.LC0:
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
	movl	$.LC0, (%esp)
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
	jne	.L7
	movl	$1, %eax
	jmp	.L8
.L7:
	movl	8(%ebp), %eax
	subl	$1, %eax
	movl	%eax, (%esp)
	call	fak
	imull	8(%ebp), %eax
.L8:
	leave
	ret
	.size	fak, .-fak
	.globl	testq
	.data
	.align 4
	.type	testq, @object
	.size	testq, 4
testq:
	.long	1
	.section	.rodata
	.align 4
.LC1:
	.string	"proc_1: presenting: the primes: cs = 0x%08x ds = 0x%08x\n"
	.align 4
.LC2:
	.string	"                                                       \n"
.LC3:
	.string	"proc1: forking\n"
.LC4:
	.string	"after fork: ret = %d\n"
.LC5:
	.string	"proc1: fork done.\n"
.LC6:
	.string	"fak(%d) = %d\n"
.LC7:
	.string	"\r\n"
.LC8:
	.string	"%c"
.LC9:
	.string	"val1 = %016lx\n"
.LC10:
	.string	"/home/bochsrc"
.LC11:
	.string	"\n\nopen done: fd = %d\n"
.LC12:
	.string	"/bochsrc.copy"
.LC13:
	.string	"\nopen done: fd_out = %d\n"
.LC14:
	.string	"%s"
	.text
	.globl	uproc_1
	.type	uproc_1, @function
uproc_1:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$212, %esp
	movl	$0, -24(%ebp)
	movl	$2, -28(%ebp)
	movl	$1610612736, %eax
	movl	(%eax), %eax
	movl	%eax, -32(%ebp)
	movl	$my_handler, (%esp)
	call	register_handler
	call	get_ds
	movzwl	%ax, %ebx
	call	get_cs
	movzwl	%ax, %eax
	movl	%ebx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$.LC1, (%esp)
	call	outb_printf
	movl	$.LC2, (%esp)
	call	outb_printf
	movl	$.LC2, (%esp)
	call	outb_printf
	call	get_ds
	movzwl	%ax, %ebx
	call	get_cs
	movzwl	%ax, %eax
	movl	%ebx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$.LC1, (%esp)
	call	printf
	movl	$.LC2, (%esp)
	call	printf
	movl	$.LC2, (%esp)
	call	printf
	movl	$.LC3, (%esp)
	call	printf
	call	fork
	movl	%eax, -36(%ebp)
	movl	-36(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC4, (%esp)
	call	printf
	movl	$.LC5, (%esp)
	call	printf
	cmpl	$0, -36(%ebp)
	jne	.L10
	movl	$1, -12(%ebp)
	jmp	.L11
.L12:
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	fak
	movl	%eax, 8(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC6, (%esp)
	call	printf
	addl	$1, -12(%ebp)
.L11:
	cmpl	$9, -12(%ebp)
	jle	.L12
	movl	$998, testq
	movl	$0, -16(%ebp)
.L17:
	movl	$0, -16(%ebp)
	jmp	.L13
.L14:
	movl	$0, (%esp)
	call	getc
	movl	%eax, -16(%ebp)
.L13:
	movl	-16(%ebp), %eax
	shrl	$16, %eax
	movzbl	%al, %eax
	testl	%eax, %eax
	je	.L14
	movl	-16(%ebp), %eax
	shrl	$16, %eax
	movb	%al, -37(%ebp)
	cmpb	$13, -37(%ebp)
	jne	.L15
	movl	$.LC7, (%esp)
	call	printf
	jmp	.L17
.L15:
	movzbl	-37(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC8, (%esp)
	call	printf
	jmp	.L17
.L10:
	movl	$-889275714, 4(%esp)
	movl	$-559038242, 8(%esp)
	movl	$.LC9, (%esp)
	call	outb_printf
	movl	$0, 4(%esp)
	movl	$.LC10, (%esp)
	call	open
	movl	%eax, -44(%ebp)
	movl	-44(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC11, (%esp)
	call	printf
	movl	$420, 8(%esp)
	movl	$65, 4(%esp)
	movl	$.LC12, (%esp)
	call	open
	movl	%eax, -48(%ebp)
	movl	-48(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC13, (%esp)
	call	printf
	movl	$127, -52(%ebp)
	movl	$0, -56(%ebp)
.L21:
	movl	-52(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-184(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, (%esp)
	call	read
	movl	%eax, -56(%ebp)
	cmpl	$0, -56(%ebp)
	jns	.L18
	jmp	.L19
.L18:
	cmpl	$0, -56(%ebp)
	jle	.L20
	leal	-184(%ebp), %edx
	movl	-56(%ebp), %eax
	addl	%edx, %eax
	movb	$0, (%eax)
	leal	-184(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC14, (%esp)
	call	printf
	movl	-56(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-184(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	write
.L20:
	cmpl	$0, -56(%ebp)
	jne	.L21
.L19:
	movl	$0, -20(%ebp)
	jmp	.L22
.L23:
	movl	$0, -188(%ebp)
	addl	$1, -20(%ebp)
.L22:
	cmpl	$1048575, -20(%ebp)
	jle	.L23
	jmp	.L19
	.size	uproc_1, .-uproc_1
	.section	.rodata
.LC15:
	.string	"esp = 0x%08x\n"
.LC16:
	.string	"ss = 0x%08x\n"
.LC17:
	.string	"esp0 = 0x%08x\n"
.LC18:
	.string	"ss0 = 0x%08x\n"
.LC19:
	.string	"ebp = 0x%08x\n"
.LC20:
	.string	"ebx = 0x%08x\n"
.LC21:
	.string	"eax = 0x%08x\n"
.LC22:
	.string	"ecx = 0x%08x\n"
.LC23:
	.string	"edx = 0x%08x\n"
.LC24:
	.string	"esi = 0x%08x\n"
.LC25:
	.string	"edi = 0x%08x\n"
.LC26:
	.string	"ds = 0x%08x\n"
.LC27:
	.string	"es = 0x%08x\n"
	.text
	.globl	display_tss
	.type	display_tss, @function
display_tss:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC15, (%esp)
	call	printf
	movl	8(%ebp), %eax
	movzwl	80(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, 4(%esp)
	movl	$.LC16, (%esp)
	call	printf
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC17, (%esp)
	call	printf
	movl	8(%ebp), %eax
	movzwl	8(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, 4(%esp)
	movl	$.LC18, (%esp)
	call	printf
	movl	8(%ebp), %eax
	movl	60(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC19, (%esp)
	call	printf
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC20, (%esp)
	call	printf
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC21, (%esp)
	call	printf
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC22, (%esp)
	call	printf
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC23, (%esp)
	call	printf
	movl	8(%ebp), %eax
	movl	64(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC24, (%esp)
	call	printf
	movl	8(%ebp), %eax
	movl	68(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC25, (%esp)
	call	printf
	movl	8(%ebp), %eax
	movzwl	84(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, 4(%esp)
	movl	$.LC26, (%esp)
	call	printf
	movl	8(%ebp), %eax
	movzwl	72(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, 4(%esp)
	movl	$.LC27, (%esp)
	call	printf
	leave
	ret
	.size	display_tss, .-display_tss
	.ident	"GCC: (GNU) 4.8.2"
