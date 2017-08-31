	.file	"stdlib.c"
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
/  94 "/home/juergen/osexperi/kernel/kernel_user/stdlib.h" 1
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
	.globl	close
	.type	close, @function
close:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$12, (%esp)
	call	make_syscall1
	leave
	ret
	.size	close, .-close
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
	.globl	chdir
	.type	chdir, @function
chdir:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$13, (%esp)
	call	make_syscall1
	leave
	ret
	.size	chdir, .-chdir
	.globl	readdir
	.type	readdir, @function
readdir:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp
	movl	12(%ebp), %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$14, (%esp)
	call	make_syscall2
	leave
	ret
	.size	readdir, .-readdir
	.globl	unlink
	.type	unlink, @function
unlink:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$3, (%esp)
	call	make_syscall1
	leave
	ret
	.size	unlink, .-unlink
	.globl	mkdir
	.type	mkdir, @function
mkdir:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp
	movl	12(%ebp), %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$4, (%esp)
	call	make_syscall2
	leave
	ret
	.size	mkdir, .-mkdir
	.globl	rmdir
	.type	rmdir, @function
rmdir:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$5, (%esp)
	call	make_syscall1
	leave
	ret
	.size	rmdir, .-rmdir
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
	jmp	.L43
.L44:
	movl	-4(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -4(%ebp)
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, 4(%esp)
	movl	$233, (%esp)
	call	outb
.L43:
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L44
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
	ja	.L48
	movzbl	-28(%ebp), %eax
	addl	$48, %eax
	jmp	.L49
.L48:
	movzbl	-28(%ebp), %eax
	addl	$87, %eax
.L49:
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
	jmp	.L57
.L62:
	movl	$0, -12(%ebp)
	movl	$0, -16(%ebp)
	movl	$0, -16(%ebp)
	jmp	.L58
.L60:
	movl	8(%ebp), %eax
	movzbl	(%eax), %edx
	movl	-16(%ebp), %ecx
	movl	12(%ebp), %eax
	addl	%ecx, %eax
	movzbl	(%eax), %eax
	cmpb	%al, %dl
	jne	.L59
	movl	-16(%ebp), %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	orl	%eax, -4(%ebp)
	movl	$1, -12(%ebp)
	addl	$1, 8(%ebp)
	addl	$1, -8(%ebp)
	jmp	.L57
.L59:
	addl	$1, -16(%ebp)
.L58:
	movl	-16(%ebp), %eax
	cmpl	16(%ebp), %eax
	jl	.L60
.L57:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L61
	cmpl	$0, -12(%ebp)
	je	.L61
	movl	-8(%ebp), %eax
	cmpl	20(%ebp), %eax
	jb	.L62
.L61:
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
	jmp	.L65
.L71:
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	-4(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)
	jmp	.L66
.L68:
	addl	$1, -8(%ebp)
	addl	$1, -12(%ebp)
.L66:
	movl	-8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L67
	movl	-12(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L67
	movl	-8(%ebp), %eax
	movzbl	(%eax), %edx
	movl	-12(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	%al, %dl
	je	.L68
.L67:
	movl	-12(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L69
	movl	-4(%ebp), %eax
	leal	1(%eax), %edx
	movl	20(%ebp), %eax
	movl	%edx, (%eax)
	movl	-8(%ebp), %eax
	jmp	.L70
.L69:
	addl	$1, -4(%ebp)
.L65:
	movl	16(%ebp), %eax
	cmpl	-4(%ebp), %eax
	ja	.L71
	movl	8(%ebp), %eax
.L70:
	leave
	ret
	.size	parse_strings_universal, .-parse_strings_universal
	.type	parse_num_universal, @function
parse_num_universal:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	$0, -4(%ebp)
	jmp	.L73
.L75:
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
.L73:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L74
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	movl	%eax, (%esp)
	call	is_digit
	testl	%eax, %eax
	jne	.L75
.L74:
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
	je	.L78
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$46, %al
	jne	.L78
	addl	$1, 8(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	parse_num_universal
	movl	%eax, 8(%ebp)
	jmp	.L79
.L78:
	movl	20(%ebp), %eax
	movl	$0, (%eax)
.L79:
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
	je	.L82
	movl	$48, %eax
	jmp	.L83
.L82:
	movl	$32, %eax
.L83:
	movb	%al, -101(%ebp)
	movl	32(%ebp), %eax
	andl	$8, %eax
	movl	%eax, -108(%ebp)
	cmpl	$0, 28(%ebp)
	jne	.L84
	cmpl	$0, -76(%ebp)
	jns	.L85
	movl	$-1, -28(%ebp)
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	negl	%eax
	adcl	$0, %edx
	negl	%edx
	movl	%eax, -24(%ebp)
	movl	%edx, -20(%ebp)
	jmp	.L88
.L85:
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	orl	%edx, %eax
	testl	%eax, %eax
	jne	.L87
	movl	$0, -28(%ebp)
	movl	$0, -24(%ebp)
	movl	$0, -20(%ebp)
	jmp	.L88
.L87:
	movl	$1, -28(%ebp)
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	movl	%eax, -24(%ebp)
	movl	%edx, -20(%ebp)
	jmp	.L89
.L84:
	movl	-80(%ebp), %eax
	movl	-76(%ebp), %edx
	movl	%eax, -24(%ebp)
	movl	%edx, -20(%ebp)
	movl	$1, -28(%ebp)
	jmp	.L89
.L88:
	jmp	.L89
.L92:
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
	jae	.L90
	movl	-112(%ebp), %edx
	movl	-68(%ebp), %ecx
	addl	%ecx, %edx
	movzbl	(%edx), %edx
	jmp	.L91
.L90:
	movl	$63, %edx
.L91:
	movb	%dl, (%eax)
.L89:
	movl	-24(%ebp), %eax
	movl	-20(%ebp), %edx
	orl	%edx, %eax
	testl	%eax, %eax
	jne	.L92
	movl	-12(%ebp), %edx
	leal	-191(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -32(%ebp)
	cmpl	$0, -32(%ebp)
	jne	.L93
	movl	-12(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -12(%ebp)
	movb	$48, (%eax)
	addl	$1, -32(%ebp)
.L93:
	movl	-12(%ebp), %eax
	movb	$0, (%eax)
	movl	$0, -36(%ebp)
	cmpl	$0, -28(%ebp)
	js	.L94
	cmpl	$0, -92(%ebp)
	jne	.L95
.L94:
	cmpl	$0, -28(%ebp)
	js	.L95
	cmpl	$0, -100(%ebp)
	je	.L96
.L95:
	movl	$1, %eax
	jmp	.L97
.L96:
	movl	$0, %eax
.L97:
	movl	%eax, -116(%ebp)
	movl	-116(%ebp), %eax
	movl	-32(%ebp), %edx
	addl	%edx, %eax
	movl	%eax, -120(%ebp)
	cmpl	$0, 40(%ebp)
	jle	.L98
	movl	40(%ebp), %edx
	movl	-120(%ebp), %eax
	cmpl	%eax, %edx
	cmovbe	%edx, %eax
	movl	%eax, -36(%ebp)
	jmp	.L99
.L98:
	movl	-120(%ebp), %eax
	movl	%eax, -36(%ebp)
.L99:
	movl	$0, -40(%ebp)
	cmpl	$0, 36(%ebp)
	jle	.L100
	movl	36(%ebp), %eax
	cmpl	-36(%ebp), %eax
	setb	%al
	movzbl	%al, %eax
	movl	%eax, -40(%ebp)
	movl	36(%ebp), %eax
	movl	%eax, -36(%ebp)
.L100:
	cmpl	$0, -40(%ebp)
	je	.L101
	movl	$0, -44(%ebp)
	movl	$0, -44(%ebp)
	jmp	.L102
.L103:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$35, (%eax)
	addl	$1, -44(%ebp)
.L102:
	movl	36(%ebp), %eax
	cmpl	-44(%ebp), %eax
	ja	.L103
	movl	-16(%ebp), %edx
	movl	8(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -84(%ebp)
	movl	48(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, (%eax)
	movl	-84(%ebp), %eax
	jmp	.L144
.L101:
	movl	-120(%ebp), %eax
	movl	-36(%ebp), %edx
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -124(%ebp)
	movl	-36(%ebp), %eax
	cmpl	-120(%ebp), %eax
	jae	.L105
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
.L106:
	jmp	.L106
.L105:
	cmpl	$0, -96(%ebp)
	je	.L107
	cmpl	$0, -28(%ebp)
	js	.L108
	cmpl	$0, -92(%ebp)
	je	.L109
	cmpl	$0, -28(%ebp)
	jns	.L110
.L109:
	cmpl	$0, -100(%ebp)
	je	.L111
	movl	$32, %eax
	jmp	.L112
.L111:
	movl	$35, %eax
.L112:
	jmp	.L113
.L110:
	movl	$43, %eax
.L113:
	jmp	.L114
.L108:
	movl	$45, %eax
.L114:
	movb	%al, -125(%ebp)
	cmpb	$35, -125(%ebp)
	je	.L115
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movzbl	-125(%ebp), %edx
	movb	%dl, (%eax)
.L115:
	movl	$0, -48(%ebp)
	movl	$0, -48(%ebp)
	jmp	.L116
.L117:
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
.L116:
	movl	-48(%ebp), %eax
	cmpl	-32(%ebp), %eax
	jb	.L117
	movl	$0, -48(%ebp)
	jmp	.L118
.L119:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$32, (%eax)
	addl	$1, -48(%ebp)
.L118:
	movl	-48(%ebp), %eax
	cmpl	-124(%ebp), %eax
	jb	.L119
	jmp	.L120
.L107:
	cmpb	$48, -101(%ebp)
	jne	.L121
	cmpl	$0, -28(%ebp)
	js	.L122
	cmpl	$0, -92(%ebp)
	je	.L123
	cmpl	$0, -28(%ebp)
	jns	.L124
.L123:
	cmpl	$0, -100(%ebp)
	je	.L125
	movl	$32, %eax
	jmp	.L126
.L125:
	movl	$35, %eax
.L126:
	jmp	.L127
.L124:
	movl	$43, %eax
.L127:
	jmp	.L128
.L122:
	movl	$45, %eax
.L128:
	movb	%al, -126(%ebp)
	cmpb	$35, -126(%ebp)
	je	.L129
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movzbl	-126(%ebp), %edx
	movb	%dl, (%eax)
.L129:
	movl	$0, -52(%ebp)
	movl	$0, -52(%ebp)
	jmp	.L130
.L131:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$48, (%eax)
	addl	$1, -52(%ebp)
.L130:
	movl	-52(%ebp), %eax
	cmpl	-124(%ebp), %eax
	jb	.L131
	jmp	.L132
.L121:
	movl	$0, -56(%ebp)
	movl	$0, -56(%ebp)
	jmp	.L133
.L134:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$32, (%eax)
	addl	$1, -56(%ebp)
.L133:
	movl	-56(%ebp), %eax
	cmpl	-124(%ebp), %eax
	jb	.L134
	cmpl	$0, -28(%ebp)
	js	.L135
	cmpl	$0, -92(%ebp)
	je	.L136
	cmpl	$0, -28(%ebp)
	jns	.L137
.L136:
	cmpl	$0, -100(%ebp)
	je	.L138
	movl	$32, %eax
	jmp	.L139
.L138:
	movl	$35, %eax
.L139:
	jmp	.L140
.L137:
	movl	$43, %eax
.L140:
	jmp	.L141
.L135:
	movl	$45, %eax
.L141:
	movb	%al, -127(%ebp)
	cmpb	$35, -127(%ebp)
	je	.L132
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movzbl	-127(%ebp), %edx
	movb	%dl, (%eax)
.L132:
	movl	$0, -60(%ebp)
	movl	$0, -60(%ebp)
	jmp	.L142
.L143:
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
.L142:
	movl	-60(%ebp), %eax
	cmpl	-32(%ebp), %eax
	jb	.L143
.L120:
	movl	-16(%ebp), %edx
	movl	8(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -84(%ebp)
	movl	48(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, (%eax)
	movl	-84(%ebp), %eax
.L144:
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
	jmp	.L146
.L159:
	movl	-28(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$37, %al
	jne	.L147
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
	je	.L148
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
	jmp	.L149
.L148:
	movl	-88(%ebp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L150
	movl	20(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	(%eax), %eax
	movl	%eax, -36(%ebp)
	jmp	.L151
.L153:
	movl	-76(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -76(%ebp)
	movl	-36(%ebp), %edx
	leal	1(%edx), %ecx
	movl	%ecx, -36(%ebp)
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
	subl	$1, -32(%ebp)
.L151:
	movl	-36(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L152
	cmpl	$0, -32(%ebp)
	jne	.L153
.L152:
	jmp	.L149
.L150:
	movl	-88(%ebp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L154
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
	jmp	.L149
.L154:
	movl	-88(%ebp), %eax
	andl	$32, %eax
	testl	%eax, %eax
	je	.L155
	movl	$0, -48(%ebp)
	movl	$0, -44(%ebp)
	movl	-84(%ebp), %eax
	cmpl	$4, %eax
	jne	.L156
	movl	20(%ebp), %eax
	leal	8(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	4(%eax), %edx
	movl	(%eax), %eax
	movl	%eax, -48(%ebp)
	movl	%edx, -44(%ebp)
	jmp	.L157
.L156:
	movl	20(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 20(%ebp)
	movl	(%eax), %eax
	movl	%eax, -48(%ebp)
	movl	$0, -44(%ebp)
.L157:
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
	jmp	.L149
.L155:
	movl	-88(%ebp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L149
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
	jmp	.L146
.L149:
	jmp	.L146
.L147:
	movl	-76(%ebp), %eax
	movl	-28(%ebp), %edx
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
	subl	$1, -32(%ebp)
	movl	-76(%ebp), %eax
	addl	$1, %eax
	movl	%eax, -76(%ebp)
	addl	$1, -28(%ebp)
.L146:
	movl	-28(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L158
	cmpl	$0, -32(%ebp)
	jne	.L159
.L158:
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
	.globl	strcmp
	.type	strcmp, @function
strcmp:
	pushl	%ebp
	movl	%esp, %ebp
	jmp	.L167
.L169:
	addl	$1, 8(%ebp)
	addl	$1, 12(%ebp)
.L167:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L168
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L168
	movl	8(%ebp), %eax
	movzbl	(%eax), %edx
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	%al, %dl
	je	.L169
.L168:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L170
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L170
	movl	$0, %eax
	jmp	.L171
.L170:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L172
	movl	$1, %eax
	jmp	.L171
.L172:
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L173
	movl	$-1, %eax
	jmp	.L171
.L173:
	movl	8(%ebp), %eax
	movzbl	(%eax), %edx
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	%al, %dl
	jge	.L174
	movl	$1, %eax
	jmp	.L175
.L174:
	movl	$-1, %eax
.L175:
.L171:
	popl	%ebp
	ret
	.size	strcmp, .-strcmp
	.globl	strcpy
	.type	strcpy, @function
strcpy:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	nop
.L177:
	movl	-4(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -4(%ebp)
	movl	12(%ebp), %edx
	leal	1(%edx), %ecx
	movl	%ecx, 12(%ebp)
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L177
	movl	8(%ebp), %eax
	leave
	ret
	.size	strcpy, .-strcpy
	.globl	strncpy
	.type	strncpy, @function
strncpy:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	$0, -4(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	jmp	.L180
.L183:
	movl	12(%ebp), %eax
	movzbl	(%eax), %edx
	movl	-8(%ebp), %eax
	movb	%dl, (%eax)
	movl	-8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L181
	jmp	.L182
.L181:
	addl	$1, -8(%ebp)
	addl	$1, 12(%ebp)
	addl	$1, -4(%ebp)
.L180:
	movl	-4(%ebp), %eax
	cmpl	16(%ebp), %eax
	jb	.L183
.L182:
	movl	8(%ebp), %eax
	leave
	ret
	.size	strncpy, .-strncpy
	.globl	strcat
	.type	strcat, @function
strcat:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	jmp	.L186
.L187:
	addl	$1, -4(%ebp)
.L186:
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L187
	jmp	.L188
.L189:
	movl	-4(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -4(%ebp)
	movl	12(%ebp), %edx
	leal	1(%edx), %ecx
	movl	%ecx, 12(%ebp)
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
.L188:
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L189
	movl	12(%ebp), %eax
	movzbl	(%eax), %edx
	movl	-4(%ebp), %eax
	movb	%dl, (%eax)
	movl	8(%ebp), %eax
	leave
	ret
	.size	strcat, .-strcat
	.globl	strlen
	.type	strlen, @function
strlen:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	$0, -4(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	jmp	.L192
.L193:
	addl	$1, -4(%ebp)
.L192:
	movl	-8(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -8(%ebp)
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L193
	movl	-4(%ebp), %eax
	leave
	ret
	.size	strlen, .-strlen
	.globl	atoi
	.type	atoi, @function
atoi:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	$1, -8(%ebp)
	movl	$0, -12(%ebp)
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$45, %al
	jne	.L196
	movl	$-1, -8(%ebp)
	addl	$1, -4(%ebp)
	jmp	.L197
.L196:
	jmp	.L197
.L199:
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	subl	$48, %eax
	addl	%edx, %eax
	movl	%eax, -12(%ebp)
	addl	$1, -4(%ebp)
.L197:
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$47, %al
	jle	.L198
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$57, %al
	jle	.L199
.L198:
	movl	-8(%ebp), %eax
	imull	-12(%ebp), %eax
	leave
	ret
	.size	atoi, .-atoi
	.globl	strhash
	.type	strhash, @function
strhash:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$20, %esp
	movl	$5381, -16(%ebp)
	movl	$0, -12(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -20(%ebp)
	jmp	.L202
.L203:
	movl	-16(%ebp), %eax
	movl	-12(%ebp), %edx
	shldl	$5, %eax, %edx
	sall	$5, %eax
	movl	%eax, %ecx
	movl	%edx, %ebx
	movl	-16(%ebp), %eax
	movl	-12(%ebp), %edx
	addl	%eax, %ecx
	adcl	%edx, %ebx
	movl	-24(%ebp), %eax
	cltd
	addl	%ecx, %eax
	adcl	%ebx, %edx
	movl	%eax, -16(%ebp)
	movl	%edx, -12(%ebp)
.L202:
	movl	-20(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -20(%ebp)
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	movl	%eax, -24(%ebp)
	cmpl	$0, -24(%ebp)
	jne	.L203
	movl	-16(%ebp), %eax
	movl	-12(%ebp), %edx
	addl	$20, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	strhash, .-strhash
	.globl	memcpy
	.type	memcpy, @function
memcpy:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	$0, -12(%ebp)
	movl	-8(%ebp), %eax
	cmpl	-4(%ebp), %eax
	jae	.L206
	movl	16(%ebp), %eax
	movl	-8(%ebp), %edx
	addl	%edx, %eax
	cmpl	-4(%ebp), %eax
	jbe	.L206
	movl	16(%ebp), %eax
	subl	$1, %eax
	addl	%eax, -4(%ebp)
	movl	16(%ebp), %eax
	subl	$1, %eax
	addl	%eax, -8(%ebp)
	jmp	.L207
.L208:
	movl	-4(%ebp), %eax
	leal	-1(%eax), %edx
	movl	%edx, -4(%ebp)
	movl	-8(%ebp), %edx
	leal	-1(%edx), %ecx
	movl	%ecx, -8(%ebp)
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
	addl	$1, -12(%ebp)
.L207:
	movl	-12(%ebp), %eax
	cmpl	16(%ebp), %eax
	jb	.L208
	jmp	.L209
.L206:
	jmp	.L210
.L211:
	movl	-4(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -4(%ebp)
	movl	-8(%ebp), %edx
	leal	1(%edx), %ecx
	movl	%ecx, -8(%ebp)
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
	addl	$1, -12(%ebp)
.L210:
	movl	-12(%ebp), %eax
	cmpl	16(%ebp), %eax
	jb	.L211
.L209:
	movl	8(%ebp), %eax
	leave
	ret
	.size	memcpy, .-memcpy
	.globl	memset
	.type	memset, @function
memset:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	12(%ebp), %eax
	movb	%al, -20(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	$0, -8(%ebp)
	jmp	.L214
.L215:
	movl	-4(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -4(%ebp)
	movzbl	-20(%ebp), %edx
	movb	%dl, (%eax)
	addl	$1, -8(%ebp)
.L214:
	movl	-8(%ebp), %eax
	cmpl	16(%ebp), %eax
	jb	.L215
	movl	8(%ebp), %eax
	leave
	ret
	.size	memset, .-memset
	.globl	memcmp
	.type	memcmp, @function
memcmp:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	$0, -4(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -12(%ebp)
	jmp	.L218
.L221:
	movl	-8(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -8(%ebp)
	movzbl	(%eax), %ecx
	movl	-12(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -12(%ebp)
	movzbl	(%eax), %eax
	cmpb	%al, %cl
	je	.L219
	jmp	.L220
.L219:
	addl	$1, -4(%ebp)
.L218:
	movl	-4(%ebp), %eax
	cmpl	16(%ebp), %eax
	jb	.L221
.L220:
	movl	-4(%ebp), %eax
	cmpl	16(%ebp), %eax
	setb	%al
	movzbl	%al, %eax
	leave
	ret
	.size	memcmp, .-memcmp
	.data
	.align 4
	.type	rand_val, @object
	.size	rand_val, 4
rand_val:
	.long	27182811
	.text
	.globl	rand
	.type	rand, @function
rand:
	pushl	%ebp
	movl	%esp, %ebp
	movl	rand_val, %eax
	imull	$314159261, %eax, %eax
	addl	$1, %eax
	andl	$536870911, %eax
	movl	%eax, rand_val
	movl	rand_val, %eax
	shrl	$5, %eax
	popl	%ebp
	ret
	.size	rand, .-rand
	.globl	in_delim
	.type	in_delim, @function
in_delim:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	8(%ebp), %eax
	movb	%al, -20(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -4(%ebp)
	jmp	.L226
.L229:
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	-20(%ebp), %al
	jne	.L227
	jmp	.L228
.L227:
	addl	$1, -4(%ebp)
.L226:
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L229
.L228:
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	leave
	ret
	.size	in_delim, .-in_delim
	.globl	parse_buf
	.type	parse_buf, @function
parse_buf:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	$0, -8(%ebp)
	movl	20(%ebp), %eax
	movl	-8(%ebp), %edx
	movl	%edx, (%eax)
	jmp	.L232
.L240:
	cmpl	$0, -8(%ebp)
	je	.L233
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L233
	movl	-4(%ebp), %eax
	movb	$0, (%eax)
	addl	$1, -4(%ebp)
	jmp	.L234
.L233:
	jmp	.L234
.L235:
	addl	$1, -4(%ebp)
.L234:
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	movl	16(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	in_delim
	testl	%eax, %eax
	jne	.L235
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L236
	movl	-8(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	24(%ebp), %eax
	addl	%eax, %edx
	movl	-4(%ebp), %eax
	movl	%eax, (%edx)
	addl	$1, -8(%ebp)
	jmp	.L237
.L238:
	addl	$1, -4(%ebp)
.L237:
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L232
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	movl	16(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	in_delim
	testl	%eax, %eax
	je	.L238
	jmp	.L232
.L236:
	jmp	.L239
.L232:
	movl	-4(%ebp), %edx
	movl	8(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	cmpl	12(%ebp), %eax
	jl	.L240
.L239:
	movl	20(%ebp), %eax
	movl	-8(%ebp), %edx
	movl	%edx, (%eax)
	leave
	ret
	.size	parse_buf, .-parse_buf
	.ident	"GCC: (GNU) 4.8.2"
