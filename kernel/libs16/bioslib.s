	.file	"bioslib.c"
/APP
	.code16gcc	

	.section	.rodata
.LC0:
	.string	"libs16/bioslib.c"
.LC1:
	.string	":"
.LC2:
	.string	"copy_segseg: target = "
/NO_APP
	.text
	.globl	copy_segseg
	.type	copy_segseg, @function
copy_segseg:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$44, %esp
	movl	8(%ebp), %ebx
	movl	12(%ebp), %ecx
	movl	20(%ebp), %edx
	movl	24(%ebp), %eax
	movw	%bx, -28(%ebp)
	movw	%cx, -32(%ebp)
	movw	%dx, -36(%ebp)
	movw	%ax, -40(%ebp)
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC2, (%esp)
	call	print_str
	movzwl	-36(%ebp), %eax
	sall	$4, %eax
	movl	%eax, %edx
	movzwl	-40(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
/APP
/  15 "libs16/bioslib.c" 1
	push %es 
	 push %fs 
	movw -28(%ebp), %ax 
	movw %ax, %es 
	movw -36(%ebp), %ax 
	movw %ax, %fs 
	movw -32(%ebp), %si 
	movw -40(%ebp), %di 
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
	 
/  0 "" 2
/NO_APP
	movl	$0, %eax
	addl	$44, %esp
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
	subl	$52, %esp
	movl	20(%ebp), %edx
	movl	24(%ebp), %eax
	movw	%dx, -28(%ebp)
	movw	%ax, -32(%ebp)
	movl	8(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -12(%ebp)
	movl	8(%ebp), %eax
	addl	$24, %eax
	movl	%eax, -16(%ebp)
	movl	$8, 8(%esp)
	movl	$0, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	memset16
	movl	$8, 8(%esp)
	movl	$0, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	memset16
	movl	12(%ebp), %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movw	%dx, 2(%eax)
	movl	12(%ebp), %eax
	shrl	$16, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movb	%dl, 4(%eax)
	movl	12(%ebp), %eax
	shrl	$24, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movb	%dl, 7(%eax)
	movl	-12(%ebp), %eax
	movw	$-1, (%eax)
	movl	-12(%ebp), %eax
	movzbl	6(%eax), %eax
	andl	$-16, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movb	%dl, 6(%eax)
	movl	-12(%ebp), %eax
	movzbl	6(%eax), %eax
	andl	$127, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movb	%dl, 6(%eax)
	movl	-12(%ebp), %eax
	movzbl	6(%eax), %eax
	andl	$-65, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movb	%dl, 6(%eax)
	movl	-12(%ebp), %eax
	movzbl	5(%eax), %eax
	orl	$-128, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movb	%dl, 5(%eax)
	movl	-12(%ebp), %eax
	movzbl	5(%eax), %eax
	andl	$-97, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movb	%dl, 5(%eax)
	movl	-12(%ebp), %eax
	movzbl	5(%eax), %eax
	orl	$16, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movb	%dl, 5(%eax)
	movl	-12(%ebp), %eax
	movzbl	5(%eax), %eax
	andl	$-15, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movb	%dl, 5(%eax)
	movl	16(%ebp), %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	movw	%dx, 2(%eax)
	movl	16(%ebp), %eax
	shrl	$16, %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	movb	%dl, 4(%eax)
	movl	16(%ebp), %eax
	shrl	$24, %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	movb	%dl, 7(%eax)
	movl	-16(%ebp), %eax
	movw	$-1, (%eax)
	movl	-16(%ebp), %eax
	movzbl	6(%eax), %eax
	andl	$-16, %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	movb	%dl, 6(%eax)
	movl	-16(%ebp), %eax
	movzbl	6(%eax), %eax
	andl	$127, %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	movb	%dl, 6(%eax)
	movl	-16(%ebp), %eax
	movzbl	6(%eax), %eax
	andl	$-65, %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	movb	%dl, 6(%eax)
	movl	-16(%ebp), %eax
	movzbl	5(%eax), %eax
	orl	$-128, %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	movb	%dl, 5(%eax)
	movl	-16(%ebp), %eax
	movzbl	5(%eax), %eax
	andl	$-97, %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	movb	%dl, 5(%eax)
	movl	-16(%ebp), %eax
	movzbl	5(%eax), %eax
	orl	$16, %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	movb	%dl, 5(%eax)
	movl	-16(%ebp), %eax
	movzbl	5(%eax), %eax
	andl	$-15, %eax
	orl	$2, %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	movb	%dl, 5(%eax)
	movl	8(%ebp), %eax
	movl	$0, (%eax)
	movl	$0, 4(%eax)
	movl	8(%ebp), %eax
	movl	$0, 8(%eax)
	movl	$0, 12(%eax)
	movl	8(%ebp), %eax
	movl	$0, 32(%eax)
	movl	$0, 36(%eax)
	movl	8(%ebp), %eax
	movl	$0, 40(%eax)
	movl	$0, 44(%eax)
	movl	8(%ebp), %eax
	movl	%eax, %edx
/APP
/  67 "libs16/bioslib.c" 1
	push %es 
	movw -32(%ebp), %ax
	movw %ax, %es
	movw %dx, %si
	movw -28(%ebp), %cx
	movw $0x8700, %ax
	int  $0x15
	pop  %es
	movl $0, %eax
	rcll	$1, %eax
	movw %ax, %dx
	
/  0 "" 2
/NO_APP
	movw	%dx, -18(%ebp)
	movzwl	-18(%ebp), %eax
	addl	$52, %esp
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
	subl	$4, %esp
	movl	8(%ebp), %eax
	movb	%al, -8(%ebp)
/APP
/  94 "libs16/bioslib.c" 1
	pushl %ebp 
	pushal 
	pushw %ds 
	 pushw %es 
	 pushw %fs 
	 pushw %gs 
	movb	-8(%ebp), %al 
	movb $0x0e, %ah 
	movb	$0x00, %bh 
	movb	$0x0c, %bl 
	int $0x10 
	popw %gs 
	 popw %fs 
	 popw %es 
	 popw %ds 
	popal 
	popl %ebp 
	
/  0 "" 2
/NO_APP
	addl	$4, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	print_char, .-print_char
	.globl	init_DAPA
	.type	init_DAPA, @function
init_DAPA:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	12(%ebp), %edx
	movl	24(%ebp), %eax
	movw	%dx, -4(%ebp)
	movw	%ax, -8(%ebp)
	movl	20(%ebp), %eax
	movb	$16, (%eax)
	movl	20(%ebp), %eax
	movb	$0, 1(%eax)
	movl	20(%ebp), %eax
	movzwl	-4(%ebp), %edx
	movw	%dx, 2(%eax)
	movl	16(%ebp), %eax
	movl	%eax, %edx
	movl	20(%ebp), %eax
	movw	%dx, 4(%eax)
	movl	20(%ebp), %eax
	movzwl	-8(%ebp), %edx
	movw	%dx, 6(%eax)
	movl	20(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	20(%ebp), %eax
	movl	$0, 12(%eax)
	movl	$0, %eax
	leave
	ret
	.size	init_DAPA, .-init_DAPA
	.globl	do_read_write_13
	.type	do_read_write_13, @function
do_read_write_13:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	subl	$28, %esp
	movl	12(%ebp), %ecx
	movl	16(%ebp), %edx
	movl	20(%ebp), %eax
	movw	%cx, -24(%ebp)
	movb	%dl, -28(%ebp)
	movb	%al, -32(%ebp)
	movb	$0, -5(%ebp)
	movl	$5, -12(%ebp)
	jmp	.L9
.L12:
	movb	$0, -5(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, %ecx
/APP
/  140 "libs16/bioslib.c" 1
	pushl %ebp 
	pushal 
	pushw %ds 
	 pushw %es 
	 pushw %fs 
	 pushw %gs 
	.retry:movw %cx, %si 
	movw -24(%ebp), %ax 
	 movw %ax, %ds 
	movb -28(%ebp), %ah 
	movb -32(%ebp), %dl 
	int $0x13 
	jc .err 
	popw %gs 
	 popw %fs 
	 popw %es 
	 popw %ds 
	popal 
	popl %ebp 
	movb $0, %cl 
	jmp .ende 
	.err: 
	popw %gs 
	 popw %fs 
	 popw %es 
	 popw %ds 
	popal 
	popl %ebp 
	movb %ah, %cl 
	.ende: 
	
/  0 "" 2
/NO_APP
	movb	%cl, -5(%ebp)
	cmpb	$0, -5(%ebp)
	jne	.L10
	jmp	.L11
.L10:
	subl	$1, -12(%ebp)
.L9:
	cmpl	$0, -12(%ebp)
	jne	.L12
.L11:
	movzbl	-5(%ebp), %eax
	addl	$28, %esp
	popl	%esi
	popl	%ebp
	ret
	.size	do_read_write_13, .-do_read_write_13
	.globl	loadsec
	.type	loadsec, @function
loadsec:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$44, %esp
	movl	12(%ebp), %edx
	movl	24(%ebp), %eax
	movw	%dx, -20(%ebp)
	movw	%ax, -24(%ebp)
	movb	$0, -1(%ebp)
	movzwl	-24(%ebp), %edx
	movzwl	-20(%ebp), %eax
	movl	%edx, 16(%esp)
	movl	20(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	16(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	init_DAPA
	movzwl	-24(%ebp), %eax
	movl	$128, 12(%esp)
	movl	$66, 8(%esp)
	movl	%eax, 4(%esp)
	movl	20(%ebp), %eax
	movl	%eax, (%esp)
	call	do_read_write_13
	movb	%al, -1(%ebp)
	movzbl	-1(%ebp), %eax
	leave
	ret
	.size	loadsec, .-loadsec
	.globl	writesec
	.type	writesec, @function
writesec:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$44, %esp
	movl	12(%ebp), %edx
	movl	24(%ebp), %eax
	movw	%dx, -20(%ebp)
	movw	%ax, -24(%ebp)
	movb	$0, -1(%ebp)
	movzwl	-24(%ebp), %edx
	movzwl	-20(%ebp), %eax
	movl	%edx, 16(%esp)
	movl	20(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	16(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	init_DAPA
	movzwl	-24(%ebp), %eax
	movl	$128, 12(%esp)
	movl	$67, 8(%esp)
	movl	%eax, 4(%esp)
	movl	20(%ebp), %eax
	movl	%eax, (%esp)
	call	do_read_write_13
	movb	%al, -1(%ebp)
	movzbl	-1(%ebp), %eax
	leave
	ret
	.size	writesec, .-writesec
	.globl	loadsec_fd
	.type	loadsec_fd, @function
loadsec_fd:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$24, %esp
	movl	12(%ebp), %edx
	movl	24(%ebp), %eax
	movw	%dx, -28(%ebp)
	movw	%ax, -32(%ebp)
	movzwl	-28(%ebp), %eax
	movb	%al, -19(%ebp)
	movl	8(%ebp), %ecx
	movl	$954437177, %edx
	movl	%ecx, %eax
	mull	%edx
	shrl	$2, %edx
	movl	%edx, %eax
	sall	$3, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	movl	%edx, %eax
	addl	$1, %eax
	movb	%al, -14(%ebp)
	movl	8(%ebp), %eax
	movl	$954437177, %edx
	mull	%edx
	movl	%edx, %eax
	shrl	$2, %eax
	movw	%ax, -16(%ebp)
	movzwl	-16(%ebp), %eax
	andl	$1, %eax
	movb	%al, -20(%ebp)
	movzwl	-16(%ebp), %eax
	shrw	%ax
	movw	%ax, -18(%ebp)
	movzwl	-18(%ebp), %eax
	movb	%al, -21(%ebp)
	movzwl	-18(%ebp), %eax
	shrw	$2, %ax
	andl	$-64, %eax
	movl	%eax, %edx
	movzbl	-14(%ebp), %eax
	orl	%edx, %eax
	movb	%al, -22(%ebp)
	movl	16(%ebp), %eax
	movw	%ax, -24(%ebp)
	movl	$1, -12(%ebp)
	movb	$0, -13(%ebp)
	jmp	.L19
.L21:
/APP
/  230 "libs16/bioslib.c" 1
	push	%es 
	movw -32(%ebp), %ax 
	 movw %ax, %es 
	 movw -24(%ebp), %bx 
	 movb $0x02, %ah 
	 movb -19(%ebp), %al 
	 movb -21(%ebp), %ch 
	 movb -22(%ebp), %cl 
	 movb -20(%ebp), %dh 
	 movb $0, %dl 
	 int $0x13 
	movl $0x0, %eax 
	 rcll $1, %eax 
	 movl %eax, %esi 
	 pop %es 
	
/  0 "" 2
/NO_APP
	movl	%esi, -12(%ebp)
	addb	$1, -13(%ebp)
.L19:
	cmpl	$0, -12(%ebp)
	je	.L20
	cmpb	$2, -13(%ebp)
	jbe	.L21
.L20:
	movl	-12(%ebp), %eax
	addl	$24, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	loadsec_fd, .-loadsec_fd
	.section	.rodata
.LC3:
	.string	"size_entry: "
.LC4:
	.string	"get_mem_map_first: err: "
.LC5:
	.string	"get_mem_map_first: ebx_val: "
	.align 4
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
	subl	$44, %esp
	movl	8(%ebp), %eax
	movw	%ax, -44(%ebp)
	movl	$0, -28(%ebp)
	movl	24(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -32(%ebp)
	movb	$0, -33(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, %esi
/APP
/  275 "libs16/bioslib.c" 1
	pushw %es 
	movw -44(%ebp), %ax 
	movw %ax, %es 
	movw %si, %di 
	movl -32(%ebp), %ebx 
	movl $0x534D4150, %edx 
	movl $24, %ecx 
	movl $0xe820, %eax 
	int	$0x15 
	movb %cl, -33(%ebp) 
	cmp $0x18, %cl 
	.L9900: je 1f 
	addw $0x14, %di 
	movl $0xffffffff, %es:(%di) 
	1: movl $0x0, %edx 
	rcll $1, %edx 
	movl %edx, -48(%ebp) 
	movl %ebx, %esi 
	popw %es 
	
/  0 "" 2
/NO_APP
	movl	-48(%ebp), %eax
	movl	%eax, -28(%ebp)
	movl	%esi, -32(%ebp)
	movl	24(%ebp), %eax
	movl	-32(%ebp), %edx
	movl	%edx, (%eax)
	movl	12(%ebp), %eax
	leal	24(%eax), %edx
	movl	20(%ebp), %eax
	movl	%edx, (%eax)
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC3, (%esp)
	call	print_str
	movzbl	-33(%ebp), %eax
	movzbl	%al, %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC4, (%esp)
	call	print_str
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	cmpl	$0, -32(%ebp)
	je	.L24
	cmpl	$0, -28(%ebp)
	jne	.L25
.L24:
	cmpl	$0, -32(%ebp)
	jne	.L26
	cmpl	$0, -28(%ebp)
	jne	.L26
.L25:
	movl	$1, %eax
	jmp	.L27
.L26:
	movl	$0, %eax
.L27:
	movl	16(%ebp), %edx
	movl	%eax, (%edx)
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC6, (%esp)
	call	print_str
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	-28(%ebp), %eax
	addl	$44, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	get_mem_map_step, .-get_mem_map_step
	.section	.rodata
.LC7:
	.string	"get_mem_map: len_map: "
	.align 4
.LC8:
	.string	"get_mem_map: increment len_map"
	.align 4
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
	subl	$56, %esp
	movl	8(%ebp), %eax
	movw	%ax, -28(%ebp)
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC7, (%esp)
	call	print_str
	movl	16(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	12(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	$0, -12(%ebp)
	movl	$0, -20(%ebp)
	movl	$0, -24(%ebp)
	movl	-16(%ebp), %edx
	movzwl	-28(%ebp), %eax
	leal	-20(%ebp), %ecx
	movl	%ecx, 16(%esp)
	leal	-16(%ebp), %ecx
	movl	%ecx, 12(%esp)
	leal	-24(%ebp), %ecx
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	get_mem_map_step
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L30
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC8, (%esp)
	call	print_str
	movl	16(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	16(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %edx
	movl	16(%ebp), %eax
	movl	%edx, (%eax)
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC9, (%esp)
	call	print_str
	movl	16(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
.L30:
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC10, (%esp)
	call	print_str
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	jmp	.L31
.L33:
	movl	-16(%ebp), %edx
	movzwl	-28(%ebp), %eax
	leal	-20(%ebp), %ecx
	movl	%ecx, 16(%esp)
	leal	-16(%ebp), %ecx
	movl	%ecx, 12(%esp)
	leal	-24(%ebp), %ecx
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	get_mem_map_step
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L31
	movl	16(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %edx
	movl	16(%ebp), %eax
	movl	%edx, (%eax)
.L31:
	cmpl	$0, -12(%ebp)
	jne	.L32
	movl	-24(%ebp), %eax
	testl	%eax, %eax
	je	.L33
.L32:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	get_mem_map, .-get_mem_map
	.ident	"GCC: (GNU) 4.8.2"
