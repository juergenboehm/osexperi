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
# 80 "/home/juergen/osexperi/kernel/kernel_user/stdlib.h" 1
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
	jmp	.L19
.L20:
	movl	-4(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -4(%ebp)
	movb	(%eax), %al
	movzbl	%al, %eax
	movl	%eax, 4(%esp)
	movl	$233, (%esp)
	call	uoutb
.L19:
	movl	-4(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	jne	.L20
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
	ja	.L24
	movb	-28(%ebp), %al
	addl	$48, %eax
	jmp	.L25
.L24:
	movb	-28(%ebp), %al
	addl	$87, %eax
.L25:
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
	jmp	.L33
.L38:
	movl	$0, -12(%ebp)
	movl	$0, -16(%ebp)
	movl	$0, -16(%ebp)
	jmp	.L34
.L36:
	movl	8(%ebp), %eax
	movb	(%eax), %dl
	movl	-16(%ebp), %ecx
	movl	12(%ebp), %eax
	addl	%ecx, %eax
	movb	(%eax), %al
	cmpb	%al, %dl
	jne	.L35
	movl	-16(%ebp), %eax
	movl	$1, %edx
	movb	%al, %cl
	sall	%cl, %edx
	movl	%edx, %eax
	orl	%eax, -4(%ebp)
	movl	$1, -12(%ebp)
	incl	8(%ebp)
	incl	-8(%ebp)
	jmp	.L33
.L35:
	incl	-16(%ebp)
.L34:
	movl	-16(%ebp), %eax
	cmpl	16(%ebp), %eax
	jl	.L36
.L33:
	movl	8(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	je	.L37
	cmpl	$0, -12(%ebp)
	je	.L37
	movl	-8(%ebp), %eax
	cmpl	20(%ebp), %eax
	jb	.L38
.L37:
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
	jmp	.L41
.L47:
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	-4(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)
	jmp	.L42
.L44:
	incl	-8(%ebp)
	incl	-12(%ebp)
.L42:
	movl	-8(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	je	.L43
	movl	-12(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	je	.L43
	movl	-8(%ebp), %eax
	movb	(%eax), %dl
	movl	-12(%ebp), %eax
	movb	(%eax), %al
	cmpb	%al, %dl
	je	.L44
.L43:
	movl	-12(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	jne	.L45
	movl	-4(%ebp), %eax
	leal	1(%eax), %edx
	movl	20(%ebp), %eax
	movl	%edx, (%eax)
	movl	-8(%ebp), %eax
	jmp	.L46
.L45:
	incl	-4(%ebp)
.L41:
	movl	16(%ebp), %eax
	cmpl	-4(%ebp), %eax
	ja	.L47
	movl	8(%ebp), %eax
.L46:
	leave
	ret
	.size	parse_strings_universal, .-parse_strings_universal
	.type	parse_num_universal, @function
parse_num_universal:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	$0, -4(%ebp)
	jmp	.L49
.L51:
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
.L49:
	movl	8(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	je	.L50
	movl	8(%ebp), %eax
	movb	(%eax), %al
	movsbl	%al, %eax
	movl	%eax, (%esp)
	call	is_digit
	testl	%eax, %eax
	jne	.L51
.L50:
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
	je	.L54
	movl	8(%ebp), %eax
	movb	(%eax), %al
	cmpb	$46, %al
	jne	.L54
	incl	8(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	parse_num_universal
	movl	%eax, 8(%ebp)
	jmp	.L55
.L54:
	movl	20(%ebp), %eax
	movl	$0, (%eax)
.L55:
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
	jmp	.L58
.L59:
	movl	-32(%ebp), %eax
	movl	-28(%ebp), %edx
	addl	%eax, %eax
	adcl	%edx, %edx
	movl	%eax, -32(%ebp)
	movl	%edx, -28(%ebp)
	movw	-10(%ebp), %ax
	incl	%eax
	movw	%ax, -10(%ebp)
.L58:
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	cmpl	-28(%ebp), %edx
	ja	.L59
	cmpl	-28(%ebp), %edx
	jb	.L69
	cmpl	-32(%ebp), %eax
	jae	.L59
.L69:
	movl	-32(%ebp), %eax
	movl	-28(%ebp), %edx
	shrdl	$1, %edx, %eax
	shrl	%edx
	movl	%eax, -32(%ebp)
	movl	%edx, -28(%ebp)
	movw	-10(%ebp), %ax
	decl	%eax
	movw	%ax, -10(%ebp)
	jmp	.L61
.L66:
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
	je	.L70
	movl	%eax, %edx
	xorl	%eax, %eax
.L70:
	orl	%eax, -8(%ebp)
	orl	%edx, -4(%ebp)
	jmp	.L62
.L63:
	movl	-32(%ebp), %eax
	movl	-28(%ebp), %edx
	shrdl	$1, %edx, %eax
	shrl	%edx
	movl	%eax, -32(%ebp)
	movl	%edx, -28(%ebp)
	movw	-10(%ebp), %ax
	decl	%eax
	movw	%ax, -10(%ebp)
.L62:
	cmpw	$0, -10(%ebp)
	jle	.L61
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	cmpl	-28(%ebp), %edx
	jb	.L63
	cmpl	-28(%ebp), %edx
	ja	.L61
	cmpl	-32(%ebp), %eax
	jb	.L63
.L61:
	cmpw	$0, -10(%ebp)
	js	.L65
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	cmpl	-28(%ebp), %edx
	ja	.L66
	cmpl	-28(%ebp), %edx
	jb	.L65
	cmpl	-32(%ebp), %eax
	jae	.L66
.L65:
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
	je	.L74
	movb	$48, %al
	jmp	.L75
.L74:
	movb	$32, %al
.L75:
	movb	%al, -101(%ebp)
	movl	32(%ebp), %eax
	andl	$8, %eax
	movl	%eax, -108(%ebp)
	cmpl	$0, 28(%ebp)
	jne	.L76
	cmpl	$0, -76(%ebp)
	jns	.L77
	movl	$-1, -28(%ebp)
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	negl	%eax
	adcl	$0, %edx
	negl	%edx
	movl	%eax, -24(%ebp)
	movl	%edx, -20(%ebp)
	jmp	.L80
.L77:
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	orl	%edx, %eax
	testl	%eax, %eax
	jne	.L79
	movl	$0, -28(%ebp)
	movl	$0, -24(%ebp)
	movl	$0, -20(%ebp)
	jmp	.L80
.L79:
	movl	$1, -28(%ebp)
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	movl	%eax, -24(%ebp)
	movl	%edx, -20(%ebp)
	jmp	.L81
.L76:
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	movl	%eax, -24(%ebp)
	movl	%edx, -20(%ebp)
	movl	$1, -28(%ebp)
	jmp	.L81
.L80:
	jmp	.L81
.L84:
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
	jae	.L82
	movl	-112(%ebp), %edx
	movl	-68(%ebp), %ecx
	addl	%ecx, %edx
	movb	(%edx), %dl
	jmp	.L83
.L82:
	movb	$63, %dl
.L83:
	movb	%dl, (%eax)
.L81:
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	orl	%edx, %eax
	testl	%eax, %eax
	jne	.L84
	movl	-12(%ebp), %edx
	leal	-191(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -32(%ebp)
	cmpl	$0, -32(%ebp)
	jne	.L85
	movl	-12(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -12(%ebp)
	movb	$48, (%eax)
	incl	-32(%ebp)
.L85:
	movl	-12(%ebp), %eax
	movb	$0, (%eax)
	movl	$0, -36(%ebp)
	cmpl	$0, -28(%ebp)
	js	.L86
	cmpl	$0, -92(%ebp)
	jne	.L87
.L86:
	cmpl	$0, -28(%ebp)
	js	.L87
	cmpl	$0, -100(%ebp)
	je	.L88
.L87:
	movl	$1, %eax
	jmp	.L89
.L88:
	movl	$0, %eax
.L89:
	movl	%eax, -116(%ebp)
	movl	-116(%ebp), %eax
	movl	-32(%ebp), %edx
	addl	%edx, %eax
	movl	%eax, -120(%ebp)
	cmpl	$0, 40(%ebp)
	jle	.L90
	movl	40(%ebp), %eax
	movl	-120(%ebp), %edx
	cmpl	%edx, %eax
	jbe	.L91
	movl	%edx, %eax
.L91:
	movl	%eax, -36(%ebp)
	jmp	.L92
.L90:
	movl	-120(%ebp), %eax
	movl	%eax, -36(%ebp)
.L92:
	movl	$0, -40(%ebp)
	cmpl	$0, 36(%ebp)
	jle	.L93
	movl	36(%ebp), %eax
	cmpl	-36(%ebp), %eax
	setb	%al
	movzbl	%al, %eax
	movl	%eax, -40(%ebp)
	movl	36(%ebp), %eax
	movl	%eax, -36(%ebp)
.L93:
	cmpl	$0, -40(%ebp)
	je	.L94
	movl	$0, -44(%ebp)
	movl	$0, -44(%ebp)
	jmp	.L95
.L96:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$35, (%eax)
	incl	-44(%ebp)
.L95:
	movl	36(%ebp), %eax
	cmpl	-44(%ebp), %eax
	ja	.L96
	movl	-16(%ebp), %edx
	movl	8(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -84(%ebp)
	movl	48(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, (%eax)
	movl	-84(%ebp), %eax
	jmp	.L137
.L94:
	movl	-120(%ebp), %eax
	movl	-36(%ebp), %edx
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -124(%ebp)
	movl	-36(%ebp), %eax
	cmpl	-120(%ebp), %eax
	jae	.L98
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
.L99:
	jmp	.L99
.L98:
	cmpl	$0, -96(%ebp)
	je	.L100
	cmpl	$0, -28(%ebp)
	js	.L101
	cmpl	$0, -92(%ebp)
	je	.L102
	cmpl	$0, -28(%ebp)
	jns	.L103
.L102:
	cmpl	$0, -100(%ebp)
	je	.L104
	movb	$32, %al
	jmp	.L105
.L104:
	movb	$35, %al
.L105:
	jmp	.L106
.L103:
	movb	$43, %al
.L106:
	jmp	.L107
.L101:
	movb	$45, %al
.L107:
	movb	%al, -125(%ebp)
	cmpb	$35, -125(%ebp)
	je	.L108
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	-125(%ebp), %dl
	movb	%dl, (%eax)
.L108:
	movl	$0, -48(%ebp)
	movl	$0, -48(%ebp)
	jmp	.L109
.L110:
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
.L109:
	movl	-48(%ebp), %eax
	cmpl	-32(%ebp), %eax
	jb	.L110
	movl	$0, -48(%ebp)
	jmp	.L111
.L112:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$32, (%eax)
	incl	-48(%ebp)
.L111:
	movl	-48(%ebp), %eax
	cmpl	-124(%ebp), %eax
	jb	.L112
	jmp	.L113
.L100:
	cmpb	$48, -101(%ebp)
	jne	.L114
	cmpl	$0, -28(%ebp)
	js	.L115
	cmpl	$0, -92(%ebp)
	je	.L116
	cmpl	$0, -28(%ebp)
	jns	.L117
.L116:
	cmpl	$0, -100(%ebp)
	je	.L118
	movb	$32, %al
	jmp	.L119
.L118:
	movb	$35, %al
.L119:
	jmp	.L120
.L117:
	movb	$43, %al
.L120:
	jmp	.L121
.L115:
	movb	$45, %al
.L121:
	movb	%al, -126(%ebp)
	cmpb	$35, -126(%ebp)
	je	.L122
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	-126(%ebp), %dl
	movb	%dl, (%eax)
.L122:
	movl	$0, -52(%ebp)
	movl	$0, -52(%ebp)
	jmp	.L123
.L124:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$48, (%eax)
	incl	-52(%ebp)
.L123:
	movl	-52(%ebp), %eax
	cmpl	-124(%ebp), %eax
	jb	.L124
	jmp	.L125
.L114:
	movl	$0, -56(%ebp)
	movl	$0, -56(%ebp)
	jmp	.L126
.L127:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$32, (%eax)
	incl	-56(%ebp)
.L126:
	movl	-56(%ebp), %eax
	cmpl	-124(%ebp), %eax
	jb	.L127
	cmpl	$0, -28(%ebp)
	js	.L128
	cmpl	$0, -92(%ebp)
	je	.L129
	cmpl	$0, -28(%ebp)
	jns	.L130
.L129:
	cmpl	$0, -100(%ebp)
	je	.L131
	movb	$32, %al
	jmp	.L132
.L131:
	movb	$35, %al
.L132:
	jmp	.L133
.L130:
	movb	$43, %al
.L133:
	jmp	.L134
.L128:
	movb	$45, %al
.L134:
	movb	%al, -127(%ebp)
	cmpb	$35, -127(%ebp)
	je	.L125
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	-127(%ebp), %dl
	movb	%dl, (%eax)
.L125:
	movl	$0, -60(%ebp)
	movl	$0, -60(%ebp)
	jmp	.L135
.L136:
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
.L135:
	movl	-60(%ebp), %eax
	cmpl	-32(%ebp), %eax
	jb	.L136
.L113:
	movl	-16(%ebp), %edx
	movl	8(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -84(%ebp)
	movl	48(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, (%eax)
	movl	-84(%ebp), %eax
.L137:
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
	jmp	.L139
.L152:
	movl	-28(%ebp), %eax
	movb	(%eax), %al
	cmpb	$37, %al
	jne	.L140
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
	je	.L141
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
	jmp	.L142
.L141:
	movl	-88(%ebp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L143
	movl	20(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	(%eax), %eax
	movl	%eax, -36(%ebp)
	jmp	.L144
.L146:
	movl	-76(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -76(%ebp)
	movl	-36(%ebp), %edx
	leal	1(%edx), %ecx
	movl	%ecx, -36(%ebp)
	movb	(%edx), %dl
	movb	%dl, (%eax)
	decl	-32(%ebp)
.L144:
	movl	-36(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	je	.L145
	cmpl	$0, -32(%ebp)
	jne	.L146
.L145:
	jmp	.L142
.L143:
	movl	-88(%ebp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L147
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
	jmp	.L142
.L147:
	movl	-88(%ebp), %eax
	andl	$32, %eax
	testl	%eax, %eax
	je	.L148
	movl	$0, -48(%ebp)
	movl	$0, -44(%ebp)
	movl	-84(%ebp), %eax
	cmpl	$4, %eax
	jne	.L149
	movl	20(%ebp), %eax
	leal	8(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, -48(%ebp)
	movl	%edx, -44(%ebp)
	jmp	.L150
.L149:
	movl	20(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	(%eax), %eax
	movl	%eax, -48(%ebp)
	movl	$0, -44(%ebp)
.L150:
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
	jmp	.L142
.L148:
	movl	-88(%ebp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L142
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
	jmp	.L139
.L142:
	jmp	.L139
.L140:
	movl	-76(%ebp), %eax
	movl	-28(%ebp), %edx
	movb	(%edx), %dl
	movb	%dl, (%eax)
	decl	-32(%ebp)
	movl	-76(%ebp), %eax
	incl	%eax
	movl	%eax, -76(%ebp)
	incl	-28(%ebp)
.L139:
	movl	-28(%ebp), %eax
	movb	(%eax), %al
	testb	%al, %al
	je	.L151
	cmpl	$0, -32(%ebp)
	jne	.L152
.L151:
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
	jmp	.L158
.L159:
	incl	-4(%ebp)
.L158:
	movl	-8(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -8(%ebp)
	movb	(%eax), %al
	testb	%al, %al
	jne	.L159
	movl	-4(%ebp), %eax
	leave
	ret
	.size	ustrlen, .-ustrlen
	.ident	"GCC: (GNU) 4.8.2 20140120 (Red Hat 4.8.2-15)"
	.section	.note.GNU-stack,"",@progbits
