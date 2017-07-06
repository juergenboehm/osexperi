	.file	"stdlib.c"
#APP
	.code16gcc	

#NO_APP
	.text
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
	je	.L2
	subl	$12, %esp
	pushl	8(%ebp)
	call	*-1073742064
	addl	$16, %esp
.L2:
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
.L6:
	movb	(%ebx), %cl
	movb	%cl, %al
	testb	%cl, %cl
	je	.L10
	movl	$1, %ecx
	movl	%ebx, %esi
	subl	-16(%ebp), %esi
.L11:
	testl	%ecx, %ecx
	je	.L10
	cmpl	8(%ebp), %esi
	jae	.L10
	xorl	%ecx, %ecx
.L12:
	cmpl	-20(%ebp), %ecx
	jge	.L25
	cmpb	(%edx,%ecx), %al
	jne	.L7
	movl	$1, %esi
	sall	%cl, %esi
	orl	%esi, %edi
	incl	%ebx
	jmp	.L6
.L7:
	incl	%ecx
	jmp	.L12
.L25:
	xorl	%ecx, %ecx
	jmp	.L11
.L10:
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
.L27:
	cmpl	%edi, %edx
	jbe	.L52
.L28:
	addl	%esi, %esi
	adcl	%edi, %edi
	incl	%ecx
	jmp	.L27
.L52:
	jb	.L40
	cmpl	%esi, %eax
	jae	.L28
.L40:
	shrdl	$1, %edi, %esi
	shrl	%edi
	movl	%esi, -24(%ebp)
	movl	%edi, -20(%ebp)
	decl	%ecx
	movl	$0, -28(%ebp)
	movl	$0, -32(%ebp)
.L30:
	cmpl	-20(%ebp), %edx
	ja	.L46
	jb	.L42
	cmpl	-24(%ebp), %eax
	jb	.L42
.L46:
	movl	%ecx, %edi
	subw	$0, %di
	js	.L42
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
.L31:
	cmpl	-20(%ebp), %edx
	jb	.L45
	ja	.L30
	cmpl	-24(%ebp), %eax
	jae	.L30
.L45:
	testw	%cx, %cx
	jle	.L30
	movl	-24(%ebp), %ebx
	movl	-20(%ebp), %esi
	shrdl	$1, %esi, %ebx
	shrl	%esi
	movl	%ebx, -24(%ebp)
	movl	%esi, -20(%ebp)
	decl	%ecx
	jmp	.L31
.L42:
	movl	-28(%ebp), %eax
	movl	-32(%ebp), %edx
	addl	$20, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	__udivdi3, .-__udivdi3
	.type	make_syscall1.constprop.4, @function
make_syscall1.constprop.4:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	%eax, %esi
#APP
# 19 "kernel_user/stdlib.c" 1
	movl $3, %eax 
	movl %esi, %ebx 
	int $0x80 
	movl %eax, %esi
# 0 "" 2
#NO_APP
	movl	%esi, %eax
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	make_syscall1.constprop.4, .-make_syscall1.constprop.4
	.type	make_syscall3.constprop.6, @function
make_syscall3.constprop.6:
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
	.size	make_syscall3.constprop.6, .-make_syscall3.constprop.6
	.globl	register_handler
	.type	register_handler, @function
register_handler:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	movl	%eax, -1073742064
	movl	$handler_wrapper, %eax
	popl	%ebp
	jmp	make_syscall1.constprop.4
	.size	register_handler, .-register_handler
	.globl	ustrlen
	.type	ustrlen, @function
ustrlen:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	xorl	%eax, %eax
.L60:
	cmpb	$0, (%edx,%eax)
	je	.L63
	incl	%eax
	jmp	.L60
.L63:
	popl	%ebp
	ret
	.size	ustrlen, .-ustrlen
	.type	kprint_str.constprop.5, @function
kprint_str.constprop.5:
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
	jmp	make_syscall3.constprop.6
	.size	kprint_str.constprop.5, .-kprint_str.constprop.5
	.type	kprint_nibble, @function
kprint_nibble:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	andl	$15, %eax
	leal	87(%eax), %edx
	cmpb	$9, %al
	ja	.L68
	leal	48(%eax), %edx
.L68:
	movb	%dl, -2(%ebp)
	movb	$0, -1(%ebp)
	leal	-2(%ebp), %eax
	call	kprint_str.constprop.5
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
	jne	.L76
	testl	%ecx, %ecx
	jns	.L77
	movl	%ecx, %ebx
	movl	%edx, %ecx
	negl	%ecx
	adcl	$0, %ebx
	negl	%ebx
	movl	$-1, -84(%ebp)
	jmp	.L79
.L77:
	movl	%ecx, %eax
	orl	%edx, %eax
	jne	.L76
	movl	$0, -84(%ebp)
	xorl	%ecx, %ecx
	xorl	%ebx, %ebx
.L79:
	leal	-80(%ebp), %eax
	movl	%eax, -88(%ebp)
	movl	8(%ebp), %eax
	xorl	%edx, %edx
	movl	%eax, -128(%ebp)
	movl	%edx, -124(%ebp)
	jmp	.L78
.L76:
	movl	%ecx, %ebx
	movl	%edx, %ecx
	movl	$1, -84(%ebp)
	jmp	.L79
.L81:
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
	ja	.L80
	movb	.LC0(%ecx), %al
.L80:
	movl	-88(%ebp), %ebx
	movb	%al, -1(%ebx)
	movl	-116(%ebp), %ecx
	movl	%edi, %ebx
.L78:
	movl	%ebx, %eax
	orl	%ecx, %eax
	jne	.L81
	movl	-88(%ebp), %edi
	movl	%edi, %eax
	leal	-80(%ebp), %edx
	subl	%edx, %edi
	jne	.L82
	incl	-88(%ebp)
	movb	$48, (%eax)
	movl	$1, %edi
.L82:
	movl	-88(%ebp), %eax
	movb	$0, (%eax)
	movl	-84(%ebp), %eax
	subl	$0, %eax
	js	.L126
	movl	$1, %ebx
	cmpl	$0, -92(%ebp)
	jne	.L83
.L126:
	movl	-84(%ebp), %eax
	shrl	$31, %eax
	xorl	%ebx, %ebx
	cmpl	$0, -96(%ebp)
	setne	%bl
	orl	%eax, %ebx
.L83:
	addl	%edi, %ebx
	movl	%ebx, %eax
	cmpl	$0, 24(%ebp)
	jle	.L85
	cmpl	24(%ebp), %ebx
	jbe	.L85
	movl	24(%ebp), %eax
.L85:
	cmpl	$0, 20(%ebp)
	jle	.L116
	movl	20(%ebp), %edx
	cmpl	%edx, %eax
	jbe	.L87
	xorl	%eax, %eax
.L88:
	movb	$35, (%esi,%eax)
	incl	%eax
	cmpl	20(%ebp), %eax
	jne	.L88
	leal	(%esi,%eax), %edx
	movl	%edx, %eax
	subl	%esi, %eax
	movl	28(%ebp), %esi
	movl	%edx, (%esi)
	jmp	.L127
.L116:
	movl	%eax, %edx
.L87:
	cmpl	%ebx, %edx
	jae	.L91
	movl	%edx, -84(%ebp)
	movl	$.LC1, %eax
	call	kprint_str.constprop.5
	movl	-84(%ebp), %edx
	movl	%edx, %eax
	call	kprint_U32
	movl	$.LC2, %eax
	call	kprint_str.constprop.5
	movl	%ebx, %eax
	call	kprint_U32
	movl	$.LC3, %eax
	call	kprint_str.constprop.5
.L92:
	jmp	.L92
.L91:
	movl	%edx, %eax
	subl	%ebx, %eax
	movl	%eax, -88(%ebp)
	testb	$1, 16(%ebp)
	je	.L93
	cmpl	$-1, -84(%ebp)
	je	.L117
	cmpl	$0, -92(%ebp)
	jne	.L118
	cmpl	$0, -96(%ebp)
	jne	.L119
	movl	%esi, %ecx
.L109:
	leal	-80(%ebp,%edi), %ebx
	movl	%ecx, %edx
.L97:
	incl	%edx
	movb	-1(%ebx), %al
	movb	%al, -1(%edx)
	decl	%ebx
	movl	%edx, %eax
	subl	%ecx, %eax
	cmpl	%edi, %eax
	jb	.L97
	xorl	%ecx, %ecx
.L96:
	cmpl	-88(%ebp), %ecx
	je	.L129
	movb	$32, (%edx,%ecx)
	incl	%ecx
	jmp	.L96
.L129:
	addl	%edx, %ecx
	jmp	.L99
.L93:
	cmpb	$48, -112(%ebp)
	je	.L100
	xorl	%edx, %edx
	jmp	.L101
.L100:
	cmpl	$-1, -84(%ebp)
	je	.L120
	cmpl	$0, -92(%ebp)
	jne	.L121
	cmpl	$0, -96(%ebp)
	jne	.L122
	movl	%esi, %ecx
.L110:
	xorl	%edx, %edx
.L103:
	cmpl	-88(%ebp), %edx
	je	.L130
	movb	$48, (%ecx,%edx)
	incl	%edx
	jmp	.L103
.L130:
	addl	%ecx, %edx
	jmp	.L105
.L101:
	cmpl	-88(%ebp), %edx
	je	.L131
	movb	$32, (%esi,%edx)
	incl	%edx
	jmp	.L101
.L131:
	addl	%esi, %edx
	cmpl	$-1, -84(%ebp)
	je	.L123
	cmpl	$0, -92(%ebp)
	jne	.L124
	cmpl	$0, -96(%ebp)
	jne	.L125
.L105:
	leal	-80(%ebp,%edi), %eax
	movl	%edx, %ecx
.L108:
	incl	%ecx
	movb	-1(%eax), %bl
	movb	%bl, -1(%ecx)
	decl	%eax
	movl	%ecx, %ebx
	subl	%edx, %ebx
	cmpl	%edi, %ebx
	jb	.L108
.L99:
	movl	%ecx, %eax
	subl	%esi, %eax
	movl	28(%ebp), %esi
	movl	%ecx, (%esi)
	jmp	.L127
.L117:
	movb	$45, %dl
	jmp	.L94
.L118:
	movb	$43, %dl
	jmp	.L94
.L119:
	movb	$32, %dl
.L94:
	leal	1(%esi), %ecx
	movb	%dl, (%esi)
	jmp	.L109
.L120:
	movb	$45, %dl
	jmp	.L102
.L121:
	movb	$43, %dl
	jmp	.L102
.L122:
	movb	$32, %dl
.L102:
	leal	1(%esi), %ecx
	movb	%dl, (%esi)
	jmp	.L110
.L123:
	movb	$45, %al
	jmp	.L107
.L124:
	movb	$43, %al
	jmp	.L107
.L125:
	movb	$32, %al
.L107:
	movb	%al, (%edx)
	incl	%edx
	jmp	.L105
.L127:
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
.L133:
	movb	(%edi), %dl
	testb	%dl, %dl
	je	.L158
	cmpl	$0, -36(%ebp)
	je	.L158
	cmpb	$37, %dl
	leal	1(%edi), %eax
	jne	.L134
	leal	-24(%ebp), %edi
	pushl	%edi
	pushl	$-9
	movl	$5, %ecx
	movl	$fmt_flag_char_list, %edx
	call	parse_chars_universal
	popl	%esi
	popl	%edi
	movl	$0, -44(%ebp)
.L135:
	movsbl	(%eax), %edx
	testb	%dl, %dl
	je	.L160
	leal	-48(%edx), %ecx
	cmpb	$9, %cl
	ja	.L175
	imull	$10, -44(%ebp), %ecx
	leal	-48(%ecx,%edx), %edi
	movl	%edi, -44(%ebp)
	incl	%eax
	jmp	.L135
.L175:
	movl	$0, -40(%ebp)
	cmpb	$46, %dl
	jne	.L136
.L173:
	incl	%eax
	movsbl	(%eax), %edx
	leal	-48(%edx), %ecx
	cmpb	$9, %cl
	ja	.L136
	imull	$10, -40(%ebp), %ecx
	leal	-48(%ecx,%edx), %edi
	movl	%edi, -40(%ebp)
	jmp	.L173
.L160:
	movl	$0, -40(%ebp)
.L136:
	xorl	%esi, %esi
.L147:
	movl	fmt_length_list(,%esi,4), %edi
	movl	%eax, %edx
.L140:
	movb	(%edx), %cl
	movb	%cl, -45(%ebp)
	testb	%cl, %cl
	jne	.L141
.L144:
	cmpb	$0, (%edi)
	leal	1(%esi), %esi
	jne	.L171
	movl	%edx, %eax
	jmp	.L146
.L141:
	movb	(%edi), %cl
	testb	%cl, %cl
	je	.L144
	cmpb	%cl, -45(%ebp)
	jne	.L144
	incl	%edx
	incl	%edi
	jmp	.L140
.L171:
	cmpl	$8, %esi
	jne	.L147
	xorw	%si, %si
.L146:
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
	je	.L148
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
	jmp	.L174
.L148:
	testb	$2, %al
	je	.L150
	leal	4(%ebx), %esi
	movl	(%ebx), %eax
.L151:
	cmpb	$0, (%eax)
	je	.L149
	cmpl	$0, -36(%ebp)
	je	.L149
	movl	-28(%ebp), %edx
	leal	1(%edx), %ecx
	movl	%ecx, -28(%ebp)
	incl	%eax
	movb	-1(%eax), %cl
	movb	%cl, (%edx)
	decl	-36(%ebp)
	jmp	.L151
.L150:
	testb	$8, %al
	je	.L153
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
.L174:
	movl	-28(%ebp), %eax
	call	int_to_str.isra.1
	subl	%eax, -36(%ebp)
	addl	$24, %esp
	jmp	.L149
.L153:
	testb	$32, %al
	je	.L154
	cmpl	$4, %esi
	jne	.L155
	leal	8(%ebx), %esi
	movl	(%ebx), %edx
	movl	4(%ebx), %ecx
	jmp	.L156
.L155:
	leal	4(%ebx), %esi
	movl	(%ebx), %edx
	xorl	%ecx, %ecx
.L156:
	leal	-28(%ebp), %eax
	pushl	%eax
	pushl	-40(%ebp)
	pushl	-44(%ebp)
	pushl	-24(%ebp)
	pushl	$1
	pushl	$16
	jmp	.L174
.L154:
	movl	%ebx, %esi
	testb	$4, %al
	je	.L149
	addl	$4, %esi
	movl	(%ebx), %edx
	movl	-28(%ebp), %eax
	movb	%dl, (%eax)
	incl	-28(%ebp)
	decl	-36(%ebp)
.L149:
	movl	%esi, %ebx
	jmp	.L133
.L134:
	movl	-28(%ebp), %ecx
	movb	%dl, (%ecx)
	decl	-36(%ebp)
	incl	-28(%ebp)
	movl	%eax, %edi
	jmp	.L133
.L158:
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
.L177:
	movb	(%edx), %al
	testb	%al, %al
	je	.L180
	incl	%edx
#APP
# 80 "/home/juergen/osexperi/kernel/kernel_user/stdlib.h" 1
	outb %al, $233
# 0 "" 2
#NO_APP
	jmp	.L177
.L180:
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
	call	kprint_str.constprop.5
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
