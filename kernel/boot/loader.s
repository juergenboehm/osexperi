	.file	"loader.c"
/APP
	.code16gcc	

/NO_APP
	.comm	diskbuf_global,4,4
	.comm	dapa_global,16,8
	.comm	mm_block,48,8
	.section	.rodata
.LC0:
	.string	"*** osexperi starting ***\r\n"
.LC1:
	.string	"\r\nPointer Size = "
.LC2:
	.string	"Pointer Size = "
.LC3:
	.string	"boot/loader.c"
.LC4:
	.string	":"
.LC5:
	.string	"int Size = "
.LC6:
	.string	"Pointer Content = "
.LC7:
	.string	"\r\nDisk trial access done.\r\n"
.LC8:
	.string	"Kernel len = "
.LC9:
	.string	"dest32 = "
.LC10:
	.string	"to do = "
.LC11:
	.string	"loadsec done: dest32 = "
.LC12:
	.string	"dest16 = "
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
	subl	$120, %esp
	movl	$16, 8(%esp)
	movl	$0, 4(%esp)
	movl	$dapa_global, (%esp)
	call	memset16
	movl	$48, 8(%esp)
	movl	$0, 4(%esp)
	movl	$mm_block, (%esp)
	call	memset16
	movl	$36864, diskbuf_global
	call	print_newline
	movl	$.LC0, (%esp)
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
	movl	$.LC1, (%esp)
	call	print_str
	movl	$4, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC2, (%esp)
	call	print_str
	movl	$4, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC3, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	$4, (%esp)
	call	print_U32
	call	print_newline
	movb	$64, -73(%ebp)
	leal	-73(%ebp), %eax
	movl	%eax, -28(%ebp)
	movl	-28(%ebp), %eax
	movl	%eax, -32(%ebp)
	movl	$.LC3, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC6, (%esp)
	call	print_str
	movl	-32(%ebp), %eax
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
	movl	$.LC7, (%esp)
	call	print_str
	movl	$13, -36(%ebp)
	movl	$1, -40(%ebp)
	movl	-40(%ebp), %eax
	movl	-36(%ebp), %edx
	addl	%edx, %eax
	movl	%eax, -44(%ebp)
	movl	$272, -48(%ebp)
	movl	$.LC3, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC8, (%esp)
	call	print_str
	movl	$139264, (%esp)
	call	print_U32
	call	print_newline
	movl	$1, -52(%ebp)
	movl	-48(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-44(%ebp), %eax
	movl	%eax, -16(%ebp)
	movw	$0, -18(%ebp)
	movw	$24576, -54(%ebp)
	movl	$1048576, -24(%ebp)
	movl	$.LC3, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC9, (%esp)
	call	print_str
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	jmp	.L2
.L5:
	movl	-12(%ebp), %eax
	cmpl	%eax, -52(%ebp)
	cmovle	-52(%ebp), %eax
	movl	%eax, -60(%ebp)
	movl	$.LC3, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC10, (%esp)
	call	print_str
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	diskbuf_global, %ecx
	movl	-60(%ebp), %eax
	movzwl	%ax, %edx
	movl	-16(%ebp), %eax
	movl	$4096, 16(%esp)
	movl	$dapa_global, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	loadsec
	movl	$.LC3, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC11, (%esp)
	call	print_str
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movzwl	-18(%ebp), %eax
	movl	-60(%ebp), %edx
	sall	$9, %edx
	addl	%edx, %eax
	movl	$65536, %edx
	cmpl	$65536, %eax
	cmovle	%eax, %edx
	movzwl	-18(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -64(%ebp)
	movzwl	-18(%ebp), %eax
	cmpw	-54(%ebp), %ax
	jae	.L3
	cmpl	$0, -64(%ebp)
	jle	.L3
	movl	$.LC3, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC12, (%esp)
	call	print_str
	movzwl	-18(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movzwl	-18(%ebp), %edx
	movl	diskbuf_global, %eax
	movzwl	%ax, %eax
	movl	%edx, 16(%esp)
	movl	$8192, 12(%esp)
	movl	-64(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$4096, (%esp)
	call	copy_segseg
	movl	%eax, -80(%ebp)
	movl	-64(%ebp), %eax
	addw	%ax, -18(%ebp)
	jmp	.L4
.L3:
	movzwl	-54(%ebp), %eax
	movw	%ax, -18(%ebp)
.L4:
	movl	$.LC3, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC13, (%esp)
	call	print_str
	movl	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	diskbuf_global, %eax
	movzwl	%ax, %eax
	addl	$65536, %eax
	movl	%eax, -68(%ebp)
	movl	$.LC3, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC14, (%esp)
	call	print_str
	movl	-68(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC3, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC15, (%esp)
	call	print_str
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	-60(%ebp), %eax
	sall	$9, %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movzwl	%ax, %eax
	movl	$4096, 16(%esp)
	movl	%eax, 12(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-68(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$mm_block, (%esp)
	call	copy_ext
	movl	%eax, -72(%ebp)
	movl	-60(%ebp), %eax
	sall	$9, %eax
	addl	%eax, -24(%ebp)
	movl	$.LC3, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC16, (%esp)
	call	print_str
	movl	-72(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	-60(%ebp), %eax
	addl	%eax, -16(%ebp)
	movl	-60(%ebp), %eax
	subl	%eax, -12(%ebp)
.L2:
	cmpl	$0, -12(%ebp)
	jg	.L5
	movl	$.LC3, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	movl	$.LC8, (%esp)
	call	print_str
	movl	$139264, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC17, (%esp)
	call	print_str
	movl	$.LC18, (%esp)
	call	print_str
	movl	$69, %eax
	leave
	ret
	.size	lmain, .-lmain
	.section	.rodata
.LC19:
	.string	"Juergen Boehm 23232323232323"
	.text
	.globl	test_disk
	.type	test_disk, @function
test_disk:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	diskbuf_global, %eax
	movl	$4096, 16(%esp)
	movl	$dapa_global, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$2, 4(%esp)
	movl	$0, (%esp)
	call	loadsec
	call	print_newline
	movl	$.LC19, -20(%ebp)
	movl	-20(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	$0, -12(%ebp)
	jmp	.L8
.L9:
	movl	diskbuf_global, %edx
	movl	-12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movzbl	(%eax), %eax
	movb	%al, (%ecx)
	addl	$1, -12(%ebp)
.L8:
	movl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L9
	movl	diskbuf_global, %edx
	movl	-12(%ebp), %eax
	addl	%eax, %edx
	movl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	movb	%al, (%edx)
	movl	diskbuf_global, %eax
	movl	%eax, (%esp)
	call	print_str
	movl	$0, %eax
	leave
	ret
	.size	test_disk, .-test_disk
	.ident	"GCC: (GNU) 4.8.2"
