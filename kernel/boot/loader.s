	.file	"loader.c"
#APP
	.code16gcc	

	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Juergen Boehm 23232323232323"
#NO_APP
	.text
	.globl	test_disk
	.type	test_disk, @function
test_disk:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	pushl	$4096
	pushl	$dapa_global
	pushl	diskbuf_global
	pushl	$2
	pushl	$0
	call	loadsec
	addl	$32, %esp
	call	print_newline
	xorl	%eax, %eax
.L2:
	movb	.LC0(%eax), %cl
	testb	%cl, %cl
	movl	diskbuf_global, %edx
	je	.L6
	movb	%cl, (%edx,%eax)
	incl	%eax
	jmp	.L2
.L6:
	movb	$0, (%edx,%eax)
	subl	$12, %esp
	pushl	diskbuf_global
	call	print_str
	xorl	%eax, %eax
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
	.globl	lmain
	.type	lmain, @function
lmain:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
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
	movb	$64, -29(%ebp)
	leal	-29(%ebp), %ebx
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC7, (%esp)
	call	print_str
	movl	%ebx, (%esp)
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
	movl	$60416, (%esp)
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
	movl	$118, %ebx
.L11:
	imull	$-512, %ebx, %esi
	addl	$1108992, %esi
	subl	$12, %esp
	pushl	$.LC4
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC11, (%esp)
	call	print_str
	movl	%ebx, (%esp)
	call	print_U32
	call	print_newline
	movl	$4096, (%esp)
	pushl	$dapa_global
	pushl	diskbuf_global
	pushl	$1
	movl	$128, %eax
	subl	%ebx, %eax
	pushl	%eax
	call	loadsec
	addl	$20, %esp
	pushl	$.LC4
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC12, (%esp)
	call	print_str
	movl	%esi, (%esp)
	call	print_U32
	call	print_newline
	movzwl	-42(%ebp), %eax
	leal	512(%eax), %edi
	addl	$16, %esp
	cmpl	$65536, %edi
	jle	.L8
	movl	$65536, %edi
.L8:
	subl	%eax, %edi
	testl	%edi, %edi
	jle	.L9
	subl	$12, %esp
	pushl	%eax
	pushl	$8192
	pushl	%edi
	movzwl	diskbuf_global, %eax
	pushl	%eax
	pushl	$4096
	call	copy_segseg
	movl	%eax, -28(%ebp)
	addw	%di, -42(%ebp)
	addl	$32, %esp
.L9:
	subl	$12, %esp
	pushl	$.LC4
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC13, (%esp)
	call	print_str
	movl	%edi, (%esp)
	call	print_U32
	call	print_newline
	movzwl	diskbuf_global, %edi
	addl	$65536, %edi
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC14, (%esp)
	call	print_str
	movl	%edi, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC15, (%esp)
	call	print_str
	movl	%esi, (%esp)
	call	print_U32
	call	print_newline
	movl	$4096, (%esp)
	pushl	$256
	pushl	%esi
	pushl	%edi
	pushl	$mm_block
	call	copy_ext
	movl	%eax, %esi
	addl	$20, %esp
	pushl	$.LC4
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$.LC16, (%esp)
	call	print_str
	movl	%esi, (%esp)
	call	print_U32
	call	print_newline
	addl	$16, %esp
	decl	%ebx
	jne	.L11
	subl	$12, %esp
	pushl	$.LC17
	call	print_str
	movl	$.LC18, (%esp)
	call	print_str
	movl	$69, %eax
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	lmain, .-lmain
	.comm	mm_block,48,8
	.comm	dapa_global,16,8
	.comm	diskbuf_global,4,4
	.ident	"GCC: (GNU) 4.8.2 20140120 (Red Hat 4.8.2-15)"
	.section	.note.GNU-stack,"",@progbits
