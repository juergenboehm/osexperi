	.file	"loader.c"
#APP
	.code16gcc	

	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Juergen Boehm 23232323232323"
#NO_APP
	.text
.globl test_disk
	.type	test_disk, @function
test_disk:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$16, %esp
	pushl	$4096
	pushl	$dapa_global
	pushl	diskbuf_global
	pushl	$2
	pushl	$0
	call	loadsec
	addl	$32, %esp
	call	print_newline
	movl	$.LC0, %edx
	xorl	%eax, %eax
	jmp	.L2
.L3:
	movb	%bl, (%ecx,%eax)
	incl	%edx
	incl	%eax
.L2:
	movb	(%edx), %bl
	movl	diskbuf_global, %ecx
	testb	%bl, %bl
	jne	.L3
	movb	$0, (%ecx,%eax)
	subl	$12, %esp
	pushl	diskbuf_global
	call	print_str
	xorl	%eax, %eax
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	test_disk, .-test_disk
	.section	.rodata.str1.1
.LC1:
	.string	"*** PROTOS starting ***\r\n"
.LC2:
	.string	"\r\nPointer Size = "
.LC3:
	.string	"Pointer Size = "
.LC4:
	.string	"boot/loader.c"
.LC5:
	.string	":"
.LC6:
	.string	"int Size = "
.LC7:
	.string	"Pointer Content = "
.LC8:
	.string	"\r\nDisk trial access done.\r\n"
.LC9:
	.string	"Kernel len = "
.LC10:
	.string	"dest32 = "
.LC11:
	.string	"to do = "
.LC12:
	.string	"loadsec done: dest32 = "
.LC13:
	.string	"copy segseg done: to_move = "
.LC14:
	.string	"src = "
.LC15:
	.string	"dest = "
.LC16:
	.string	"ok = "
.LC17:
	.string	"Load 4 done.\r\n"
.LC18:
	.string	"Kernel image moved.\r\n"
	.text
.globl lmain
	.type	lmain, @function
lmain:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	movl	$1048576, %edi
	pushl	%esi
	movl	$75, %esi
	pushl	%ebx
	subl	$44, %esp
	movl	$36864, diskbuf_global
	call	print_newline
	subl	$12, %esp
	pushl	$.LC1
	call	print_str
	call	print_newline
	movl	$1, (%esp)
	call	print_U32
	call	print_newline
	movl	$2, (%esp)
	call	print_U32
	call	print_newline
	movl	$4, (%esp)
	call	print_U32
	movl	$.LC2, (%esp)
	call	print_str
	movl	$4, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC3, (%esp)
	call	print_str
	movl	$4, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC6, (%esp)
	call	print_str
	movl	$4, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC4, (%esp)
	movb	$64, -25(%ebp)
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC7, (%esp)
	call	print_str
	leal	-25(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	call	print_newline
	movl	$287454020, (%esp)
	call	print_U32
	call	print_newline
	movl	$-1430532899, (%esp)
	call	print_U32
	call	test_disk
	movl	$.LC8, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC9, (%esp)
	call	print_str
	movl	$38400, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC10, (%esp)
	call	print_str
	movl	$1048576, (%esp)
	call	print_U32
	call	print_newline
	addl	$16, %esp
	movw	$0, -42(%ebp)
.L9:
	subl	$12, %esp
	pushl	$.LC4
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC11, (%esp)
	call	print_str
	movl	%esi, (%esp)
	call	print_U32
	call	print_newline
	movl	$86, %eax
	movl	$4096, (%esp)
	subl	%esi, %eax
	pushl	$dapa_global
	pushl	diskbuf_global
	pushl	$1
	pushl	%eax
	call	loadsec
	addl	$20, %esp
	pushl	$.LC4
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC12, (%esp)
	call	print_str
	movl	%edi, (%esp)
	call	print_U32
	call	print_newline
	movzwl	-42(%ebp), %eax
	addl	$16, %esp
	movl	$65536, %edx
	leal	512(%eax), %ebx
	cmpl	$65536, %ebx
	cmovg	%edx, %ebx
	subl	%eax, %ebx
	testl	%ebx, %ebx
	jle	.L7
	subl	$12, %esp
	pushl	%eax
	movzwl	diskbuf_global, %eax
	pushl	$8192
	pushl	%ebx
	pushl	%eax
	pushl	$4096
	call	copy_segseg
	addl	$32, %esp
	addw	%bx, -42(%ebp)
	movl	%eax, -32(%ebp)
.L7:
	subl	$12, %esp
	pushl	$.LC4
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC13, (%esp)
	call	print_str
	movl	%ebx, (%esp)
	call	print_U32
	call	print_newline
	movl	diskbuf_global, %ebx
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC5, (%esp)
	andl	$65535, %ebx
	addl	$65536, %ebx
	call	print_str
	movl	$.LC14, (%esp)
	call	print_str
	movl	%ebx, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC15, (%esp)
	call	print_str
	movl	%edi, (%esp)
	call	print_U32
	call	print_newline
	movl	$4096, (%esp)
	pushl	$256
	pushl	%edi
	pushl	%ebx
	pushl	$mm_block
	call	copy_ext
	addl	$20, %esp
	pushl	$.LC4
	movl	%eax, %ebx
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC16, (%esp)
	call	print_str
	movl	%ebx, (%esp)
	call	print_U32
	call	print_newline
	addl	$16, %esp
	decl	%esi
	je	.L8
	addl	$512, %edi
	jmp	.L9
.L8:
	subl	$12, %esp
	pushl	$.LC17
	call	print_str
	movl	$.LC18, (%esp)
	call	print_str
	leal	-12(%ebp), %esp
	movl	$69, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	lmain, .-lmain
	.comm	diskbuf_global,4,4
	.comm	dapa_global,16,8
	.comm	mm_block,48,8
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5.1) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
