	.file	"bioslib.c"
#APP
	.code16gcc	

#NO_APP
	.text
.globl copy_ext
	.type	copy_ext, @function
copy_ext:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	pushl	%esi
	movl	16(%ebp), %ecx
	pushl	%ebx
	andb	$48, 22(%edx)
	movl	%eax, %ebx
	movw	%ax, 18(%edx)
	shrl	$24, %eax
	movb	%al, 23(%edx)
	movb	21(%edx), %al
	shrl	$16, %ebx
	movw	%cx, 26(%edx)
	andb	$48, 30(%edx)
	andl	$1, %eax
	orl	$-112, %eax
	movb	%al, 21(%edx)
	movl	%ecx, %eax
	shrl	$16, %eax
	movb	%al, 28(%edx)
	movb	29(%edx), %al
	shrl	$24, %ecx
	movb	%bl, 20(%edx)
	movw	$-1, 16(%edx)
	movb	%cl, 31(%edx)
	andl	$1, %eax
	orl	$-112, %eax
	orl	$2, %eax
	movw	$-1, 24(%edx)
	movb	%al, 29(%edx)
	movl	$0, (%edx)
	movl	$0, 4(%edx)
	movl	$0, 8(%edx)
	movl	$0, 12(%edx)
	movl	$0, 32(%edx)
	movl	$0, 36(%edx)
	movl	$0, 40(%edx)
	movl	$0, 44(%edx)
#APP
# 62 "libs16/bioslib.c" 1
	push %es 
	movw 24(%ebp), %ax
	movw %ax, %es
	movw %dx, %si
	movw 20(%ebp), %cx
	movw $0x8700, %ax
	int  $0x15
	pop  %es
	movl $0, %eax
	rcll	$1, %eax
	movw %ax, %dx
	
# 0 "" 2
#NO_APP
	movzwl	%dx, %eax
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	copy_ext, .-copy_ext
.globl print_char
	.type	print_char, @function
print_char:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$4, %esp
	movl	8(%ebp), %eax
	movb	%al, -8(%ebp)
#APP
# 88 "libs16/bioslib.c" 1
	movb	-8(%ebp), %al
# 0 "" 2
# 89 "libs16/bioslib.c" 1
	movb $0x0e, %ah
# 0 "" 2
# 90 "libs16/bioslib.c" 1
	movb	$0x00, %bh
# 0 "" 2
# 91 "libs16/bioslib.c" 1
	movb	$0x0c, %bl
# 0 "" 2
# 92 "libs16/bioslib.c" 1
	int $0x10
# 0 "" 2
#NO_APP
	popl	%eax
	popl	%ebx
	popl	%ebp
	ret
	.size	print_char, .-print_char
.globl init_DAPA
	.type	init_DAPA, @function
init_DAPA:
	pushl	%ebp
	movl	%esp, %ebp
	movl	20(%ebp), %eax
	movb	$16, (%eax)
	movb	$0, 1(%eax)
	movl	12(%ebp), %edx
	movw	%dx, 2(%eax)
	movl	16(%ebp), %edx
	movw	%dx, 4(%eax)
	movl	24(%ebp), %edx
	movw	%dx, 6(%eax)
	movl	8(%ebp), %edx
	movl	$0, 12(%eax)
	movl	%edx, 8(%eax)
	xorl	%eax, %eax
	popl	%ebp
	ret
	.size	init_DAPA, .-init_DAPA
.globl loadsec
	.type	loadsec, @function
loadsec:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$4, %esp
	movl	24(%ebp), %eax
	movl	20(%ebp), %ebx
	movzwl	12(%ebp), %edx
	movw	%ax, -12(%ebp)
	movzwl	%ax, %eax
	pushl	%eax
	pushl	%ebx
	pushl	16(%ebp)
	pushl	%edx
	pushl	8(%ebp)
	call	init_DAPA
#APP
# 126 "libs16/bioslib.c" 1
	movw %bx, %si
# 0 "" 2
# 127 "libs16/bioslib.c" 1
	movw -12(%ebp), %ax 
	 movw %ax, %ds
# 0 "" 2
# 128 "libs16/bioslib.c" 1
	movb $66, %ah
# 0 "" 2
# 129 "libs16/bioslib.c" 1
	movb $128, %dl
# 0 "" 2
# 130 "libs16/bioslib.c" 1
	int $0x13
# 0 "" 2
#NO_APP
	xorl	%eax, %eax
	leal	-8(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	loadsec, .-loadsec
.globl writesec
	.type	writesec, @function
writesec:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$4, %esp
	movl	24(%ebp), %eax
	movl	20(%ebp), %ebx
	movzwl	12(%ebp), %edx
	movw	%ax, -12(%ebp)
	movzwl	%ax, %eax
	pushl	%eax
	pushl	%ebx
	pushl	16(%ebp)
	pushl	%edx
	pushl	8(%ebp)
	call	init_DAPA
#APP
# 140 "libs16/bioslib.c" 1
	movw %bx, %si
# 0 "" 2
# 141 "libs16/bioslib.c" 1
	movw -12(%ebp), %ax 
	 movw %ax, %ds
# 0 "" 2
# 142 "libs16/bioslib.c" 1
	movb $67, %ah
# 0 "" 2
# 143 "libs16/bioslib.c" 1
	movb $128, %dl
# 0 "" 2
# 144 "libs16/bioslib.c" 1
	int $0x13
# 0 "" 2
#NO_APP
	xorl	%eax, %eax
	leal	-8(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	writesec, .-writesec
.globl loadsec_fd
	.type	loadsec_fd, @function
loadsec_fd:
	pushl	%ebp
	movl	$18, %ecx
	movl	%esp, %ebp
	pushl	%edi
	xorl	%edi, %edi
	pushl	%esi
	movl	$1, %esi
	pushl	%ebx
	subl	$20, %esp
	movl	24(%ebp), %edx
	movl	8(%ebp), %eax
	movw	%dx, -32(%ebp)
	movl	12(%ebp), %edx
	movb	%dl, -13(%ebp)
	xorl	%edx, %edx
	divl	%ecx
	movb	%al, %cl
	incl	%edx
	andl	$1, %ecx
	movb	%cl, -14(%ebp)
	movl	%eax, %ecx
	shrw	$3, %ax
	andl	$-64, %eax
	orl	%edx, %eax
	movb	%al, -16(%ebp)
	movl	16(%ebp), %eax
	shrw	%cx
	movb	%cl, -15(%ebp)
	movw	%ax, -18(%ebp)
	jmp	.L12
.L13:
#APP
# 180 "libs16/bioslib.c" 1
	push	%es 
	movw -32(%ebp), %ax 
	 movw %ax, %es 
	 movw -18(%ebp), %bx 
	 movb $0x02, %ah 
	 movb -13(%ebp), %al 
	 movb -15(%ebp), %ch 
	 movb -16(%ebp), %cl 
	 movb -14(%ebp), %dh 
	 movb $0, %dl 
	 int $0x13 
	movl $0x0, %eax 
	 rcll $1, %eax 
	 movl %eax, %esi 
	 pop %es 
	
# 0 "" 2
#NO_APP
	incl	%edi
.L12:
	movl	%edi, %eax
	cmpb	$2, %al
	ja	.L16
	testl	%esi, %esi
	jne	.L13
.L16:
	addl	$20, %esp
	movl	%esi, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	loadsec_fd, .-loadsec_fd
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"libs16/bioslib.c"
.LC1:
	.string	":"
.LC2:
	.string	"size_entry: "
.LC3:
	.string	"get_mem_map_first: err: "
.LC4:
	.string	"get_mem_map_first: ebx_val: "
.LC5:
	.string	"get_mem_map_first: err (second): "
	.text
.globl get_mem_map_step
	.type	get_mem_map_step, @function
get_mem_map_step:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$56, %esp
	movl	24(%ebp), %eax
	movl	12(%ebp), %esi
	movl	(%eax), %eax
	movb	$0, -25(%ebp)
	movl	%eax, -48(%ebp)
#APP
# 225 "libs16/bioslib.c" 1
	pushw %es 
	movw 8(%ebp), %ax 
	movw %ax, %es 
	movw %si, %di 
	movl -48(%ebp), %ebx 
	movl $0x534D4150, %edx 
	movl $24, %ecx 
	movl $0xe820, %eax 
	int	$0x15 
	movb %cl, -25(%ebp) 
	cmp $0x18, %cl 
	.L9900: je 1f 
	addw $0x14, %di 
	movl $0xffffffff, %es:(%di) 
	1: movl $0x0, %edx 
	rcll $1, %edx 
	movl %edx, %esi 
	movl %ebx, -44(%ebp) 
	popw %es 
	
# 0 "" 2
#NO_APP
	movl	-44(%ebp), %eax
	movl	24(%ebp), %edx
	movl	%eax, (%edx)
	movl	12(%ebp), %edx
	movl	20(%ebp), %eax
	addl	$24, %edx
	movl	%edx, (%eax)
	pushl	$.LC0
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC2, (%esp)
	call	print_str
	movb	-25(%ebp), %al
	movzbl	%al, %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC3, (%esp)
	call	print_str
	movl	%esi, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	popl	%edx
	pushl	-44(%ebp)
	call	print_U32
	call	print_newline
	addl	$16, %esp
	testl	%esi, %esi
	je	.L19
	cmpl	$0, -44(%ebp)
	movl	$1, %eax
	jne	.L20
.L19:
	testl	%esi, %esi
	sete	%al
	cmpl	$0, -44(%ebp)
	sete	%dl
	andl	%edx, %eax
	movzbl	%al, %eax
.L20:
	movl	16(%ebp), %edx
	subl	$12, %esp
	movl	%eax, (%edx)
	pushl	$.LC0
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	%esi, (%esp)
	call	print_U32
	call	print_newline
	leal	-12(%ebp), %esp
	movl	%esi, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	get_mem_map_step, .-get_mem_map_step
	.section	.rodata.str1.1
.LC6:
	.string	"get_mem_map: len_map: "
.LC7:
	.string	"get_mem_map: increment len_map"
.LC8:
	.string	"get_mem_map: increment len_map (after)"
.LC9:
	.string	"get_mem_map: ebx:"
	.text
.globl get_mem_map
	.type	get_mem_map, @function
get_mem_map:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$56, %esp
	movl	16(%ebp), %ebx
	pushl	$.LC0
	movl	12(%ebp), %esi
	movzwl	8(%ebp), %edi
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC6, (%esp)
	call	print_str
	movl	%ebx, (%esp)
	call	print_U32
	call	print_newline
	leal	-32(%ebp), %eax
	movl	%eax, (%esp)
	leal	-28(%ebp), %eax
	pushl	%eax
	leal	-36(%ebp), %eax
	pushl	%eax
	pushl	%esi
	pushl	%edi
	movl	%esi, -28(%ebp)
	movl	$0, -32(%ebp)
	movl	$0, -36(%ebp)
	call	get_mem_map_step
	addl	$32, %esp
	testl	%eax, %eax
	movl	%eax, %esi
	jne	.L23
	subl	$12, %esp
	pushl	$.LC0
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC7, (%esp)
	call	print_str
	popl	%edx
	pushl	(%ebx)
	call	print_U32
	call	print_newline
	incl	(%ebx)
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC8, (%esp)
	call	print_str
	popl	%eax
	pushl	(%ebx)
	call	print_U32
	call	print_newline
	addl	$16, %esp
.L23:
	subl	$12, %esp
	pushl	$.LC0
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC9, (%esp)
	call	print_str
	popl	%ecx
	pushl	-32(%ebp)
	call	print_U32
	call	print_newline
	addl	$16, %esp
	testl	%esi, %esi
	je	.L28
	jmp	.L25
.L26:
	subl	$12, %esp
	pushl	%edx
	pushl	%ecx
	leal	-36(%ebp), %eax
	pushl	%eax
	pushl	-28(%ebp)
	movl	%edx, -44(%ebp)
	movl	%ecx, -48(%ebp)
	pushl	%edi
	call	get_mem_map_step
	addl	$32, %esp
	movl	-44(%ebp), %edx
	movl	-48(%ebp), %ecx
	testl	%eax, %eax
	movl	%eax, %esi
	jne	.L25
	incl	(%ebx)
	jmp	.L29
.L28:
	leal	-32(%ebp), %edx
	leal	-28(%ebp), %ecx
.L29:
	cmpl	$0, -36(%ebp)
	je	.L26
.L25:
	leal	-12(%ebp), %esp
	movl	%esi, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	get_mem_map, .-get_mem_map
	.section	.rodata.str1.1
.LC10:
	.string	"copy_segseg: target = "
	.text
.globl copy_segseg
	.type	copy_segseg, @function
copy_segseg:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$40, %esp
	movl	8(%ebp), %eax
	pushl	$.LC0
	movl	24(%ebp), %ebx
	movw	%ax, -28(%ebp)
	movl	12(%ebp), %eax
	movw	%ax, -30(%ebp)
	movl	20(%ebp), %eax
	movw	%ax, -26(%ebp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC10, (%esp)
	call	print_str
	movzwl	-26(%ebp), %eax
	movzwl	%bx, %edx
	sall	$4, %eax
	leal	(%edx,%eax), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
#APP
# 13 "libs16/bioslib.c" 1
	push %es 
	 push %fs 
	movw -28(%ebp), %ax 
	movw %ax, %es 
	movw -26(%ebp), %ax 
	movw %ax, %fs 
	movw -30(%ebp), %si 
	movw %bx, %di 
	movl 16(%ebp), %ecx 
	.LOOPXXX: 
	 movb %es:(%si), %al 
	movb %al, %fs:(%di) 
	inc %si 
	inc %di 
	decl %ecx 
	cmp $0, %cx 
	jne .LOOPXXX 
	pop %fs 
	 pop %es 
	 
# 0 "" 2
#NO_APP
	xorl	%eax, %eax
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	copy_segseg, .-copy_segseg
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5.1) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
