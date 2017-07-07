	.file	"bioslib.c"
#APP
	.code16gcc	

	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"libs16/bioslib.c"
.LC1:
	.string	":"
.LC2:
	.string	"copy_segseg: target = "
#NO_APP
	.text
	.globl	copy_segseg
	.type	copy_segseg, @function
copy_segseg:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	%eax, -32(%ebp)
	movl	12(%ebp), %ecx
	movl	%ecx, -36(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, %esi
	movl	24(%ebp), %ebx
	pushl	$.LC0
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC2, (%esp)
	call	print_str
	movl	%esi, -28(%ebp)
	movzwl	-28(%ebp), %eax
	sall	$4, %eax
	movzwl	%bx, %edx
	addl	%edx, %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
#APP
# 13 "libs16/bioslib.c" 1
	push %es 
	 push %fs 
	movw -32(%ebp), %ax 
	movw %ax, %es 
	movw -28(%ebp), %ax 
	movw %ax, %fs 
	movw -36(%ebp), %si 
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
	.globl	copy_ext
	.type	copy_ext, @function
copy_ext:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	movl	16(%ebp), %ecx
	movw	%ax, 18(%edx)
	movl	%eax, %ebx
	shrl	$16, %ebx
	movb	%bl, 20(%edx)
	shrl	$24, %eax
	movb	%al, 23(%edx)
	movw	$-1, 16(%edx)
	andb	$48, 22(%edx)
	movb	21(%edx), %al
	andl	$-111, %eax
	orl	$-112, %eax
	movb	%al, 21(%edx)
	movw	%cx, 26(%edx)
	movl	%ecx, %eax
	shrl	$16, %eax
	movb	%al, 28(%edx)
	shrl	$24, %ecx
	movb	%cl, 31(%edx)
	movw	$-1, 24(%edx)
	andb	$48, 30(%edx)
	movb	29(%edx), %al
	andl	$1, %eax
	orl	$-112, %eax
	orl	$2, %eax
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
	.globl	print_char
	.type	print_char, @function
print_char:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%eax
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
	popl	%edx
	popl	%ebx
	popl	%ebp
	ret
	.size	print_char, .-print_char
	.globl	init_DAPA
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
	movl	%edx, 8(%eax)
	movl	$0, 12(%eax)
	xorl	%eax, %eax
	popl	%ebp
	ret
	.size	init_DAPA, .-init_DAPA
	.globl	loadsec
	.type	loadsec, @function
loadsec:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	pushl	%eax
	movl	20(%ebp), %ebx
	movl	24(%ebp), %eax
	movw	%ax, -12(%ebp)
	movzwl	%ax, %eax
	pushl	%eax
	pushl	%ebx
	pushl	16(%ebp)
	movzwl	12(%ebp), %eax
	pushl	%eax
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
	.globl	writesec
	.type	writesec, @function
writesec:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	pushl	%eax
	movl	20(%ebp), %ebx
	movl	24(%ebp), %eax
	movw	%ax, -12(%ebp)
	movzwl	%ax, %eax
	pushl	%eax
	pushl	%ebx
	pushl	16(%ebp)
	movzwl	12(%ebp), %eax
	pushl	%eax
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
	.globl	loadsec_fd
	.type	loadsec_fd, @function
loadsec_fd:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$20, %esp
	movl	8(%ebp), %eax
	movl	24(%ebp), %edx
	movw	%dx, -32(%ebp)
	movl	12(%ebp), %edx
	movb	%dl, -18(%ebp)
	movl	$18, %ecx
	xorl	%edx, %edx
	divl	%ecx
	movb	%al, %cl
	andl	$1, %ecx
	movb	%cl, -17(%ebp)
	movl	%eax, %ecx
	shrw	%cx
	movb	%cl, -16(%ebp)
	shrw	$3, %ax
	andl	$-64, %eax
	incl	%edx
	orl	%edx, %eax
	movb	%al, -15(%ebp)
	movl	16(%ebp), %eax
	movw	%ax, -14(%ebp)
	xorl	%edi, %edi
	movl	$1, %esi
.L14:
	movl	%edi, %eax
	cmpb	$2, %al
	ja	.L17
	testl	%esi, %esi
	je	.L17
#APP
# 180 "libs16/bioslib.c" 1
	push	%es 
	movw -32(%ebp), %ax 
	 movw %ax, %es 
	 movw -14(%ebp), %bx 
	 movb $0x02, %ah 
	 movb -18(%ebp), %al 
	 movb -16(%ebp), %ch 
	 movb -15(%ebp), %cl 
	 movb -17(%ebp), %dh 
	 movb $0, %dl 
	 int $0x13 
	movl $0x0, %eax 
	 rcll $1, %eax 
	 movl %eax, %esi 
	 pop %es 
	
# 0 "" 2
#NO_APP
	incl	%edi
	jmp	.L14
.L17:
	movl	%esi, %eax
	addl	$20, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	loadsec_fd, .-loadsec_fd
	.section	.rodata.str1.1
.LC3:
	.string	"size_entry: "
.LC4:
	.string	"get_mem_map_first: err: "
.LC5:
	.string	"get_mem_map_first: ebx_val: "
.LC6:
	.string	"get_mem_map_first: err (second): "
	.text
	.globl	get_mem_map_step
	.type	get_mem_map_step, @function
get_mem_map_step:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$56, %esp
	movl	24(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -44(%ebp)
	movb	$0, -25(%ebp)
#APP
# 225 "libs16/bioslib.c" 1
	pushw %es 
	movw 8(%ebp), %ax 
	movw %ax, %es 
	movw 12(%ebp), %di 
	movl -44(%ebp), %ebx 
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
	movl	24(%ebp), %ecx
	movl	-44(%ebp), %ebx
	movl	%ebx, (%ecx)
	movl	12(%ebp), %eax
	leal	24(%eax), %edx
	movl	20(%ebp), %eax
	movl	%edx, (%eax)
	pushl	$.LC0
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC3, (%esp)
	call	print_str
	movzbl	-25(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	movl	%esi, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	%ebx, (%esp)
	call	print_U32
	call	print_newline
	addl	$16, %esp
	testl	%esi, %esi
	je	.L27
	movl	$1, %eax
	cmpl	$0, -44(%ebp)
	jne	.L24
.L27:
	testl	%esi, %esi
	sete	%dl
	xorl	%eax, %eax
	cmpl	$0, -44(%ebp)
	sete	%al
	andl	%edx, %eax
.L24:
	movl	16(%ebp), %edx
	movl	%eax, (%edx)
	subl	$12, %esp
	pushl	$.LC0
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC6, (%esp)
	call	print_str
	movl	%esi, (%esp)
	call	print_U32
	call	print_newline
	movl	%esi, %eax
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	get_mem_map_step, .-get_mem_map_step
	.section	.rodata.str1.1
.LC7:
	.string	"get_mem_map: len_map: "
.LC8:
	.string	"get_mem_map: increment len_map"
.LC9:
	.string	"get_mem_map: increment len_map (after)"
.LC10:
	.string	"get_mem_map: ebx:"
	.text
	.globl	get_mem_map
	.type	get_mem_map, @function
get_mem_map:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$56, %esp
	movl	8(%ebp), %esi
	movl	12(%ebp), %edi
	movl	16(%ebp), %ebx
	pushl	$.LC0
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC7, (%esp)
	call	print_str
	movl	%ebx, (%esp)
	call	print_U32
	call	print_newline
	movl	%edi, -36(%ebp)
	movl	$0, -32(%ebp)
	movl	$0, -28(%ebp)
	movzwl	%si, %eax
	movl	%eax, -44(%ebp)
	leal	-32(%ebp), %edx
	movl	%edx, (%esp)
	leal	-36(%ebp), %ecx
	pushl	%ecx
	leal	-28(%ebp), %esi
	pushl	%esi
	pushl	%edi
	pushl	%eax
	call	get_mem_map_step
	movl	%eax, %edi
	addl	$32, %esp
	testl	%eax, %eax
	jne	.L33
	subl	$12, %esp
	pushl	$.LC0
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC8, (%esp)
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
	movl	$.LC9, (%esp)
	call	print_str
	popl	%ecx
	pushl	(%ebx)
	call	print_U32
	call	print_newline
	addl	$16, %esp
.L33:
	subl	$12, %esp
	pushl	$.LC0
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC10, (%esp)
	call	print_str
	popl	%eax
	pushl	-32(%ebp)
	call	print_U32
	call	print_newline
	addl	$16, %esp
.L34:
	testl	%edi, %edi
	jne	.L36
.L38:
	cmpl	$0, -28(%ebp)
	jne	.L36
	subl	$12, %esp
	leal	-32(%ebp), %eax
	pushl	%eax
	leal	-36(%ebp), %eax
	pushl	%eax
	pushl	%esi
	pushl	-36(%ebp)
	pushl	-44(%ebp)
	call	get_mem_map_step
	movl	%eax, %edi
	addl	$32, %esp
	testl	%eax, %eax
	jne	.L34
	incl	(%ebx)
	jmp	.L38
.L36:
	movl	%edi, %eax
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	get_mem_map, .-get_mem_map
	.ident	"GCC: (GNU) 4.8.2 20140120 (Red Hat 4.8.2-15)"
	.section	.note.GNU-stack,"",@progbits
