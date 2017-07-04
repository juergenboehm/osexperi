	.file	"startup.c"
#APP
	.code16gcc	

#NO_APP
	.text
.globl enable_a20
	.type	enable_a20, @function
enable_a20:
	pushl	%ebp
	movl	%esp, %ebp
#APP
# 53 "kernel16/startup.c" 1
	movw $0x2401, %ax
	int $0x15
	movb $0, %al
	rclb %al
	movw %ax, %dx
	
# 0 "" 2
#NO_APP
	movzwl	%dx, %eax
	leave
	ret
	.size	enable_a20, .-enable_a20
.globl keyb_wait
	.type	keyb_wait, @function
keyb_wait:
	pushl	%ebp
	movl	%esp, %ebp
#APP
# 67 "kernel16/startup.c" 1
	1: 
	testb $0xff, 12(%ebp) 
	jz 3f 
	2: 
	inb	$0x64, %al 
	testb	8(%ebp), %al 
	jz 2b 
	jmp 4f 
	3: 
	inb	$0x64, %al 
	testb	8(%ebp), %al 
	jnz 3b 
	4: 
	nop 
	
# 0 "" 2
#NO_APP
	leave
	ret
	.size	keyb_wait, .-keyb_wait
.globl keyb_send_cmd
	.type	keyb_send_cmd, @function
keyb_send_cmd:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movb	8(%ebp), %bl
	pushl	$0
	pushl	$2
	call	keyb_wait
	movb	%bl, %al
#APP
# 88 "kernel16/startup.c" 1
	outb %al, $0x64
# 0 "" 2
#NO_APP
	popl	%eax
	popl	%edx
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	keyb_send_cmd, .-keyb_send_cmd
.globl keyb_send_data
	.type	keyb_send_data, @function
keyb_send_data:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movb	8(%ebp), %bl
	pushl	$0
	pushl	$2
	call	keyb_wait
	movb	%bl, %al
#APP
# 97 "kernel16/startup.c" 1
	outb %al, $0x60
# 0 "" 2
#NO_APP
	popl	%ecx
	popl	%ebx
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	keyb_send_data, .-keyb_send_data
.globl keyb_get_data
	.type	keyb_get_data, @function
keyb_get_data:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	$1
	pushl	$1
	call	keyb_wait
#APP
# 107 "kernel16/startup.c" 1
	inb $0x60, %al
# 0 "" 2
#NO_APP
	leave
	ret
	.size	keyb_get_data, .-keyb_get_data
.globl enable_a20_keyb
	.type	enable_a20_keyb, @function
enable_a20_keyb:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp
#APP
# 116 "kernel16/startup.c" 1
	cli
# 0 "" 2
#NO_APP
	pushl	$173
	call	keyb_send_cmd
	pushl	$208
	call	keyb_send_cmd
	call	keyb_get_data
	pushl	$209
	movb	%al, -4(%ebp)
	call	keyb_send_cmd
	movb	-4(%ebp), %al
	orl	$2, %eax
	movzbl	%al, %eax
	pushl	%eax
	call	keyb_send_data
	pushl	$174
	call	keyb_send_cmd
#APP
# 128 "kernel16/startup.c" 1
	sti
# 0 "" 2
#NO_APP
	xorl	%eax, %eax
	leave
	ret
	.size	enable_a20_keyb, .-enable_a20_keyb
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"kernel16/startup.c"
.LC1:
	.string	":"
.LC2:
	.string	"sizeof(GDT_ENTRY) = "
.LC3:
	.string	"addr_gdtable_provis = "
	.text
.globl init_gdtptr
	.type	init_gdtptr, @function
init_gdtptr:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	pushl	$.LC0
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC2, (%esp)
	call	print_str
	movl	$8, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC3, (%esp)
	call	print_str
	movl	$gdt_table_provis+131072, (%esp)
	call	print_U32
	call	print_newline
	movw	$63, gdt_ptr_provis
	movl	$gdt_table_provis+131072, gdt_ptr_provis+2
#APP
# 44 "kernel16/startup.c" 1
	lgdt gdt_ptr_provis
# 0 "" 2
#NO_APP
	addl	$16, %esp
	leave
	ret
	.size	init_gdtptr, .-init_gdtptr
	.section	.rodata.str1.1
.LC4:
	.string	"\r\nKernel primary loaded.\r\n"
.LC5:
	.string	"a_20 ok = "
.LC6:
	.string	"err mem map = "
.LC7:
	.string	"len mem map = "
	.text
.globl kmain
	.type	kmain, @function
kmain:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$32, %esp
	pushl	$.LC4
	call	print_str
	xorl	%eax, %eax
	addl	$16, %esp
.L16:
	movw	$0, gdt_table_provis+2(,%eax,8)
	movb	$0, gdt_table_provis+4(,%eax,8)
	movb	$0, gdt_table_provis+7(,%eax,8)
	movw	$0, gdt_table_provis(,%eax,8)
	movb	$0, gdt_table_provis+6(,%eax,8)
	andb	$1, gdt_table_provis+5(,%eax,8)
	incl	%eax
	cmpl	$4, %eax
	jne	.L16
	movb	gdt_table_provis+21, %al
	andl	$1, %eax
	orl	$-102, %eax
	movb	%al, gdt_table_provis+21
	movb	gdt_table_provis+29, %al
	andl	$1, %eax
	orl	$-110, %eax
	movb	%al, gdt_table_provis+29
	movw	$0, gdt_table_provis+18
	movb	$3, gdt_table_provis+20
	movb	$0, gdt_table_provis+23
	movw	$0, gdt_table_provis+26
	movb	$3, gdt_table_provis+28
	movb	$0, gdt_table_provis+31
	movw	$-49, gdt_table_provis+16
	movb	$-49, gdt_table_provis+22
	movw	$-49, gdt_table_provis+24
	movb	$-49, gdt_table_provis+30
	movw	$0, gdt_table_provis+34
	movb	$0, gdt_table_provis+36
	movb	$0, gdt_table_provis+39
	movw	$-1, gdt_table_provis+32
	movb	$-49, gdt_table_provis+38
	movb	gdt_table_provis+37, %al
	andl	$1, %eax
	orl	$-102, %eax
	movb	%al, gdt_table_provis+37
	movw	$0, gdt_table_provis+42
	movb	$0, gdt_table_provis+44
	movb	$0, gdt_table_provis+47
	movw	$-1, gdt_table_provis+40
	movb	$-49, gdt_table_provis+46
	movb	gdt_table_provis+45, %al
	andl	$1, %eax
	orl	$-110, %eax
	movb	%al, gdt_table_provis+45
	movw	$0, gdt_table_provis+50
	movb	$0, gdt_table_provis+52
	movb	$0, gdt_table_provis+55
	movw	$-1, gdt_table_provis+48
	movb	$-49, gdt_table_provis+54
	movb	gdt_table_provis+53, %al
	andl	$1, %eax
	orl	$-6, %eax
	movb	%al, gdt_table_provis+53
	movw	$0, gdt_table_provis+58
	movb	$0, gdt_table_provis+60
	movb	$0, gdt_table_provis+63
	movw	$-1, gdt_table_provis+56
	movb	$-49, gdt_table_provis+62
	movb	gdt_table_provis+61, %al
	andl	$1, %eax
	orl	$-14, %eax
	movb	%al, gdt_table_provis+61
	subl	$12, %esp
	pushl	$gdt_table_provis+32
	call	print_gdt_entry
	movl	$gdt_table_provis+40, (%esp)
	call	print_gdt_entry
	call	init_gdtptr
	call	enable_a20_keyb
	movl	%eax, %ebx
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	%ebx, (%esp)
	call	print_U32
	call	print_newline
	movl	$0, -12(%ebp)
	addl	$12, %esp
	leal	-12(%ebp), %eax
	pushl	%eax
	pushl	$0
	pushl	$12288
	call	get_mem_map
	movl	%eax, %ebx
	movl	%eax, 65280
	movl	-12(%ebp), %eax
	movl	%eax, 65284
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC6, (%esp)
	call	print_str
	movl	%ebx, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC7, (%esp)
	call	print_str
	popl	%eax
	pushl	-12(%ebp)
	call	print_U32
	call	print_newline
	addl	$16, %esp
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	kmain, .-kmain
	.comm	gdt_table_provis,64,16
	.comm	gdt_ptr_provis,6,8
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5.1) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
