	.file	"userproc.c"
#APP
	.code16gcc	

#NO_APP
	.comm	FILE,4,4
	.text
	.type	uget_cs, @function
uget_cs:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
#APP
# 67 "/home/juergen/osexperi/kernel/kernel_user/stdlib.h" 1
	movw %cs, %ax
# 0 "" 2
#NO_APP
	movw	%ax, -2(%ebp)
	movw	-2(%ebp), %ax
	leave
	ret
	.size	uget_cs, .-uget_cs
	.type	uget_ds, @function
uget_ds:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
#APP
# 74 "/home/juergen/osexperi/kernel/kernel_user/stdlib.h" 1
	movw %ds, %ax
# 0 "" 2
#NO_APP
	movw	%ax, -2(%ebp)
	movw	-2(%ebp), %ax
	leave
	ret
	.size	uget_ds, .-uget_ds
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
	call	uoutb_printf
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
	decl	%eax
	movl	%eax, (%esp)
	call	fak
	imull	8(%ebp), %eax
.L8:
	leave
	ret
	.size	fak, .-fak
	.section	.rodata
	.align 4
.LC1:
	.string	"proc_1: presenting: the primes: cs = 0x%08x ds = 0x%08x\n"
	.align 4
.LC2:
	.string	"                                                       \n"
.LC3:
	.string	"proc1: forking"
.LC4:
	.string	"after fork: ret = %d\n"
.LC5:
	.string	"proc1: fork done."
.LC6:
	.string	"fak(%d) = %d\n"
.LC7:
	.string	" %d "
.LC8:
	.string	"\n"
	.text
	.globl	uproc_1
	.type	uproc_1, @function
uproc_1:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$52, %esp
	movl	$0, -20(%ebp)
	movl	$2, -12(%ebp)
	movl	$my_handler, (%esp)
	call	register_handler
	call	uget_ds
	movzwl	%ax, %ebx
	call	uget_cs
	movzwl	%ax, %eax
	movl	%ebx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$.LC1, (%esp)
	call	uprintf
	movl	$.LC2, (%esp)
	call	uprintf
	movl	$.LC2, (%esp)
	call	uprintf
	movl	$.LC3, (%esp)
	call	uprintf
	call	fork
	movl	%eax, -32(%ebp)
	movl	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC4, (%esp)
	call	uprintf
	movl	$.LC5, (%esp)
	call	uprintf
	cmpl	$0, -32(%ebp)
	jne	.L10
	movl	$1, -24(%ebp)
	jmp	.L11
.L12:
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	fak
	movl	%eax, 8(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC6, (%esp)
	call	uprintf
	incl	-24(%ebp)
.L11:
	cmpl	$9, -24(%ebp)
	jle	.L12
.L10:
	movl	$0, -28(%ebp)
	jmp	.L13
.L14:
	movl	$0, -36(%ebp)
	incl	-28(%ebp)
.L13:
	cmpl	$167772159, -28(%ebp)
	jle	.L14
	jmp	.L15
.L21:
	movl	$2, -16(%ebp)
	jmp	.L16
.L19:
	movl	-12(%ebp), %eax
	movl	$0, %edx
	divl	-16(%ebp)
	movl	%edx, %eax
	testl	%eax, %eax
	jne	.L17
	movl	$0, -16(%ebp)
	jmp	.L18
.L17:
	incl	-16(%ebp)
.L16:
	movl	-16(%ebp), %eax
	imull	-16(%ebp), %eax
	cmpl	-12(%ebp), %eax
	jbe	.L19
.L18:
	cmpl	$0, -16(%ebp)
	je	.L20
	incl	-20(%ebp)
	movl	-12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC7, (%esp)
	call	uprintf
	movl	-20(%ebp), %eax
	andl	$3, %eax
	testl	%eax, %eax
	jne	.L20
	movl	$.LC8, (%esp)
	call	uprintf
.L20:
	incl	-12(%ebp)
.L15:
	cmpl	$1073741823, -12(%ebp)
	jbe	.L21
.L22:
	jmp	.L22
	.size	uproc_1, .-uproc_1
	.section	.rodata
.LC9:
	.string	"esp = 0x%08x\n"
.LC10:
	.string	"ss = 0x%08x\n"
.LC11:
	.string	"esp0 = 0x%08x\n"
.LC12:
	.string	"ss0 = 0x%08x\n"
.LC13:
	.string	"ebp = 0x%08x\n"
.LC14:
	.string	"ebx = 0x%08x\n"
.LC15:
	.string	"eax = 0x%08x\n"
.LC16:
	.string	"ecx = 0x%08x\n"
.LC17:
	.string	"edx = 0x%08x\n"
.LC18:
	.string	"esi = 0x%08x\n"
.LC19:
	.string	"edi = 0x%08x\n"
.LC20:
	.string	"ds = 0x%08x\n"
.LC21:
	.string	"es = 0x%08x\n"
	.text
	.globl	udisplay_tss
	.type	udisplay_tss, @function
udisplay_tss:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC9, (%esp)
	call	uprintf
	movl	8(%ebp), %eax
	movw	80(%eax), %ax
	movzwl	%ax, %eax
	movl	%eax, 4(%esp)
	movl	$.LC10, (%esp)
	call	uprintf
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC11, (%esp)
	call	uprintf
	movl	8(%ebp), %eax
	movw	8(%eax), %ax
	movzwl	%ax, %eax
	movl	%eax, 4(%esp)
	movl	$.LC12, (%esp)
	call	uprintf
	movl	8(%ebp), %eax
	movl	60(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC13, (%esp)
	call	uprintf
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC14, (%esp)
	call	uprintf
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC15, (%esp)
	call	uprintf
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC16, (%esp)
	call	uprintf
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC17, (%esp)
	call	uprintf
	movl	8(%ebp), %eax
	movl	64(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC18, (%esp)
	call	uprintf
	movl	8(%ebp), %eax
	movl	68(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC19, (%esp)
	call	uprintf
	movl	8(%ebp), %eax
	movw	84(%eax), %ax
	movzwl	%ax, %eax
	movl	%eax, 4(%esp)
	movl	$.LC20, (%esp)
	call	uprintf
	movl	8(%ebp), %eax
	movw	72(%eax), %ax
	movzwl	%ax, %eax
	movl	%eax, 4(%esp)
	movl	$.LC21, (%esp)
	call	uprintf
	leave
	ret
	.size	udisplay_tss, .-udisplay_tss
	.ident	"GCC: (GNU) 4.8.2 20140120 (Red Hat 4.8.2-15)"
	.section	.note.GNU-stack,"",@progbits
