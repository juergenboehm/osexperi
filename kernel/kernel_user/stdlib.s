	.file	"stdlib.c"
#APP
	.code16gcc	

#NO_APP
	.text
	.type	make_syscall1, @function
make_syscall1:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	movl	%eax, %esi
	movl	%edx, %edi
#APP
# 19 "kernel_user/stdlib.c" 1
	movl %esi, %eax 
	movl %edi, %ebx 
	int $0x80 
	movl %eax, %esi
# 0 "" 2
#NO_APP
	movl	%esi, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	make_syscall1, .-make_syscall1
	.type	handler_wrapper, @function
handler_wrapper:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
#APP
# 50 "kernel_user/stdlib.c" 1
	pushal 
	pushfl 
	
# 0 "" 2
#NO_APP
	cmpl	$0, -1073742064
	je	.L4
	subl	$12, %esp
	pushl	8(%ebp)
	call	*-1073742064
	addl	$16, %esp
.L4:
#APP
# 58 "kernel_user/stdlib.c" 1
	popfl 
	popal 
	
# 0 "" 2
#NO_APP
	leave
	ret	$4
	.size	handler_wrapper, .-handler_wrapper
	.type	parse_chars_universal, @function
parse_chars_universal:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$8, %esp
	movl	%eax, -16(%ebp)
	movl	%ecx, -20(%ebp)
	movl	%eax, %ebx
	xorl	%edi, %edi
.L8:
	movb	(%ebx), %cl
	movb	%cl, %al
	testb	%cl, %cl
	je	.L12
	movl	$1, %ecx
	movl	%ebx, %esi
	subl	-16(%ebp), %esi
.L13:
	testl	%ecx, %ecx
	je	.L12
	cmpl	8(%ebp), %esi
	jae	.L12
	xorl	%ecx, %ecx
.L14:
	cmpl	-20(%ebp), %ecx
	jge	.L27
	cmpb	(%edx,%ecx), %al
	jne	.L9
	movl	$1, %esi
	sall	%cl, %esi
	orl	%esi, %edi
	incl	%ebx
	jmp	.L8
.L9:
	incl	%ecx
	jmp	.L14
.L27:
	xorl	%ecx, %ecx
	jmp	.L13
.L12:
	movl	12(%ebp), %eax
	movl	%edi, (%eax)
	movl	%ebx, %eax
	popl	%edx
	popl	%ecx
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	parse_chars_universal, .-parse_chars_universal
	.type	__udivdi3, @function
__udivdi3:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$20, %esp
	movl	8(%ebp), %esi
	movl	12(%ebp), %edi
	xorl	%ecx, %ecx
.L29:
	cmpl	%edi, %edx
	jbe	.L54
.L30:
	addl	%esi, %esi
	adcl	%edi, %edi
	incl	%ecx
	jmp	.L29
.L54:
	jb	.L42
	cmpl	%esi, %eax
	jae	.L30
.L42:
	shrdl	$1, %edi, %esi
	shrl	%edi
	movl	%esi, -24(%ebp)
	movl	%edi, -20(%ebp)
	decl	%ecx
	movl	$0, -28(%ebp)
	movl	$0, -32(%ebp)
.L32:
	cmpl	-20(%ebp), %edx
	ja	.L48
	jb	.L44
	cmpl	-24(%ebp), %eax
	jb	.L44
.L48:
	movl	%ecx, %edi
	subw	$0, %di
	js	.L44
	subl	-24(%ebp), %eax
	sbbl	-20(%ebp), %edx
	movl	%ecx, %edi
	shrl	$5, %edi
	andl	$1, %edi
	movl	%edi, %esi
	xorl	$1, %esi
	sall	%cl, %esi
	sall	%cl, %edi
	orl	%esi, -28(%ebp)
	orl	%edi, -32(%ebp)
.L33:
	cmpl	-20(%ebp), %edx
	jb	.L47
	ja	.L32
	cmpl	-24(%ebp), %eax
	jae	.L32
.L47:
	testw	%cx, %cx
	jle	.L32
	movl	-24(%ebp), %ebx
	movl	-20(%ebp), %esi
	shrdl	$1, %esi, %ebx
	shrl	%esi
	movl	%ebx, -24(%ebp)
	movl	%esi, -20(%ebp)
	decl	%ecx
	jmp	.L33
.L44:
	movl	-28(%ebp), %eax
	movl	-32(%ebp), %edx
	addl	$20, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	__udivdi3, .-__udivdi3
	.type	make_syscall3.constprop.5, @function
make_syscall3.constprop.5:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	movl	%eax, %esi
	movl	%edx, %edi
#APP
# 33 "kernel_user/stdlib.c" 1
	movl $2, %eax 
	movl $1, %ebx 
	movl %esi, %ecx 
	movl %edi, %edx 
	int $0x80 
	movl %eax, %esi
# 0 "" 2
#NO_APP
	movl	%esi, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	make_syscall3.constprop.5, .-make_syscall3.constprop.5
	.globl	register_handler
	.type	register_handler, @function
register_handler:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	movl	%eax, -1073742064
	movl	$handler_wrapper, %edx
	movl	$3, %eax
	popl	%ebp
	jmp	make_syscall1
	.size	register_handler, .-register_handler
	.globl	fork
	.type	fork, @function
fork:
	pushl	%ebp
	movl	%esp, %ebp
	xorl	%edx, %edx
	movl	$4, %eax
	popl	%ebp
	jmp	make_syscall1
	.size	fork, .-fork
	.globl	ustrlen
	.type	ustrlen, @function
ustrlen:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	xorl	%eax, %eax
.L62:
	cmpb	$0, (%edx,%eax)
	je	.L65
	incl	%eax
	jmp	.L62
.L65:
	popl	%ebp
	ret
	.size	ustrlen, .-ustrlen
	.type	kprint_str.constprop.4, @function
kprint_str.constprop.4:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	%eax, %ebx
	pushl	%eax
	call	ustrlen
	popl	%edx
	movl	%eax, %edx
	movl	%ebx, %eax
	movl	-4(%ebp), %ebx
	leave
	jmp	make_syscall3.constprop.5
	.size	kprint_str.constprop.4, .-kprint_str.constprop.4
	.type	kprint_nibble, @function
kprint_nibble:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	andl	$15, %eax
	leal	87(%eax), %edx
	cmpb	$9, %al
	ja	.L70
	leal	48(%eax), %edx
.L70:
	movb	%dl, -2(%ebp)
	movb	$0, -1(%ebp)
	leal	-2(%ebp), %eax
	call	kprint_str.constprop.4
	xorl	%eax, %eax
	leave
	ret
	.size	kprint_nibble, .-kprint_nibble
	.type	kprint_byte, @function
kprint_byte:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	%eax, %ebx
	shrl	$4, %eax
	call	kprint_nibble
	movzbl	%bl, %eax
	call	kprint_nibble
	xorl	%eax, %eax
	popl	%ebx
	popl	%ebp
	ret
	.size	kprint_byte, .-kprint_byte
	.type	kprint_U32, @function
kprint_U32:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	%eax, %ebx
	shrl	$24, %eax
	call	kprint_byte
	movl	%ebx, %eax
	shrl	$16, %eax
	movzbl	%al, %eax
	call	kprint_byte
	movzbl	%bh, %eax
	call	kprint_byte
	movzbl	%bl, %eax
	call	kprint_byte
	xorl	%eax, %eax
	popl	%ebx
	popl	%ebp
	ret
	.size	kprint_U32, .-kprint_U32
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"0123456789abcdef"
.LC1:
	.string	"Assertion failed.\n"
.LC2:
	.string	" * "
.LC3:
	.string	"\n"
	.text
	.type	int_to_str.isra.1, @function
int_to_str.isra.1:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$124, %esp
	movl	%eax, %esi
	movl	16(%ebp), %eax
	andl	$2, %eax
	movl	%eax, -92(%ebp)
	movl	16(%ebp), %eax
	andl	$4, %eax
	movl	%eax, -96(%ebp)
	movl	16(%ebp), %eax
	andl	$16, %eax
	cmpl	$1, %eax
	sbbl	%eax, %eax
	movl	%eax, -112(%ebp)
	andb	$-16, -112(%ebp)
	addb	$48, -112(%ebp)
	cmpl	$0, 12(%ebp)
	jne	.L78
	testl	%ecx, %ecx
	jns	.L79
	movl	%ecx, %ebx
	movl	%edx, %ecx
	negl	%ecx
	adcl	$0, %ebx
	negl	%ebx
	movl	$-1, -84(%ebp)
	jmp	.L81
.L79:
	movl	%ecx, %eax
	orl	%edx, %eax
	jne	.L78
	movl	$0, -84(%ebp)
	xorl	%ecx, %ecx
	xorl	%ebx, %ebx
.L81:
	leal	-80(%ebp), %eax
	movl	%eax, -88(%ebp)
	movl	8(%ebp), %eax
	xorl	%edx, %edx
	movl	%eax, -128(%ebp)
	movl	%edx, -124(%ebp)
	jmp	.L80
.L78:
	movl	%ecx, %ebx
	movl	%edx, %ecx
	movl	$1, -84(%ebp)
	jmp	.L81
.L83:
	pushl	-124(%ebp)
	pushl	-128(%ebp)
	movl	%ecx, %eax
	movl	%ebx, %edx
	movl	%ecx, -136(%ebp)
	movl	%ebx, -132(%ebp)
	call	__udivdi3
	popl	%ecx
	popl	%ebx
	movl	%eax, -116(%ebp)
	movl	%edx, %edi
	mull	8(%ebp)
	movl	-136(%ebp), %ecx
	subl	%eax, %ecx
	incl	-88(%ebp)
	movb	$63, %al
	cmpl	$15, %ecx
	ja	.L82
	movb	.LC0(%ecx), %al
.L82:
	movl	-88(%ebp), %ebx
	movb	%al, -1(%ebx)
	movl	-116(%ebp), %ecx
	movl	%edi, %ebx
.L80:
	movl	%ebx, %eax
	orl	%ecx, %eax
	jne	.L83
	movl	-88(%ebp), %edi
	movl	%edi, %eax
	leal	-80(%ebp), %edx
	subl	%edx, %edi
	jne	.L84
	incl	-88(%ebp)
	movb	$48, (%eax)
	movl	$1, %edi
.L84:
	movl	-88(%ebp), %eax
	movb	$0, (%eax)
	movl	-84(%ebp), %eax
	subl	$0, %eax
	js	.L128
	movl	$1, %ebx
	cmpl	$0, -92(%ebp)
	jne	.L85
.L128:
	movl	-84(%ebp), %eax
	shrl	$31, %eax
	xorl	%ebx, %ebx
	cmpl	$0, -96(%ebp)
	setne	%bl
	orl	%eax, %ebx
.L85:
	addl	%edi, %ebx
	movl	%ebx, %eax
	cmpl	$0, 24(%ebp)
	jle	.L87
	cmpl	24(%ebp), %ebx
	jbe	.L87
	movl	24(%ebp), %eax
.L87:
	cmpl	$0, 20(%ebp)
	jle	.L118
	movl	20(%ebp), %edx
	cmpl	%edx, %eax
	jbe	.L89
	xorl	%eax, %eax
.L90:
	movb	$35, (%esi,%eax)
	incl	%eax
	cmpl	20(%ebp), %eax
	jne	.L90
	leal	(%esi,%eax), %edx
	movl	%edx, %eax
	subl	%esi, %eax
	movl	28(%ebp), %esi
	movl	%edx, (%esi)
	jmp	.L129
.L118:
	movl	%eax, %edx
.L89:
	cmpl	%ebx, %edx
	jae	.L93
	movl	%edx, -84(%ebp)
	movl	$.LC1, %eax
	call	kprint_str.constprop.4
	movl	-84(%ebp), %edx
	movl	%edx, %eax
	call	kprint_U32
	movl	$.LC2, %eax
	call	kprint_str.constprop.4
	movl	%ebx, %eax
	call	kprint_U32
	movl	$.LC3, %eax
	call	kprint_str.constprop.4
.L94:
	jmp	.L94
.L93:
	movl	%edx, %eax
	subl	%ebx, %eax
	movl	%eax, -88(%ebp)
	testb	$1, 16(%ebp)
	je	.L95
	cmpl	$-1, -84(%ebp)
	je	.L119
	cmpl	$0, -92(%ebp)
	jne	.L120
	cmpl	$0, -96(%ebp)
	jne	.L121
	movl	%esi, %ecx
.L111:
	leal	-80(%ebp,%edi), %ebx
	movl	%ecx, %edx
.L99:
	incl	%edx
	movb	-1(%ebx), %al
	movb	%al, -1(%edx)
	decl	%ebx
	movl	%edx, %eax
	subl	%ecx, %eax
	cmpl	%edi, %eax
	jb	.L99
	xorl	%ecx, %ecx
.L98:
	cmpl	-88(%ebp), %ecx
	je	.L131
	movb	$32, (%edx,%ecx)
	incl	%ecx
	jmp	.L98
.L131:
	addl	%edx, %ecx
	jmp	.L101
.L95:
	cmpb	$48, -112(%ebp)
	je	.L102
	xorl	%edx, %edx
	jmp	.L103
.L102:
	cmpl	$-1, -84(%ebp)
	je	.L122
	cmpl	$0, -92(%ebp)
	jne	.L123
	cmpl	$0, -96(%ebp)
	jne	.L124
	movl	%esi, %ecx
.L112:
	xorl	%edx, %edx
.L105:
	cmpl	-88(%ebp), %edx
	je	.L132
	movb	$48, (%ecx,%edx)
	incl	%edx
	jmp	.L105
.L132:
	addl	%ecx, %edx
	jmp	.L107
.L103:
	cmpl	-88(%ebp), %edx
	je	.L133
	movb	$32, (%esi,%edx)
	incl	%edx
	jmp	.L103
.L133:
	addl	%esi, %edx
	cmpl	$-1, -84(%ebp)
	je	.L125
	cmpl	$0, -92(%ebp)
	jne	.L126
	cmpl	$0, -96(%ebp)
	jne	.L127
.L107:
	leal	-80(%ebp,%edi), %eax
	movl	%edx, %ecx
.L110:
	incl	%ecx
	movb	-1(%eax), %bl
	movb	%bl, -1(%ecx)
	decl	%eax
	movl	%ecx, %ebx
	subl	%edx, %ebx
	cmpl	%edi, %ebx
	jb	.L110
.L101:
	movl	%ecx, %eax
	subl	%esi, %eax
	movl	28(%ebp), %esi
	movl	%ecx, (%esi)
	jmp	.L129
.L119:
	movb	$45, %dl
	jmp	.L96
.L120:
	movb	$43, %dl
	jmp	.L96
.L121:
	movb	$32, %dl
.L96:
	leal	1(%esi), %ecx
	movb	%dl, (%esi)
	jmp	.L111
.L122:
	movb	$45, %dl
	jmp	.L104
.L123:
	movb	$43, %dl
	jmp	.L104
.L124:
	movb	$32, %dl
.L104:
	leal	1(%esi), %ecx
	movb	%dl, (%esi)
	jmp	.L112
.L125:
	movb	$45, %al
	jmp	.L109
.L126:
	movb	$43, %al
	jmp	.L109
.L127:
	movb	$32, %al
.L109:
	movb	%al, (%edx)
	incl	%edx
	jmp	.L107
.L129:
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	int_to_str.isra.1, .-int_to_str.isra.1
	.type	vprintf.constprop.2, @function
vprintf.constprop.2:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$36, %esp
	movl	%edx, %edi
	movl	%ecx, %ebx
	movl	%eax, -28(%ebp)
	movl	$1024, -36(%ebp)
.L135:
	movb	(%edi), %dl
	testb	%dl, %dl
	je	.L160
	cmpl	$0, -36(%ebp)
	je	.L160
	cmpb	$37, %dl
	leal	1(%edi), %eax
	jne	.L136
	leal	-24(%ebp), %edi
	pushl	%edi
	pushl	$-9
	movl	$5, %ecx
	movl	$fmt_flag_char_list, %edx
	call	parse_chars_universal
	popl	%esi
	popl	%edi
	movl	$0, -44(%ebp)
.L137:
	movsbl	(%eax), %edx
	testb	%dl, %dl
	je	.L162
	leal	-48(%edx), %ecx
	cmpb	$9, %cl
	ja	.L177
	imull	$10, -44(%ebp), %ecx
	leal	-48(%ecx,%edx), %edi
	movl	%edi, -44(%ebp)
	incl	%eax
	jmp	.L137
.L177:
	movl	$0, -40(%ebp)
	cmpb	$46, %dl
	jne	.L138
.L175:
	incl	%eax
	movsbl	(%eax), %edx
	leal	-48(%edx), %ecx
	cmpb	$9, %cl
	ja	.L138
	imull	$10, -40(%ebp), %ecx
	leal	-48(%ecx,%edx), %edi
	movl	%edi, -40(%ebp)
	jmp	.L175
.L162:
	movl	$0, -40(%ebp)
.L138:
	xorl	%esi, %esi
.L149:
	movl	fmt_length_list(,%esi,4), %edi
	movl	%eax, %edx
.L142:
	movb	(%edx), %cl
	movb	%cl, -45(%ebp)
	testb	%cl, %cl
	jne	.L143
.L146:
	cmpb	$0, (%edi)
	leal	1(%esi), %esi
	jne	.L173
	movl	%edx, %eax
	jmp	.L148
.L143:
	movb	(%edi), %cl
	testb	%cl, %cl
	je	.L146
	cmpb	%cl, -45(%ebp)
	jne	.L146
	incl	%edx
	incl	%edi
	jmp	.L142
.L173:
	cmpl	$8, %esi
	jne	.L149
	xorw	%si, %si
.L148:
	leal	-20(%ebp), %edi
	pushl	%edi
	pushl	$1
	movl	$7, %ecx
	movl	$fmt_specifier_list, %edx
	call	parse_chars_universal
	movl	%eax, %edi
	movl	-20(%ebp), %eax
	popl	%edx
	popl	%ecx
	testb	$1, %al
	je	.L150
	leal	4(%ebx), %esi
	movl	(%ebx), %edx
	movl	%edx, %ecx
	sarl	$31, %ecx
	leal	-28(%ebp), %eax
	pushl	%eax
	pushl	-40(%ebp)
	pushl	-44(%ebp)
	pushl	-24(%ebp)
	pushl	$0
	pushl	$10
	jmp	.L176
.L150:
	testb	$2, %al
	je	.L152
	leal	4(%ebx), %esi
	movl	(%ebx), %eax
.L153:
	cmpb	$0, (%eax)
	je	.L151
	cmpl	$0, -36(%ebp)
	je	.L151
	movl	-28(%ebp), %edx
	leal	1(%edx), %ecx
	movl	%ecx, -28(%ebp)
	incl	%eax
	movb	-1(%eax), %cl
	movb	%cl, (%edx)
	decl	-36(%ebp)
	jmp	.L153
.L152:
	testb	$8, %al
	je	.L155
	leal	4(%ebx), %esi
	movl	(%ebx), %edx
	movl	%edx, %ecx
	sarl	$31, %ecx
	leal	-28(%ebp), %eax
	pushl	%eax
	pushl	-40(%ebp)
	pushl	-44(%ebp)
	pushl	-24(%ebp)
	pushl	$1
	pushl	$8
.L176:
	movl	-28(%ebp), %eax
	call	int_to_str.isra.1
	subl	%eax, -36(%ebp)
	addl	$24, %esp
	jmp	.L151
.L155:
	testb	$32, %al
	je	.L156
	cmpl	$4, %esi
	jne	.L157
	leal	8(%ebx), %esi
	movl	(%ebx), %edx
	movl	4(%ebx), %ecx
	jmp	.L158
.L157:
	leal	4(%ebx), %esi
	movl	(%ebx), %edx
	xorl	%ecx, %ecx
.L158:
	leal	-28(%ebp), %eax
	pushl	%eax
	pushl	-40(%ebp)
	pushl	-44(%ebp)
	pushl	-24(%ebp)
	pushl	$1
	pushl	$16
	jmp	.L176
.L156:
	movl	%ebx, %esi
	testb	$4, %al
	je	.L151
	addl	$4, %esi
	movl	(%ebx), %edx
	movl	-28(%ebp), %eax
	movb	%dl, (%eax)
	incl	-28(%ebp)
	decl	-36(%ebp)
.L151:
	movl	%esi, %ebx
	jmp	.L135
.L136:
	movl	-28(%ebp), %ecx
	movb	%dl, (%ecx)
	decl	-36(%ebp)
	incl	-28(%ebp)
	movl	%eax, %edi
	jmp	.L135
.L160:
	movl	-28(%ebp), %eax
	movb	$0, (%eax)
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	vprintf.constprop.2, .-vprintf.constprop.2
	.globl	uoutb_printf
	.type	uoutb_printf, @function
uoutb_printf:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$1024, %esp
	leal	12(%ebp), %ecx
	movl	8(%ebp), %edx
	leal	-1024(%ebp), %eax
	call	vprintf.constprop.2
	leal	-1024(%ebp), %edx
.L179:
	movb	(%edx), %al
	testb	%al, %al
	je	.L182
	incl	%edx
#APP
# 80 "/home/juergen/osexperi/kernel/kernel_user/stdlib.h" 1
	outb %al, $233
# 0 "" 2
#NO_APP
	jmp	.L179
.L182:
	xorl	%eax, %eax
	leave
	ret
	.size	uoutb_printf, .-uoutb_printf
	.globl	uprintf
	.type	uprintf, @function
uprintf:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$1024, %esp
	leal	12(%ebp), %ecx
	movl	8(%ebp), %edx
	leal	-1024(%ebp), %eax
	call	vprintf.constprop.2
	leal	-1024(%ebp), %eax
	call	kprint_str.constprop.4
	leave
	ret
	.size	uprintf, .-uprintf
	.data
	.align 4
	.type	fmt_specifier_list, @object
	.size	fmt_specifier_list, 7
fmt_specifier_list:
	.byte	100
	.byte	115
	.byte	99
	.byte	111
	.byte	117
	.byte	120
	.byte	88
	.section	.rodata.str1.1
.LC4:
	.string	"hh"
.LC5:
	.string	"h"
.LC6:
	.string	"ll"
.LC7:
	.string	"l"
.LC8:
	.string	"L"
.LC9:
	.string	"z"
.LC10:
	.string	"j"
.LC11:
	.string	"t"
	.data
	.align 4
	.type	fmt_length_list, @object
	.size	fmt_length_list, 32
fmt_length_list:
	.long	.LC4
	.long	.LC5
	.long	.LC6
	.long	.LC7
	.long	.LC8
	.long	.LC9
	.long	.LC10
	.long	.LC11
	.align 4
	.type	fmt_flag_char_list, @object
	.size	fmt_flag_char_list, 5
fmt_flag_char_list:
	.byte	45
	.byte	43
	.byte	32
	.byte	35
	.byte	48
	.comm	FILE,4,4
	.ident	"GCC: (GNU) 4.8.2 20140120 (Red Hat 4.8.2-15)"
	.section	.note.GNU-stack,"",@progbits
