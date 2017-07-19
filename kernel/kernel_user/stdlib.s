	.file	"stdlib.c"
#APP
	.code16gcc	

#NO_APP
	.text
	.type	is_digit, @function
is_digit:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp
	movl	8(%ebp), %eax
	movb	%al, -4(%ebp)
	cmpb	$47, -4(%ebp)
	jle	.L2
	cmpb	$57, -4(%ebp)
	jg	.L2
	movl	$1, %eax
	jmp	.L3
.L2:
	movl	$0, %eax
.L3:
	leave
	ret
	.size	is_digit, .-is_digit
	.comm	FILE,4,4
	.type	uoutb, @function
uoutb:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movw	%ax, -4(%ebp)
	movb	%dl, -8(%ebp)
	movl	-4(%ebp), %edx
	movb	-8(%ebp), %al
#APP
# 84 "/home/juergen/osexperi/kernel/kernel_user/stdlib.h" 1
	outb %al, %dx
# 0 "" 2
#NO_APP
	leave
	ret
	.size	uoutb, .-uoutb
	.type	make_syscall1, @function
make_syscall1:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$16, %esp
#APP
# 19 "kernel_user/stdlib.c" 1
	movl 8(%ebp), %eax 
	movl 12(%ebp), %ebx 
	int $0x80 
	movl %eax, %esi
# 0 "" 2
#NO_APP
	movl	%esi, -12(%ebp)
	movl	-12(%ebp), %eax
	addl	$16, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	make_syscall1, .-make_syscall1
	.type	make_syscall3, @function
make_syscall3:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$16, %esp
#APP
# 33 "kernel_user/stdlib.c" 1
	movl 8(%ebp), %eax 
	movl 12(%ebp), %ebx 
	movl 16(%ebp), %ecx 
	movl 20(%ebp), %edx 
	int $0x80 
	movl %eax, %esi
# 0 "" 2
#NO_APP
	movl	%esi, -12(%ebp)
	movl	-12(%ebp), %eax
	addl	$16, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	make_syscall3, .-make_syscall3
	.type	handler_wrapper, @function
handler_wrapper:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
#APP
# 50 "kernel_user/stdlib.c" 1
	pushal 
	pushfl 
	
# 0 "" 2
#NO_APP
	movl	$-1073742064, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L11
	movl	$-1073742064, %eax
	movl	(%eax), %eax
	movl	8(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
.L11:
#APP
# 58 "kernel_user/stdlib.c" 1
	popfl 
	popal 
	
# 0 "" 2
#NO_APP
	leave
	ret	$4
	.size	handler_wrapper, .-handler_wrapper
	.globl	register_handler
	.type	register_handler, @function
register_handler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	$-1073742064, %eax
	movl	8(%ebp), %edx
	movl	%edx, (%eax)
	movl	$handler_wrapper, %eax
	movl	%eax, 4(%esp)
	movl	$3, (%esp)
	call	make_syscall1
	leave
	ret
	.size	register_handler, .-register_handler
	.globl	fork
	.type	fork, @function
fork:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	$0, 4(%esp)
	movl	$4, (%esp)
	call	make_syscall1
	leave
	ret
	.size	fork, .-fork
	.globl	ugetc
	.type	ugetc, @function
ugetc:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	$0, -8(%ebp)
	leal	-8(%ebp), %eax
	movl	$4, 12(%esp)
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$1, (%esp)
	call	make_syscall3
	movl	%eax, -4(%ebp)
	movl	-8(%ebp), %eax
	leave
	ret
	.size	ugetc, .-ugetc
	.type	kprint_str, @function
kprint_str:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	ustrlen
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %edx
	movl	12(%ebp), %eax
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$2, (%esp)
	call	make_syscall3
	leave
	ret
	.size	kprint_str, .-kprint_str
	.type	uoutb_kprint_str, @function
uoutb_kprint_str:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, -4(%ebp)
	jmp	.L21
.L22:
	movl	-4(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -4(%ebp)
	movb	(%eax), %al
	movzbl	%al, %eax
	movl	%eax, 4(%esp)
	movl	$233, (%esp)
	call	uoutb
.L21:
	movl	-4(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	jne	.L22
	movl	$0, %eax
	leave
	ret
	.size	uoutb_kprint_str, .-uoutb_kprint_str
	.type	kprint_char, @function
kprint_char:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	8(%ebp), %eax
	movb	%al, -28(%ebp)
	leal	-14(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -12(%ebp)
	movb	-28(%ebp), %dl
	movb	%dl, (%eax)
	movl	-12(%ebp), %eax
	movb	$0, (%eax)
	leal	-14(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$1, (%esp)
	call	kprint_str
	leave
	ret
	.size	kprint_char, .-kprint_char
	.type	kprint_nibble, @function
kprint_nibble:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	8(%ebp), %eax
	movb	%al, -28(%ebp)
	andb	$15, -28(%ebp)
	cmpb	$9, -28(%ebp)
	ja	.L26
	movb	-28(%ebp), %al
	addl	$48, %eax
	jmp	.L27
.L26:
	movb	-28(%ebp), %al
	addl	$87, %eax
.L27:
	movb	%al, -9(%ebp)
	movzbl	-9(%ebp), %eax
	movl	%eax, (%esp)
	call	kprint_char
	movl	$0, %eax
	leave
	ret
	.size	kprint_nibble, .-kprint_nibble
	.type	kprint_byte, @function
kprint_byte:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	8(%ebp), %eax
	movb	%al, -12(%ebp)
	movb	-12(%ebp), %al
	shrb	$4, %al
	movzbl	%al, %eax
	movl	%eax, (%esp)
	call	kprint_nibble
	movzbl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	kprint_nibble
	movl	$0, %eax
	leave
	ret
	.size	kprint_byte, .-kprint_byte
	.type	kprint_U32, @function
kprint_U32:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	8(%ebp), %eax
	shrl	$24, %eax
	movzbl	%al, %eax
	movl	%eax, (%esp)
	call	kprint_byte
	movl	8(%ebp), %eax
	shrl	$16, %eax
	movzbl	%al, %eax
	movl	%eax, (%esp)
	call	kprint_byte
	movl	8(%ebp), %eax
	shrl	$8, %eax
	movzbl	%al, %eax
	movl	%eax, (%esp)
	call	kprint_byte
	movl	8(%ebp), %eax
	movzbl	%al, %eax
	movl	%eax, (%esp)
	call	kprint_byte
	movl	$0, %eax
	leave
	ret
	.size	kprint_U32, .-kprint_U32
	.section	.rodata
.LC0:
	.string	"\n"
	.text
	.type	kprint_newline, @function
kprint_newline:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$.LC0, 4(%esp)
	movl	$1, (%esp)
	call	kprint_str
	leave
	ret
	.size	kprint_newline, .-kprint_newline
	.data
	.type	fmt_flag_char_list, @object
	.size	fmt_flag_char_list, 5
fmt_flag_char_list:
	.byte	45
	.byte	43
	.byte	32
	.byte	35
	.byte	48
	.section	.rodata
.LC1:
	.string	"hh"
.LC2:
	.string	"h"
.LC3:
	.string	"ll"
.LC4:
	.string	"l"
.LC5:
	.string	"L"
.LC6:
	.string	"z"
.LC7:
	.string	"j"
.LC8:
	.string	"t"
	.data
	.align 32
	.type	fmt_length_list, @object
	.size	fmt_length_list, 32
fmt_length_list:
	.long	.LC1
	.long	.LC2
	.long	.LC3
	.long	.LC4
	.long	.LC5
	.long	.LC6
	.long	.LC7
	.long	.LC8
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
	.text
	.type	parse_chars_universal, @function
parse_chars_universal:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	$0, -4(%ebp)
	movl	$0, -8(%ebp)
	movl	$1, -12(%ebp)
	jmp	.L35
.L40:
	movl	$0, -12(%ebp)
	movl	$0, -16(%ebp)
	movl	$0, -16(%ebp)
	jmp	.L36
.L38:
	movl	8(%ebp), %eax
	movb	(%eax), %dl
	movl	-16(%ebp), %ecx
	movl	12(%ebp), %eax
	addl	%ecx, %eax
	movb	(%eax), %al
	cmpb	%al, %dl
	jne	.L37
	movl	-16(%ebp), %eax
	movl	$1, %edx
	movb	%al, %cl
	sall	%cl, %edx
	movl	%edx, %eax
	orl	%eax, -4(%ebp)
	movl	$1, -12(%ebp)
	incl	8(%ebp)
	incl	-8(%ebp)
	jmp	.L35
.L37:
	incl	-16(%ebp)
.L36:
	movl	-16(%ebp), %eax
	cmpl	16(%ebp), %eax
	jl	.L38
.L35:
	movl	8(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	je	.L39
	cmpl	$0, -12(%ebp)
	je	.L39
	movl	-8(%ebp), %eax
	cmpl	20(%ebp), %eax
	jb	.L40
.L39:
	movl	24(%ebp), %eax
	movl	-4(%ebp), %edx
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	leave
	ret
	.size	parse_chars_universal, .-parse_chars_universal
	.type	parse_strings_universal, @function
parse_strings_universal:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	20(%ebp), %eax
	movl	$0, (%eax)
	movl	$0, -4(%ebp)
	movl	$0, -4(%ebp)
	jmp	.L43
.L49:
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	-4(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)
	jmp	.L44
.L46:
	incl	-8(%ebp)
	incl	-12(%ebp)
.L44:
	movl	-8(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	je	.L45
	movl	-12(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	je	.L45
	movl	-8(%ebp), %eax
	movb	(%eax), %dl
	movl	-12(%ebp), %eax
	movb	(%eax), %al
	cmpb	%al, %dl
	je	.L46
.L45:
	movl	-12(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	jne	.L47
	movl	-4(%ebp), %eax
	leal	1(%eax), %edx
	movl	20(%ebp), %eax
	movl	%edx, (%eax)
	movl	-8(%ebp), %eax
	jmp	.L48
.L47:
	incl	-4(%ebp)
.L43:
	movl	16(%ebp), %eax
	cmpl	-4(%ebp), %eax
	ja	.L49
	movl	8(%ebp), %eax
.L48:
	leave
	ret
	.size	parse_strings_universal, .-parse_strings_universal
	.type	parse_num_universal, @function
parse_num_universal:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	$0, -4(%ebp)
	jmp	.L51
.L53:
	movl	-4(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movb	(%eax), %al
	movsbl	%al, %eax
	addl	%edx, %eax
	subl	$48, %eax
	movl	%eax, -4(%ebp)
	incl	8(%ebp)
.L51:
	movl	8(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	je	.L52
	movl	8(%ebp), %eax
	movb	(%eax), %al
	movsbl	%al, %eax
	movl	%eax, (%esp)
	call	is_digit
	testl	%eax, %eax
	jne	.L53
.L52:
	movl	12(%ebp), %eax
	movl	-4(%ebp), %edx
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	leave
	ret
	.size	parse_num_universal, .-parse_num_universal
	.type	parse_format_command, @function
parse_format_command:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	12(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$-9, 12(%esp)
	movl	$5, 8(%esp)
	movl	$fmt_flag_char_list, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	parse_chars_universal
	movl	%eax, 8(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	parse_num_universal
	movl	%eax, 8(%ebp)
	movl	8(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	je	.L56
	movl	8(%ebp), %eax
	movb	(%eax), %al
	cmpb	$46, %al
	jne	.L56
	incl	8(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	parse_num_universal
	movl	%eax, 8(%ebp)
	jmp	.L57
.L56:
	movl	20(%ebp), %eax
	movl	$0, (%eax)
.L57:
	movl	24(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$8, 8(%esp)
	movl	$fmt_length_list, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	parse_strings_universal
	movl	%eax, 8(%ebp)
	movl	28(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$1, 12(%esp)
	movl	$7, 8(%esp)
	movl	$fmt_specifier_list, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	parse_chars_universal
	movl	%eax, 8(%ebp)
	movl	8(%ebp), %eax
	leave
	ret
	.size	parse_format_command, .-parse_format_command
	.type	__udivdi3, @function
__udivdi3:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	8(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -20(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, -32(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, -28(%ebp)
	movl	$0, -8(%ebp)
	movl	$0, -4(%ebp)
	movw	$0, -10(%ebp)
	jmp	.L60
.L61:
	movl	-32(%ebp), %eax
	movl	-28(%ebp), %edx
	addl	%eax, %eax
	adcl	%edx, %edx
	movl	%eax, -32(%ebp)
	movl	%edx, -28(%ebp)
	movw	-10(%ebp), %ax
	incl	%eax
	movw	%ax, -10(%ebp)
.L60:
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	cmpl	-28(%ebp), %edx
	ja	.L61
	cmpl	-28(%ebp), %edx
	jb	.L71
	cmpl	-32(%ebp), %eax
	jae	.L61
.L71:
	movl	-32(%ebp), %eax
	movl	-28(%ebp), %edx
	shrdl	$1, %edx, %eax
	shrl	%edx
	movl	%eax, -32(%ebp)
	movl	%edx, -28(%ebp)
	movw	-10(%ebp), %ax
	decl	%eax
	movw	%ax, -10(%ebp)
	jmp	.L63
.L68:
	movl	-32(%ebp), %eax
	movl	-28(%ebp), %edx
	subl	%eax, -24(%ebp)
	sbbl	%edx, -20(%ebp)
	movswl	-10(%ebp), %ecx
	movl	$1, %eax
	movl	$0, %edx
	shldl	%eax, %edx
	sall	%cl, %eax
	testb	$32, %cl
	je	.L72
	movl	%eax, %edx
	xorl	%eax, %eax
.L72:
	orl	%eax, -8(%ebp)
	orl	%edx, -4(%ebp)
	jmp	.L64
.L65:
	movl	-32(%ebp), %eax
	movl	-28(%ebp), %edx
	shrdl	$1, %edx, %eax
	shrl	%edx
	movl	%eax, -32(%ebp)
	movl	%edx, -28(%ebp)
	movw	-10(%ebp), %ax
	decl	%eax
	movw	%ax, -10(%ebp)
.L64:
	cmpw	$0, -10(%ebp)
	jle	.L63
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	cmpl	-28(%ebp), %edx
	jb	.L65
	cmpl	-28(%ebp), %edx
	ja	.L63
	cmpl	-32(%ebp), %eax
	jb	.L65
.L63:
	cmpw	$0, -10(%ebp)
	js	.L67
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	cmpl	-28(%ebp), %edx
	ja	.L68
	cmpl	-28(%ebp), %edx
	jb	.L67
	cmpl	-32(%ebp), %eax
	jae	.L68
.L67:
	movl	-8(%ebp), %eax
	movl	-4(%ebp), %edx
	leave
	ret
	.size	__udivdi3, .-__udivdi3
	.type	__umoddi3, @function
__umoddi3:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$36, %esp
	movl	8(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, -20(%ebp)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	%eax, 8(%esp)
	movl	%edx, 12(%esp)
	movl	-16(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__udivdi3
	movl	-24(%ebp), %ecx
	movl	%ecx, %ebx
	imull	%edx, %ebx
	movl	-20(%ebp), %ecx
	imull	%eax, %ecx
	addl	%ebx, %ecx
	mull	-24(%ebp)
	addl	%edx, %ecx
	movl	%ecx, %edx
	movl	-16(%ebp), %ecx
	movl	-12(%ebp), %ebx
	subl	%eax, %ecx
	sbbl	%edx, %ebx
	movl	%ecx, %eax
	movl	%ebx, %edx
	addl	$36, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	__umoddi3, .-__umoddi3
	.section	.rodata
.LC9:
	.string	"0123456789abcdef"
.LC10:
	.string	"Assertion failed.\n"
.LC11:
	.string	" * "
	.text
	.type	int_to_str, @function
int_to_str:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$232, %esp
	movl	16(%ebp), %eax
	movl	%eax, -208(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, -204(%ebp)
	movl	$16, -64(%ebp)
	movl	$.LC9, -68(%ebp)
	leal	-191(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	-208(%ebp), %eax
	movl	-204(%ebp), %edx
	movl	%eax, -80(%ebp)
	movl	%edx, -76(%ebp)
	movl	$0, -84(%ebp)
	movl	$0, -88(%ebp)
	movl	$0, -24(%ebp)
	movl	$0, -20(%ebp)
	movl	$0, -28(%ebp)
	movl	32(%ebp), %eax
	andl	$2, %eax
	movl	%eax, -92(%ebp)
	movl	32(%ebp), %eax
	andl	$1, %eax
	movl	%eax, -96(%ebp)
	movl	32(%ebp), %eax
	andl	$4, %eax
	movl	%eax, -100(%ebp)
	movl	32(%ebp), %eax
	andl	$16, %eax
	testl	%eax, %eax
	je	.L76
	movb	$48, %al
	jmp	.L77
.L76:
	movb	$32, %al
.L77:
	movb	%al, -101(%ebp)
	movl	32(%ebp), %eax
	andl	$8, %eax
	movl	%eax, -108(%ebp)
	cmpl	$0, 28(%ebp)
	jne	.L78
	cmpl	$0, -76(%ebp)
	jns	.L79
	movl	$-1, -28(%ebp)
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	negl	%eax
	adcl	$0, %edx
	negl	%edx
	movl	%eax, -24(%ebp)
	movl	%edx, -20(%ebp)
	jmp	.L82
.L79:
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	orl	%edx, %eax
	testl	%eax, %eax
	jne	.L81
	movl	$0, -28(%ebp)
	movl	$0, -24(%ebp)
	movl	$0, -20(%ebp)
	jmp	.L82
.L81:
	movl	$1, -28(%ebp)
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	movl	%eax, -24(%ebp)
	movl	%edx, -20(%ebp)
	jmp	.L83
.L78:
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	movl	%eax, -24(%ebp)
	movl	%edx, -20(%ebp)
	movl	$1, -28(%ebp)
	jmp	.L83
.L82:
	jmp	.L83
.L86:
	movl	24(%ebp), %eax
	movl	$0, %edx
	movl	%eax, 8(%esp)
	movl	%edx, 12(%esp)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__umoddi3
	movl	%eax, -112(%ebp)
	movl	24(%ebp), %eax
	movl	$0, %edx
	movl	%eax, 8(%esp)
	movl	%edx, 12(%esp)
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__udivdi3
	movl	%eax, -24(%ebp)
	movl	%edx, -20(%ebp)
	movl	-12(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -12(%ebp)
	movl	-112(%ebp), %edx
	cmpl	-64(%ebp), %edx
	jae	.L84
	movl	-112(%ebp), %edx
	movl	-68(%ebp), %ecx
	addl	%ecx, %edx
	movb	(%edx), %dl
	jmp	.L85
.L84:
	movb	$63, %dl
.L85:
	movb	%dl, (%eax)
.L83:
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	orl	%edx, %eax
	testl	%eax, %eax
	jne	.L86
	movl	-12(%ebp), %edx
	leal	-191(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -32(%ebp)
	cmpl	$0, -32(%ebp)
	jne	.L87
	movl	-12(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -12(%ebp)
	movb	$48, (%eax)
	incl	-32(%ebp)
.L87:
	movl	-12(%ebp), %eax
	movb	$0, (%eax)
	movl	$0, -36(%ebp)
	cmpl	$0, -28(%ebp)
	js	.L88
	cmpl	$0, -92(%ebp)
	jne	.L89
.L88:
	cmpl	$0, -28(%ebp)
	js	.L89
	cmpl	$0, -100(%ebp)
	je	.L90
.L89:
	movl	$1, %eax
	jmp	.L91
.L90:
	movl	$0, %eax
.L91:
	movl	%eax, -116(%ebp)
	movl	-116(%ebp), %eax
	movl	-32(%ebp), %edx
	addl	%edx, %eax
	movl	%eax, -120(%ebp)
	cmpl	$0, 40(%ebp)
	jle	.L92
	movl	40(%ebp), %eax
	movl	-120(%ebp), %edx
	cmpl	%edx, %eax
	jbe	.L93
	movl	%edx, %eax
.L93:
	movl	%eax, -36(%ebp)
	jmp	.L94
.L92:
	movl	-120(%ebp), %eax
	movl	%eax, -36(%ebp)
.L94:
	movl	$0, -40(%ebp)
	cmpl	$0, 36(%ebp)
	jle	.L95
	movl	36(%ebp), %eax
	cmpl	-36(%ebp), %eax
	setb	%al
	movzbl	%al, %eax
	movl	%eax, -40(%ebp)
	movl	36(%ebp), %eax
	movl	%eax, -36(%ebp)
.L95:
	cmpl	$0, -40(%ebp)
	je	.L96
	movl	$0, -44(%ebp)
	movl	$0, -44(%ebp)
	jmp	.L97
.L98:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$35, (%eax)
	incl	-44(%ebp)
.L97:
	movl	36(%ebp), %eax
	cmpl	-44(%ebp), %eax
	ja	.L98
	movl	-16(%ebp), %edx
	movl	8(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -84(%ebp)
	movl	48(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, (%eax)
	movl	-84(%ebp), %eax
	jmp	.L139
.L96:
	movl	-120(%ebp), %eax
	movl	-36(%ebp), %edx
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -124(%ebp)
	movl	-36(%ebp), %eax
	cmpl	-120(%ebp), %eax
	jae	.L100
	movl	$.LC10, 4(%esp)
	movl	$1, (%esp)
	call	kprint_str
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	kprint_U32
	movl	$.LC11, 4(%esp)
	movl	$1, (%esp)
	call	kprint_str
	movl	-120(%ebp), %eax
	movl	%eax, (%esp)
	call	kprint_U32
	movl	$.LC0, 4(%esp)
	movl	$1, (%esp)
	call	kprint_str
.L101:
	jmp	.L101
.L100:
	cmpl	$0, -96(%ebp)
	je	.L102
	cmpl	$0, -28(%ebp)
	js	.L103
	cmpl	$0, -92(%ebp)
	je	.L104
	cmpl	$0, -28(%ebp)
	jns	.L105
.L104:
	cmpl	$0, -100(%ebp)
	je	.L106
	movb	$32, %al
	jmp	.L107
.L106:
	movb	$35, %al
.L107:
	jmp	.L108
.L105:
	movb	$43, %al
.L108:
	jmp	.L109
.L103:
	movb	$45, %al
.L109:
	movb	%al, -125(%ebp)
	cmpb	$35, -125(%ebp)
	je	.L110
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	-125(%ebp), %dl
	movb	%dl, (%eax)
.L110:
	movl	$0, -48(%ebp)
	movl	$0, -48(%ebp)
	jmp	.L111
.L112:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movl	-48(%ebp), %edx
	movl	-32(%ebp), %ecx
	subl	%edx, %ecx
	movl	%ecx, %edx
	leal	-1(%edx), %ecx
	leal	-191(%ebp), %edx
	addl	%ecx, %edx
	movb	(%edx), %dl
	movb	%dl, (%eax)
	incl	-48(%ebp)
.L111:
	movl	-48(%ebp), %eax
	cmpl	-32(%ebp), %eax
	jb	.L112
	movl	$0, -48(%ebp)
	jmp	.L113
.L114:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$32, (%eax)
	incl	-48(%ebp)
.L113:
	movl	-48(%ebp), %eax
	cmpl	-124(%ebp), %eax
	jb	.L114
	jmp	.L115
.L102:
	cmpb	$48, -101(%ebp)
	jne	.L116
	cmpl	$0, -28(%ebp)
	js	.L117
	cmpl	$0, -92(%ebp)
	je	.L118
	cmpl	$0, -28(%ebp)
	jns	.L119
.L118:
	cmpl	$0, -100(%ebp)
	je	.L120
	movb	$32, %al
	jmp	.L121
.L120:
	movb	$35, %al
.L121:
	jmp	.L122
.L119:
	movb	$43, %al
.L122:
	jmp	.L123
.L117:
	movb	$45, %al
.L123:
	movb	%al, -126(%ebp)
	cmpb	$35, -126(%ebp)
	je	.L124
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	-126(%ebp), %dl
	movb	%dl, (%eax)
.L124:
	movl	$0, -52(%ebp)
	movl	$0, -52(%ebp)
	jmp	.L125
.L126:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$48, (%eax)
	incl	-52(%ebp)
.L125:
	movl	-52(%ebp), %eax
	cmpl	-124(%ebp), %eax
	jb	.L126
	jmp	.L127
.L116:
	movl	$0, -56(%ebp)
	movl	$0, -56(%ebp)
	jmp	.L128
.L129:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$32, (%eax)
	incl	-56(%ebp)
.L128:
	movl	-56(%ebp), %eax
	cmpl	-124(%ebp), %eax
	jb	.L129
	cmpl	$0, -28(%ebp)
	js	.L130
	cmpl	$0, -92(%ebp)
	je	.L131
	cmpl	$0, -28(%ebp)
	jns	.L132
.L131:
	cmpl	$0, -100(%ebp)
	je	.L133
	movb	$32, %al
	jmp	.L134
.L133:
	movb	$35, %al
.L134:
	jmp	.L135
.L132:
	movb	$43, %al
.L135:
	jmp	.L136
.L130:
	movb	$45, %al
.L136:
	movb	%al, -127(%ebp)
	cmpb	$35, -127(%ebp)
	je	.L127
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	-127(%ebp), %dl
	movb	%dl, (%eax)
.L127:
	movl	$0, -60(%ebp)
	movl	$0, -60(%ebp)
	jmp	.L137
.L138:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movl	-60(%ebp), %edx
	movl	-32(%ebp), %ecx
	subl	%edx, %ecx
	movl	%ecx, %edx
	leal	-1(%edx), %ecx
	leal	-191(%ebp), %edx
	addl	%ecx, %edx
	movb	(%edx), %dl
	movb	%dl, (%eax)
	incl	-60(%ebp)
.L137:
	movl	-60(%ebp), %eax
	cmpl	-32(%ebp), %eax
	jb	.L138
.L115:
	movl	-16(%ebp), %edx
	movl	8(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -84(%ebp)
	movl	48(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, (%eax)
	movl	-84(%ebp), %eax
.L139:
	leave
	ret
	.size	int_to_str, .-int_to_str
	.type	vprintf, @function
vprintf:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$156, %esp
	movl	16(%ebp), %eax
	movl	%eax, -28(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -76(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -32(%ebp)
	jmp	.L141
.L154:
	movl	-28(%ebp), %eax
	movb	(%eax), %al
	cmpb	$37, %al
	jne	.L142
	incl	-28(%ebp)
	leal	-88(%ebp), %eax
	movl	%eax, 20(%esp)
	leal	-84(%ebp), %eax
	movl	%eax, 16(%esp)
	leal	-96(%ebp), %eax
	movl	%eax, 12(%esp)
	leal	-92(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-80(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	parse_format_command
	movl	%eax, -28(%ebp)
	movl	-88(%ebp), %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L143
	movl	20(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	(%eax), %eax
	movl	%eax, -52(%ebp)
	movl	-84(%ebp), %eax
	movl	%eax, -108(%ebp)
	movl	-96(%ebp), %eax
	movl	%eax, -112(%ebp)
	movl	-92(%ebp), %eax
	movl	%eax, %edi
	movl	-80(%ebp), %esi
	movl	-52(%ebp), %eax
	cltd
	movl	-76(%ebp), %ebx
	leal	-76(%ebp), %ecx
	movl	%ecx, 40(%esp)
	movl	-108(%ebp), %ecx
	movl	%ecx, 36(%esp)
	movl	-112(%ebp), %ecx
	movl	%ecx, 32(%esp)
	movl	%edi, 28(%esp)
	movl	%esi, 24(%esp)
	movl	$0, 20(%esp)
	movl	$10, 16(%esp)
	movl	%eax, 8(%esp)
	movl	%edx, 12(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%ebx, (%esp)
	call	int_to_str
	movl	%eax, -56(%ebp)
	movl	-56(%ebp), %eax
	subl	%eax, -32(%ebp)
	jmp	.L144
.L143:
	movl	-88(%ebp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L145
	movl	20(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	(%eax), %eax
	movl	%eax, -36(%ebp)
	jmp	.L146
.L148:
	movl	-76(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -76(%ebp)
	movl	-36(%ebp), %edx
	leal	1(%edx), %ecx
	movl	%ecx, -36(%ebp)
	movb	(%edx), %dl
	movb	%dl, (%eax)
	decl	-32(%ebp)
.L146:
	movl	-36(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	je	.L147
	cmpl	$0, -32(%ebp)
	jne	.L148
.L147:
	jmp	.L144
.L145:
	movl	-88(%ebp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L149
	movl	20(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	(%eax), %eax
	movl	%eax, -60(%ebp)
	movl	-84(%ebp), %eax
	movl	%eax, -108(%ebp)
	movl	-96(%ebp), %eax
	movl	%eax, -112(%ebp)
	movl	-92(%ebp), %eax
	movl	%eax, %edi
	movl	-80(%ebp), %esi
	movl	-60(%ebp), %eax
	cltd
	movl	-76(%ebp), %ebx
	leal	-76(%ebp), %ecx
	movl	%ecx, 40(%esp)
	movl	-108(%ebp), %ecx
	movl	%ecx, 36(%esp)
	movl	-112(%ebp), %ecx
	movl	%ecx, 32(%esp)
	movl	%edi, 28(%esp)
	movl	%esi, 24(%esp)
	movl	$1, 20(%esp)
	movl	$8, 16(%esp)
	movl	%eax, 8(%esp)
	movl	%edx, 12(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%ebx, (%esp)
	call	int_to_str
	movl	%eax, -64(%ebp)
	movl	-64(%ebp), %eax
	subl	%eax, -32(%ebp)
	jmp	.L144
.L149:
	movl	-88(%ebp), %eax
	andl	$32, %eax
	testl	%eax, %eax
	je	.L150
	movl	$0, -48(%ebp)
	movl	$0, -44(%ebp)
	movl	-84(%ebp), %eax
	cmpl	$4, %eax
	jne	.L151
	movl	20(%ebp), %eax
	leal	8(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, -48(%ebp)
	movl	%edx, -44(%ebp)
	jmp	.L152
.L151:
	movl	20(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	(%eax), %eax
	movl	%eax, -48(%ebp)
	movl	$0, -44(%ebp)
.L152:
	movl	-84(%ebp), %esi
	movl	-96(%ebp), %eax
	movl	%eax, %ebx
	movl	-92(%ebp), %eax
	movl	%eax, %edx
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %ecx
	leal	-76(%ebp), %edi
	movl	%edi, 40(%esp)
	movl	%esi, 36(%esp)
	movl	%ebx, 32(%esp)
	movl	%edx, 28(%esp)
	movl	%eax, 24(%esp)
	movl	$1, 20(%esp)
	movl	$16, 16(%esp)
	movl	-48(%ebp), %eax
	movl	-44(%ebp), %edx
	movl	%eax, 8(%esp)
	movl	%edx, 12(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	int_to_str
	movl	%eax, -68(%ebp)
	movl	-68(%ebp), %eax
	subl	%eax, -32(%ebp)
	jmp	.L144
.L150:
	movl	-88(%ebp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L144
	movl	20(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	(%eax), %eax
	movl	%eax, -72(%ebp)
	movl	-76(%ebp), %eax
	movl	-72(%ebp), %edx
	movb	%dl, (%eax)
	movl	-76(%ebp), %eax
	incl	%eax
	movl	%eax, -76(%ebp)
	decl	-32(%ebp)
	jmp	.L141
.L144:
	jmp	.L141
.L142:
	movl	-76(%ebp), %eax
	movl	-28(%ebp), %edx
	movb	(%edx), %dl
	movb	%dl, (%eax)
	decl	-32(%ebp)
	movl	-76(%ebp), %eax
	incl	%eax
	movl	%eax, -76(%ebp)
	incl	-28(%ebp)
.L141:
	movl	-28(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	je	.L153
	cmpl	$0, -32(%ebp)
	jne	.L154
.L153:
	movl	-76(%ebp), %eax
	movb	$0, (%eax)
	addl	$156, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	vprintf, .-vprintf
	.globl	uprintf
	.type	uprintf, @function
uprintf:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$1064, %esp
	movl	$0, -12(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -16(%ebp)
	leal	12(%ebp), %eax
	movl	%eax, -1044(%ebp)
	movl	-1044(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$1024, 4(%esp)
	leal	-1040(%ebp), %eax
	movl	%eax, (%esp)
	call	vprintf
	leal	-1040(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$1, (%esp)
	call	kprint_str
	leave
	ret
	.size	uprintf, .-uprintf
	.globl	uoutb_printf
	.type	uoutb_printf, @function
uoutb_printf:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$1064, %esp
	movl	$0, -12(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -16(%ebp)
	leal	12(%ebp), %eax
	movl	%eax, -1044(%ebp)
	movl	-1044(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$1024, 4(%esp)
	leal	-1040(%ebp), %eax
	movl	%eax, (%esp)
	call	vprintf
	leal	-1040(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$1, (%esp)
	call	uoutb_kprint_str
	leave
	ret
	.size	uoutb_printf, .-uoutb_printf
	.globl	ustrlen
	.type	ustrlen, @function
ustrlen:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	$0, -4(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	jmp	.L160
.L161:
	incl	-4(%ebp)
.L160:
	movl	-8(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -8(%ebp)
	movb	(%eax), %al
	testb	%al, %al
	jne	.L161
	movl	-4(%ebp), %eax
	leave
	ret
	.size	ustrlen, .-ustrlen
	.ident	"GCC: (GNU) 4.8.2 20140120 (Red Hat 4.8.2-15)"
	.section	.note.GNU-stack,"",@progbits
