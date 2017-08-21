	.file	"stdlib.c"
/APP
	.code16gcc	

/NO_APP
	.comm	global_in_de_hash_headers,2164,32
	.comm	global_in_de_lru_list,4,4
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
	.type	outb, @function
outb:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	movw	%dx, -4(%ebp)
	movb	%al, -8(%ebp)
	movzwl	-4(%ebp), %edx
	movzbl	-8(%ebp), %eax
/APP
/  89 "/home/juergen/osexperi/kernel/kernel_user/stdlib.h" 1
	outb %al, %dx
/  0 "" 2
/NO_APP
	leave
	ret
	.size	outb, .-outb
	.type	make_syscall1, @function
make_syscall1:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$16, %esp
/APP
/  18 "kernel_user/stdlib.c" 1
	movl 8(%ebp), %eax 
	movl 12(%ebp), %ebx 
	int $0x80 
	movl %eax, %esi
/  0 "" 2
/NO_APP
	movl	%esi, -12(%ebp)
	movl	-12(%ebp), %eax
	addl	$16, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	make_syscall1, .-make_syscall1
	.type	make_syscall2, @function
make_syscall2:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$16, %esp
/APP
/  32 "kernel_user/stdlib.c" 1
	movl 8(%ebp), %eax 
	movl 12(%ebp), %ebx 
	movl 16(%ebp), %ecx 
	int $0x80 
	movl %eax, %edx
/  0 "" 2
/NO_APP
	movl	%edx, -8(%ebp)
	movl	-8(%ebp), %eax
	addl	$16, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	make_syscall2, .-make_syscall2
	.type	make_syscall3, @function
make_syscall3:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$16, %esp
/APP
/  48 "kernel_user/stdlib.c" 1
	movl 8(%ebp), %eax 
	movl 12(%ebp), %ebx 
	movl 16(%ebp), %ecx 
	movl 20(%ebp), %edx 
	int $0x80 
	movl %eax, %esi
/  0 "" 2
/NO_APP
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
/APP
/  65 "kernel_user/stdlib.c" 1
	pushal 
	pushfl 
	
/  0 "" 2
/NO_APP
	movl	$-1073742064, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L13
	movl	$-1073742064, %eax
	movl	(%eax), %eax
	movl	8(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
.L13:
/APP
/  73 "kernel_user/stdlib.c" 1
	popfl 
	popal 
	
/  0 "" 2
/NO_APP
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
	movl	$10, (%esp)
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
	movl	$11, (%esp)
	call	make_syscall1
	leave
	ret
	.size	fork, .-fork
	.globl	open
	.type	open, @function
open:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	$0, -8(%ebp)
	leal	16(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	12(%ebp), %eax
	andl	$64, %eax
	testl	%eax, %eax
	je	.L19
	movl	-12(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, -12(%ebp)
	movl	(%eax), %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %ecx
	movl	12(%ebp), %edx
	movl	8(%ebp), %eax
	movl	%ecx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$1, (%esp)
	call	make_syscall3
	movl	%eax, -4(%ebp)
	jmp	.L20
.L19:
	movl	12(%ebp), %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$0, (%esp)
	call	make_syscall2
	movl	%eax, -4(%ebp)
.L20:
	movl	-4(%ebp), %eax
	leave
	ret
	.size	open, .-open
	.globl	read
	.type	read, @function
read:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	12(%ebp), %edx
	movl	8(%ebp), %eax
	movl	16(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$8, (%esp)
	call	make_syscall3
	leave
	ret
	.size	read, .-read
	.globl	write
	.type	write, @function
write:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	12(%ebp), %edx
	movl	8(%ebp), %eax
	movl	16(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$9, (%esp)
	call	make_syscall3
	leave
	ret
	.size	write, .-write
	.globl	getc
	.type	getc, @function
getc:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$32, %esp
	movl	$0, -8(%ebp)
	leal	-8(%ebp), %eax
	movl	$4, 12(%esp)
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$8, (%esp)
	call	make_syscall3
	movl	%eax, -4(%ebp)
	movl	-8(%ebp), %eax
	leave
	ret
	.size	getc, .-getc
	.type	kprint_str, @function
kprint_str:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	strlen
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %edx
	movl	12(%ebp), %eax
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$9, (%esp)
	call	make_syscall3
	leave
	ret
	.size	kprint_str, .-kprint_str
	.type	outb_kprint_str, @function
outb_kprint_str:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, -4(%ebp)
	jmp	.L31
.L32:
	movl	-4(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -4(%ebp)
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, 4(%esp)
	movl	$233, (%esp)
	call	outb
.L31:
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L32
	movl	$0, %eax
	leave
	ret
	.size	outb_kprint_str, .-outb_kprint_str
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
	movzbl	-28(%ebp), %edx
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
	ja	.L36
	movzbl	-28(%ebp), %eax
	addl	$48, %eax
	jmp	.L37
.L36:
	movzbl	-28(%ebp), %eax
	addl	$87, %eax
.L37:
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
	movzbl	-12(%ebp), %eax
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
	jmp	.L45
.L50:
	movl	$0, -12(%ebp)
	movl	$0, -16(%ebp)
	movl	$0, -16(%ebp)
	jmp	.L46
.L48:
	movl	8(%ebp), %eax
	movzbl	(%eax), %edx
	movl	-16(%ebp), %ecx
	movl	12(%ebp), %eax
	addl	%ecx, %eax
	movzbl	(%eax), %eax
	cmpb	%al, %dl
	jne	.L47
	movl	-16(%ebp), %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	orl	%eax, -4(%ebp)
	movl	$1, -12(%ebp)
	addl	$1, 8(%ebp)
	addl	$1, -8(%ebp)
	jmp	.L45
.L47:
	addl	$1, -16(%ebp)
.L46:
	movl	-16(%ebp), %eax
	cmpl	16(%ebp), %eax
	jl	.L48
.L45:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L49
	cmpl	$0, -12(%ebp)
	je	.L49
	movl	-8(%ebp), %eax
	cmpl	20(%ebp), %eax
	jb	.L50
.L49:
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
	jmp	.L53
.L59:
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	-4(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)
	jmp	.L54
.L56:
	addl	$1, -8(%ebp)
	addl	$1, -12(%ebp)
.L54:
	movl	-8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L55
	movl	-12(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L55
	movl	-8(%ebp), %eax
	movzbl	(%eax), %edx
	movl	-12(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	%al, %dl
	je	.L56
.L55:
	movl	-12(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L57
	movl	-4(%ebp), %eax
	leal	1(%eax), %edx
	movl	20(%ebp), %eax
	movl	%edx, (%eax)
	movl	-8(%ebp), %eax
	jmp	.L58
.L57:
	addl	$1, -4(%ebp)
.L53:
	movl	16(%ebp), %eax
	cmpl	-4(%ebp), %eax
	ja	.L59
	movl	8(%ebp), %eax
.L58:
	leave
	ret
	.size	parse_strings_universal, .-parse_strings_universal
	.type	parse_num_universal, @function
parse_num_universal:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	$0, -4(%ebp)
	jmp	.L61
.L63:
	movl	-4(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	addl	%edx, %eax
	subl	$48, %eax
	movl	%eax, -4(%ebp)
	addl	$1, 8(%ebp)
.L61:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L62
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	movl	%eax, (%esp)
	call	is_digit
	testl	%eax, %eax
	jne	.L63
.L62:
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
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L66
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$46, %al
	jne	.L66
	addl	$1, 8(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	parse_num_universal
	movl	%eax, 8(%ebp)
	jmp	.L67
.L66:
	movl	20(%ebp), %eax
	movl	$0, (%eax)
.L67:
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
	.section	.rodata
.LC9:
	.string	"0123456789abcdef"
	.globl	__umoddi3
	.globl	__udivdi3
.LC10:
	.string	"Assertion failed.\n"
.LC11:
	.string	" * "
	.text
	.type	int_to_str, @function
int_to_str:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$228, %esp
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
	je	.L70
	movl	$48, %eax
	jmp	.L71
.L70:
	movl	$32, %eax
.L71:
	movb	%al, -101(%ebp)
	movl	32(%ebp), %eax
	andl	$8, %eax
	movl	%eax, -108(%ebp)
	cmpl	$0, 28(%ebp)
	jne	.L72
	cmpl	$0, -76(%ebp)
	jns	.L73
	movl	$-1, -28(%ebp)
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	negl	%eax
	adcl	$0, %edx
	negl	%edx
	movl	%eax, -24(%ebp)
	movl	%edx, -20(%ebp)
	jmp	.L76
.L73:
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	orl	%edx, %eax
	testl	%eax, %eax
	jne	.L75
	movl	$0, -28(%ebp)
	movl	$0, -24(%ebp)
	movl	$0, -20(%ebp)
	jmp	.L76
.L75:
	movl	$1, -28(%ebp)
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	movl	%eax, -24(%ebp)
	movl	%edx, -20(%ebp)
	jmp	.L77
.L72:
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	movl	%eax, -24(%ebp)
	movl	%edx, -20(%ebp)
	movl	$1, -28(%ebp)
	jmp	.L77
.L76:
	jmp	.L77
.L80:
	movl	24(%ebp), %ecx
	movl	$0, %ebx
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	%ecx, 8(%esp)
	movl	%ebx, 12(%esp)
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
	jae	.L78
	movl	-112(%ebp), %edx
	movl	-68(%ebp), %ecx
	addl	%ecx, %edx
	movzbl	(%edx), %edx
	jmp	.L79
.L78:
	movl	$63, %edx
.L79:
	movb	%dl, (%eax)
.L77:
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	orl	%edx, %eax
	testl	%eax, %eax
	jne	.L80
	movl	-12(%ebp), %edx
	leal	-191(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -32(%ebp)
	cmpl	$0, -32(%ebp)
	jne	.L81
	movl	-12(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -12(%ebp)
	movb	$48, (%eax)
	addl	$1, -32(%ebp)
.L81:
	movl	-12(%ebp), %eax
	movb	$0, (%eax)
	movl	$0, -36(%ebp)
	cmpl	$0, -28(%ebp)
	js	.L82
	cmpl	$0, -92(%ebp)
	jne	.L83
.L82:
	cmpl	$0, -28(%ebp)
	js	.L83
	cmpl	$0, -100(%ebp)
	je	.L84
.L83:
	movl	$1, %eax
	jmp	.L85
.L84:
	movl	$0, %eax
.L85:
	movl	%eax, -116(%ebp)
	movl	-116(%ebp), %eax
	movl	-32(%ebp), %edx
	addl	%edx, %eax
	movl	%eax, -120(%ebp)
	cmpl	$0, 40(%ebp)
	jle	.L86
	movl	40(%ebp), %edx
	movl	-120(%ebp), %eax
	cmpl	%eax, %edx
	cmovbe	%edx, %eax
	movl	%eax, -36(%ebp)
	jmp	.L87
.L86:
	movl	-120(%ebp), %eax
	movl	%eax, -36(%ebp)
.L87:
	movl	$0, -40(%ebp)
	cmpl	$0, 36(%ebp)
	jle	.L88
	movl	36(%ebp), %eax
	cmpl	-36(%ebp), %eax
	setb	%al
	movzbl	%al, %eax
	movl	%eax, -40(%ebp)
	movl	36(%ebp), %eax
	movl	%eax, -36(%ebp)
.L88:
	cmpl	$0, -40(%ebp)
	je	.L89
	movl	$0, -44(%ebp)
	movl	$0, -44(%ebp)
	jmp	.L90
.L91:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$35, (%eax)
	addl	$1, -44(%ebp)
.L90:
	movl	36(%ebp), %eax
	cmpl	-44(%ebp), %eax
	ja	.L91
	movl	-16(%ebp), %edx
	movl	8(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -84(%ebp)
	movl	48(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, (%eax)
	movl	-84(%ebp), %eax
	jmp	.L132
.L89:
	movl	-120(%ebp), %eax
	movl	-36(%ebp), %edx
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -124(%ebp)
	movl	-36(%ebp), %eax
	cmpl	-120(%ebp), %eax
	jae	.L93
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
.L94:
	jmp	.L94
.L93:
	cmpl	$0, -96(%ebp)
	je	.L95
	cmpl	$0, -28(%ebp)
	js	.L96
	cmpl	$0, -92(%ebp)
	je	.L97
	cmpl	$0, -28(%ebp)
	jns	.L98
.L97:
	cmpl	$0, -100(%ebp)
	je	.L99
	movl	$32, %eax
	jmp	.L100
.L99:
	movl	$35, %eax
.L100:
	jmp	.L101
.L98:
	movl	$43, %eax
.L101:
	jmp	.L102
.L96:
	movl	$45, %eax
.L102:
	movb	%al, -125(%ebp)
	cmpb	$35, -125(%ebp)
	je	.L103
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movzbl	-125(%ebp), %edx
	movb	%dl, (%eax)
.L103:
	movl	$0, -48(%ebp)
	movl	$0, -48(%ebp)
	jmp	.L104
.L105:
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
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
	addl	$1, -48(%ebp)
.L104:
	movl	-48(%ebp), %eax
	cmpl	-32(%ebp), %eax
	jb	.L105
	movl	$0, -48(%ebp)
	jmp	.L106
.L107:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$32, (%eax)
	addl	$1, -48(%ebp)
.L106:
	movl	-48(%ebp), %eax
	cmpl	-124(%ebp), %eax
	jb	.L107
	jmp	.L108
.L95:
	cmpb	$48, -101(%ebp)
	jne	.L109
	cmpl	$0, -28(%ebp)
	js	.L110
	cmpl	$0, -92(%ebp)
	je	.L111
	cmpl	$0, -28(%ebp)
	jns	.L112
.L111:
	cmpl	$0, -100(%ebp)
	je	.L113
	movl	$32, %eax
	jmp	.L114
.L113:
	movl	$35, %eax
.L114:
	jmp	.L115
.L112:
	movl	$43, %eax
.L115:
	jmp	.L116
.L110:
	movl	$45, %eax
.L116:
	movb	%al, -126(%ebp)
	cmpb	$35, -126(%ebp)
	je	.L117
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movzbl	-126(%ebp), %edx
	movb	%dl, (%eax)
.L117:
	movl	$0, -52(%ebp)
	movl	$0, -52(%ebp)
	jmp	.L118
.L119:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$48, (%eax)
	addl	$1, -52(%ebp)
.L118:
	movl	-52(%ebp), %eax
	cmpl	-124(%ebp), %eax
	jb	.L119
	jmp	.L120
.L109:
	movl	$0, -56(%ebp)
	movl	$0, -56(%ebp)
	jmp	.L121
.L122:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$32, (%eax)
	addl	$1, -56(%ebp)
.L121:
	movl	-56(%ebp), %eax
	cmpl	-124(%ebp), %eax
	jb	.L122
	cmpl	$0, -28(%ebp)
	js	.L123
	cmpl	$0, -92(%ebp)
	je	.L124
	cmpl	$0, -28(%ebp)
	jns	.L125
.L124:
	cmpl	$0, -100(%ebp)
	je	.L126
	movl	$32, %eax
	jmp	.L127
.L126:
	movl	$35, %eax
.L127:
	jmp	.L128
.L125:
	movl	$43, %eax
.L128:
	jmp	.L129
.L123:
	movl	$45, %eax
.L129:
	movb	%al, -127(%ebp)
	cmpb	$35, -127(%ebp)
	je	.L120
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movzbl	-127(%ebp), %edx
	movb	%dl, (%eax)
.L120:
	movl	$0, -60(%ebp)
	movl	$0, -60(%ebp)
	jmp	.L130
.L131:
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
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
	addl	$1, -60(%ebp)
.L130:
	movl	-60(%ebp), %eax
	cmpl	-32(%ebp), %eax
	jb	.L131
.L108:
	movl	-16(%ebp), %edx
	movl	8(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -84(%ebp)
	movl	48(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, (%eax)
	movl	-84(%ebp), %eax
.L132:
	addl	$228, %esp
	popl	%ebx
	popl	%ebp
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
	jmp	.L134
.L147:
	movl	-28(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$37, %al
	jne	.L135
	addl	$1, -28(%ebp)
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
	je	.L136
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
	jmp	.L137
.L136:
	movl	-88(%ebp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L138
	movl	20(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	(%eax), %eax
	movl	%eax, -36(%ebp)
	jmp	.L139
.L141:
	movl	-76(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -76(%ebp)
	movl	-36(%ebp), %edx
	leal	1(%edx), %ecx
	movl	%ecx, -36(%ebp)
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
	subl	$1, -32(%ebp)
.L139:
	movl	-36(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L140
	cmpl	$0, -32(%ebp)
	jne	.L141
.L140:
	jmp	.L137
.L138:
	movl	-88(%ebp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L142
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
	jmp	.L137
.L142:
	movl	-88(%ebp), %eax
	andl	$32, %eax
	testl	%eax, %eax
	je	.L143
	movl	$0, -48(%ebp)
	movl	$0, -44(%ebp)
	movl	-84(%ebp), %eax
	cmpl	$4, %eax
	jne	.L144
	movl	20(%ebp), %eax
	leal	8(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, -48(%ebp)
	movl	%edx, -44(%ebp)
	jmp	.L145
.L144:
	movl	20(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	(%eax), %eax
	movl	%eax, -48(%ebp)
	movl	$0, -44(%ebp)
.L145:
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
	jmp	.L137
.L143:
	movl	-88(%ebp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L137
	movl	20(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	(%eax), %eax
	movl	%eax, -72(%ebp)
	movl	-76(%ebp), %eax
	movl	-72(%ebp), %edx
	movb	%dl, (%eax)
	movl	-76(%ebp), %eax
	addl	$1, %eax
	movl	%eax, -76(%ebp)
	subl	$1, -32(%ebp)
	jmp	.L134
.L137:
	jmp	.L134
.L135:
	movl	-76(%ebp), %eax
	movl	-28(%ebp), %edx
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
	subl	$1, -32(%ebp)
	movl	-76(%ebp), %eax
	addl	$1, %eax
	movl	%eax, -76(%ebp)
	addl	$1, -28(%ebp)
.L134:
	movl	-28(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L146
	cmpl	$0, -32(%ebp)
	jne	.L147
.L146:
	movl	-76(%ebp), %eax
	movb	$0, (%eax)
	addl	$156, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	vprintf, .-vprintf
	.globl	printf
	.type	printf, @function
printf:
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
	.size	printf, .-printf
	.globl	fprintf
	.type	fprintf, @function
fprintf:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$1064, %esp
	movl	$0, -12(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -16(%ebp)
	leal	16(%ebp), %eax
	movl	%eax, -1044(%ebp)
	movl	-1044(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$1024, 4(%esp)
	leal	-1040(%ebp), %eax
	movl	%eax, (%esp)
	call	vprintf
	movl	8(%ebp), %eax
	leal	-1040(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	kprint_str
	leave
	ret
	.size	fprintf, .-fprintf
	.globl	outb_printf
	.type	outb_printf, @function
outb_printf:
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
	call	outb_kprint_str
	leave
	ret
	.size	outb_printf, .-outb_printf
	.globl	strlen
	.type	strlen, @function
strlen:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	$0, -4(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	jmp	.L155
.L156:
	addl	$1, -4(%ebp)
.L155:
	movl	-8(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -8(%ebp)
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L156
	movl	-4(%ebp), %eax
	leave
	ret
	.size	strlen, .-strlen
	.ident	"GCC: (GNU) 4.8.2"
