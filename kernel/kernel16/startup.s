	.file	"startup.c"
#APP
	.code16gcc	

#NO_APP
	.comm	gdt_table_provis,64,16
	.comm	gdt_ptr_provis,6,8
	.section	.rodata
.LC0:
	.string	"kernel16/startup.c"
.LC1:
	.string	":"
.LC2:
	.string	"sizeof(GDT_ENTRY) = "
.LC3:
	.string	"addr_gdtable_provis = "
	.text
	.globl	init_gdtptr
	.type	init_gdtptr, @function
init_gdtptr:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$6, 8(%esp)
	movl	$0, 4(%esp)
	movl	$gdt_ptr_provis, (%esp)
	call	memset16
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC2, (%esp)
	call	print_str
	movl	$8, (%esp)
	call	print_U32
	call	print_newline
	movl	$gdt_table_provis, -12(%ebp)
	addl	$131072, -12(%ebp)
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC3, (%esp)
	call	print_str
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movw	$63, gdt_ptr_provis
	movl	-12(%ebp), %eax
	movl	%eax, gdt_ptr_provis+2
#APP
# 46 "kernel16/startup.c" 1
	lgdt gdt_ptr_provis
# 0 "" 2
#NO_APP
	leave
	ret
	.size	init_gdtptr, .-init_gdtptr
	.globl	enable_a20
	.type	enable_a20, @function
enable_a20:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
#APP
# 55 "kernel16/startup.c" 1
	movw $0x2401, %ax
	int $0x15
	movb $0, %al
	rclb %al
	movw %ax, %dx
	
# 0 "" 2
#NO_APP
	movw	%dx, -2(%ebp)
	movzwl	-2(%ebp), %eax
	leave
	ret
	.size	enable_a20, .-enable_a20
	.globl	keyb_wait
	.type	keyb_wait, @function
keyb_wait:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	movb	%dl, -4(%ebp)
	movb	%al, -8(%ebp)
#APP
# 69 "kernel16/startup.c" 1
	1: 
	testb $0xff, -8(%ebp) 
	jz 3f 
	2: 
	inb	$0x64, %al 
	testb	-4(%ebp), %al 
	jz 2b 
	jmp 4f 
	3: 
	inb	$0x64, %al 
	testb	-4(%ebp), %al 
	jnz 3b 
	4: 
	nop 
	
# 0 "" 2
#NO_APP
	leave
	ret
	.size	keyb_wait, .-keyb_wait
	.globl	keyb_send_cmd
	.type	keyb_send_cmd, @function
keyb_send_cmd:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp
	movl	8(%ebp), %eax
	movb	%al, -4(%ebp)
	movl	$0, 4(%esp)
	movl	$2, (%esp)
	call	keyb_wait
	movb	-4(%ebp), %al
#APP
# 90 "kernel16/startup.c" 1
	outb %al, $0x64
# 0 "" 2
#NO_APP
	leave
	ret
	.size	keyb_send_cmd, .-keyb_send_cmd
	.globl	keyb_send_data
	.type	keyb_send_data, @function
keyb_send_data:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp
	movl	8(%ebp), %eax
	movb	%al, -4(%ebp)
	movl	$0, 4(%esp)
	movl	$2, (%esp)
	call	keyb_wait
	movb	-4(%ebp), %al
#APP
# 99 "kernel16/startup.c" 1
	outb %al, $0x60
# 0 "" 2
#NO_APP
	leave
	ret
	.size	keyb_send_data, .-keyb_send_data
	.globl	keyb_get_data
	.type	keyb_get_data, @function
keyb_get_data:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movb	$0, -1(%ebp)
	movl	$1, 4(%esp)
	movl	$1, (%esp)
	call	keyb_wait
#APP
# 109 "kernel16/startup.c" 1
	inb $0x60, %al
# 0 "" 2
#NO_APP
	movb	%al, -1(%ebp)
	movb	-1(%ebp), %al
	leave
	ret
	.size	keyb_get_data, .-keyb_get_data
	.globl	enable_a20_keyb
	.type	enable_a20_keyb, @function
enable_a20_keyb:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
#APP
# 118 "kernel16/startup.c" 1
	cli
# 0 "" 2
#NO_APP
	movl	$173, (%esp)
	call	keyb_send_cmd
	movl	$208, (%esp)
	call	keyb_send_cmd
	call	keyb_get_data
	movb	%al, -1(%ebp)
	orb	$2, -1(%ebp)
	movl	$209, (%esp)
	call	keyb_send_cmd
	movzbl	-1(%ebp), %eax
	movl	%eax, (%esp)
	call	keyb_send_data
	movl	$174, (%esp)
	call	keyb_send_cmd
#APP
# 130 "kernel16/startup.c" 1
	sti
# 0 "" 2
#NO_APP
	movl	$0, %eax
	leave
	ret
	.size	enable_a20_keyb, .-enable_a20_keyb
	.globl	enable_a20_bios_15
	.type	enable_a20_bios_15, @function
enable_a20_bios_15:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$20, %esp
	movl	$0, -16(%ebp)
#APP
# 139 "kernel16/startup.c" 1
	pushl %ebp 
	pushal 
	pushw %ds 
	 pushw %es 
	 pushw %fs 
	 pushw %gs 
	movw     $0x2403, %ax                #--- A20-Gate Support --- 
	int     $0x15  
	jb      .a20_ns                  # INT 15h is not supported 
	cmpb    $0, %ah 
	jnz     .a20_ns                  # INT 15h is not supported 
	movw    $0x2402, %ax                # --- A20-Gate Status --- 
	int     $0x15 
	jb      .a20_failed              # couldn't get status 
	cmpb    $0, %ah 
	jnz     .a20_failed              #couldn't get status 
	cmpb    $0x01, %al 
	jz      .a20_already_activated           # A20 is already activated 
	movw     $0x2401, %ax           # --- A20-Gate Activate --- 
	int     $0x15 
	jb      .a20_failed               #couldn't activate the gate 
	cmp     $0, %ah 
	jnz     .a20_failed              # couldn't activate the gate 
	movl		$0x1234, -32(%ebp) 
	jmp		.ende 
	 .a20_already_activated: 
	movl		$0x5678, -32(%ebp) 
	jmp		.ende 
	 .a20_ns: 
	movl	$0xabab, -32(%ebp) 
	jmp 		.ende 
	 .a20_failed: 
	movl $0xcdcd, -32(%ebp) 
	.ende: 
	popw %gs 
	 popw %fs 
	 popw %es 
	 popw %ds 
	popal 
	popl %ebp 
	
# 0 "" 2
#NO_APP
	movl	-32(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	addl	$20, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	enable_a20_bios_15, .-enable_a20_bios_15
	.globl	set_video_mode
	.type	set_video_mode, @function
set_video_mode:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$20, %esp
	movl	8(%ebp), %eax
	movb	%al, -32(%ebp)
	movb	$0, -13(%ebp)
#APP
# 185 "kernel16/startup.c" 1
	movb $0, %ah 
	movb -32(%ebp), %al 
	 int $0x10 
	movb %al, -29(%ebp)
# 0 "" 2
#NO_APP
	movb	-29(%ebp), %al
	movb	%al, -13(%ebp)
	movzbl	-13(%ebp), %eax
	addl	$20, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	set_video_mode, .-set_video_mode
	.section	.rodata
.LC4:
	.string	"\r\nKernel primary loaded.\r\n"
.LC5:
	.string	"a_20 ok = "
.LC6:
	.string	"a_20 bios 15 retcode = "
.LC7:
	.string	"err mem map = "
.LC8:
	.string	"len mem map = "
	.text
	.globl	kmain
	.type	kmain, @function
kmain:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	subl	$52, %esp
	movl	$0, -12(%ebp)
	movl	$.LC4, (%esp)
	call	print_str
	movl	$0, -12(%ebp)
	jmp	.L16
.L17:
	movl	-12(%ebp), %eax
	movw	$0, gdt_table_provis+2(,%eax,8)
	movl	-12(%ebp), %eax
	movb	$0, gdt_table_provis+4(,%eax,8)
	movl	-12(%ebp), %eax
	movb	$0, gdt_table_provis+7(,%eax,8)
	movl	-12(%ebp), %eax
	movw	$0, gdt_table_provis(,%eax,8)
	movl	-12(%ebp), %eax
	movb	gdt_table_provis+6(,%eax,8), %al
	andl	$-16, %eax
	movb	%al, %dl
	movl	-12(%ebp), %eax
	movb	%dl, gdt_table_provis+6(,%eax,8)
	movl	-12(%ebp), %eax
	movb	gdt_table_provis+6(,%eax,8), %al
	andl	$127, %eax
	movb	%al, %dl
	movl	-12(%ebp), %eax
	movb	%dl, gdt_table_provis+6(,%eax,8)
	movl	-12(%ebp), %eax
	movb	gdt_table_provis+6(,%eax,8), %al
	andl	$-65, %eax
	movb	%al, %dl
	movl	-12(%ebp), %eax
	movb	%dl, gdt_table_provis+6(,%eax,8)
	movl	-12(%ebp), %eax
	movb	gdt_table_provis+6(,%eax,8), %al
	andl	$-33, %eax
	movb	%al, %dl
	movl	-12(%ebp), %eax
	movb	%dl, gdt_table_provis+6(,%eax,8)
	movl	-12(%ebp), %eax
	movb	gdt_table_provis+6(,%eax,8), %al
	andl	$-17, %eax
	movb	%al, %dl
	movl	-12(%ebp), %eax
	movb	%dl, gdt_table_provis+6(,%eax,8)
	movl	-12(%ebp), %eax
	movb	gdt_table_provis+5(,%eax,8), %al
	andl	$-17, %eax
	movb	%al, %dl
	movl	-12(%ebp), %eax
	movb	%dl, gdt_table_provis+5(,%eax,8)
	movl	-12(%ebp), %eax
	movb	gdt_table_provis+5(,%eax,8), %al
	andl	$127, %eax
	movb	%al, %dl
	movl	-12(%ebp), %eax
	movb	%dl, gdt_table_provis+5(,%eax,8)
	movl	-12(%ebp), %eax
	movb	gdt_table_provis+5(,%eax,8), %al
	andl	$-97, %eax
	movb	%al, %dl
	movl	-12(%ebp), %eax
	movb	%dl, gdt_table_provis+5(,%eax,8)
	movl	-12(%ebp), %eax
	movb	gdt_table_provis+5(,%eax,8), %al
	andl	$-15, %eax
	movb	%al, %dl
	movl	-12(%ebp), %eax
	movb	%dl, gdt_table_provis+5(,%eax,8)
	incl	-12(%ebp)
.L16:
	cmpl	$7, -12(%ebp)
	jle	.L17
	movl	$64, 8(%esp)
	movl	$0, 4(%esp)
	movl	$gdt_table_provis, (%esp)
	call	memset16
	movw	$0, gdt_table_provis+18
	movb	$0, gdt_table_provis+20
	movb	$0, gdt_table_provis+23
	movw	$-1, gdt_table_provis+16
	movb	gdt_table_provis+22, %al
	orl	$15, %eax
	movb	%al, gdt_table_provis+22
	movb	gdt_table_provis+22, %al
	orl	$-128, %eax
	movb	%al, gdt_table_provis+22
	movb	gdt_table_provis+22, %al
	orl	$64, %eax
	movb	%al, gdt_table_provis+22
	movb	gdt_table_provis+22, %al
	andl	$-33, %eax
	movb	%al, gdt_table_provis+22
	movb	gdt_table_provis+22, %al
	andl	$-17, %eax
	movb	%al, gdt_table_provis+22
	movb	gdt_table_provis+21, %al
	orl	$16, %eax
	movb	%al, gdt_table_provis+21
	movb	gdt_table_provis+21, %al
	orl	$-128, %eax
	movb	%al, gdt_table_provis+21
	movb	gdt_table_provis+21, %al
	andl	$-97, %eax
	movb	%al, gdt_table_provis+21
	movb	gdt_table_provis+21, %al
	andl	$-16, %eax
	orl	$10, %eax
	movb	%al, gdt_table_provis+21
	movw	$0, gdt_table_provis+26
	movb	$0, gdt_table_provis+28
	movb	$0, gdt_table_provis+31
	movw	$-1, gdt_table_provis+24
	movb	gdt_table_provis+30, %al
	orl	$15, %eax
	movb	%al, gdt_table_provis+30
	movb	gdt_table_provis+30, %al
	orl	$-128, %eax
	movb	%al, gdt_table_provis+30
	movb	gdt_table_provis+30, %al
	orl	$64, %eax
	movb	%al, gdt_table_provis+30
	movb	gdt_table_provis+30, %al
	andl	$-33, %eax
	movb	%al, gdt_table_provis+30
	movb	gdt_table_provis+30, %al
	andl	$-17, %eax
	movb	%al, gdt_table_provis+30
	movb	gdt_table_provis+29, %al
	orl	$16, %eax
	movb	%al, gdt_table_provis+29
	movb	gdt_table_provis+29, %al
	orl	$-128, %eax
	movb	%al, gdt_table_provis+29
	movb	gdt_table_provis+29, %al
	andl	$-97, %eax
	movb	%al, gdt_table_provis+29
	movb	gdt_table_provis+29, %al
	andl	$-16, %eax
	orl	$2, %eax
	movb	%al, gdt_table_provis+29
	movw	$0, gdt_table_provis+18
	movb	$3, gdt_table_provis+20
	movb	$0, gdt_table_provis+23
	movw	$0, gdt_table_provis+26
	movb	$3, gdt_table_provis+28
	movb	$0, gdt_table_provis+31
	movw	$-49, gdt_table_provis+16
	movb	gdt_table_provis+22, %al
	orl	$15, %eax
	movb	%al, gdt_table_provis+22
	movw	$-49, gdt_table_provis+24
	movb	gdt_table_provis+30, %al
	orl	$15, %eax
	movb	%al, gdt_table_provis+30
	movw	$0, gdt_table_provis+34
	movb	$0, gdt_table_provis+36
	movb	$0, gdt_table_provis+39
	movw	$-1, gdt_table_provis+32
	movb	gdt_table_provis+38, %al
	orl	$15, %eax
	movb	%al, gdt_table_provis+38
	movb	gdt_table_provis+38, %al
	orl	$-128, %eax
	movb	%al, gdt_table_provis+38
	movb	gdt_table_provis+38, %al
	orl	$64, %eax
	movb	%al, gdt_table_provis+38
	movb	gdt_table_provis+38, %al
	andl	$-33, %eax
	movb	%al, gdt_table_provis+38
	movb	gdt_table_provis+38, %al
	andl	$-17, %eax
	movb	%al, gdt_table_provis+38
	movb	gdt_table_provis+37, %al
	orl	$16, %eax
	movb	%al, gdt_table_provis+37
	movb	gdt_table_provis+37, %al
	orl	$-128, %eax
	movb	%al, gdt_table_provis+37
	movb	gdt_table_provis+37, %al
	andl	$-97, %eax
	movb	%al, gdt_table_provis+37
	movb	gdt_table_provis+37, %al
	andl	$-16, %eax
	orl	$10, %eax
	movb	%al, gdt_table_provis+37
	movw	$0, gdt_table_provis+42
	movb	$0, gdt_table_provis+44
	movb	$0, gdt_table_provis+47
	movw	$-1, gdt_table_provis+40
	movb	gdt_table_provis+46, %al
	orl	$15, %eax
	movb	%al, gdt_table_provis+46
	movb	gdt_table_provis+46, %al
	orl	$-128, %eax
	movb	%al, gdt_table_provis+46
	movb	gdt_table_provis+46, %al
	orl	$64, %eax
	movb	%al, gdt_table_provis+46
	movb	gdt_table_provis+46, %al
	andl	$-33, %eax
	movb	%al, gdt_table_provis+46
	movb	gdt_table_provis+46, %al
	andl	$-17, %eax
	movb	%al, gdt_table_provis+46
	movb	gdt_table_provis+45, %al
	orl	$16, %eax
	movb	%al, gdt_table_provis+45
	movb	gdt_table_provis+45, %al
	orl	$-128, %eax
	movb	%al, gdt_table_provis+45
	movb	gdt_table_provis+45, %al
	andl	$-97, %eax
	movb	%al, gdt_table_provis+45
	movb	gdt_table_provis+45, %al
	andl	$-16, %eax
	orl	$2, %eax
	movb	%al, gdt_table_provis+45
	movw	$0, gdt_table_provis+50
	movb	$0, gdt_table_provis+52
	movb	$0, gdt_table_provis+55
	movw	$-1, gdt_table_provis+48
	movb	gdt_table_provis+54, %al
	orl	$15, %eax
	movb	%al, gdt_table_provis+54
	movb	gdt_table_provis+54, %al
	orl	$-128, %eax
	movb	%al, gdt_table_provis+54
	movb	gdt_table_provis+54, %al
	orl	$64, %eax
	movb	%al, gdt_table_provis+54
	movb	gdt_table_provis+54, %al
	andl	$-33, %eax
	movb	%al, gdt_table_provis+54
	movb	gdt_table_provis+54, %al
	andl	$-17, %eax
	movb	%al, gdt_table_provis+54
	movb	gdt_table_provis+53, %al
	orl	$16, %eax
	movb	%al, gdt_table_provis+53
	movb	gdt_table_provis+53, %al
	orl	$-128, %eax
	movb	%al, gdt_table_provis+53
	movb	gdt_table_provis+53, %al
	orl	$96, %eax
	movb	%al, gdt_table_provis+53
	movb	gdt_table_provis+53, %al
	andl	$-16, %eax
	orl	$10, %eax
	movb	%al, gdt_table_provis+53
	movw	$0, gdt_table_provis+58
	movb	$0, gdt_table_provis+60
	movb	$0, gdt_table_provis+63
	movw	$-1, gdt_table_provis+56
	movb	gdt_table_provis+62, %al
	orl	$15, %eax
	movb	%al, gdt_table_provis+62
	movb	gdt_table_provis+62, %al
	orl	$-128, %eax
	movb	%al, gdt_table_provis+62
	movb	gdt_table_provis+62, %al
	orl	$64, %eax
	movb	%al, gdt_table_provis+62
	movb	gdt_table_provis+62, %al
	andl	$-33, %eax
	movb	%al, gdt_table_provis+62
	movb	gdt_table_provis+62, %al
	andl	$-17, %eax
	movb	%al, gdt_table_provis+62
	movb	gdt_table_provis+61, %al
	orl	$16, %eax
	movb	%al, gdt_table_provis+61
	movb	gdt_table_provis+61, %al
	orl	$-128, %eax
	movb	%al, gdt_table_provis+61
	movb	gdt_table_provis+61, %al
	orl	$96, %eax
	movb	%al, gdt_table_provis+61
	movb	gdt_table_provis+61, %al
	andl	$-16, %eax
	orl	$2, %eax
	movb	%al, gdt_table_provis+61
	movl	$gdt_table_provis+32, -16(%ebp)
	movl	$0, -12(%ebp)
	jmp	.L18
.L19:
	movl	-16(%ebp), %eax
	leal	8(%eax), %edx
	movl	%edx, -16(%ebp)
	movl	%eax, (%esp)
	call	print_gdt_entry
	incl	-12(%ebp)
.L18:
	cmpl	$1, -12(%ebp)
	jle	.L19
	call	init_gdtptr
	call	enable_a20_keyb
	movl	%eax, -20(%ebp)
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	call	enable_a20_bios_15
	movl	%eax, -24(%ebp)
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC6, (%esp)
	call	print_str
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	$0, -36(%ebp)
	leal	-36(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	movl	$12288, (%esp)
	call	get_mem_map
	movl	%eax, -28(%ebp)
	movl	$65280, -32(%ebp)
	movl	-32(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, -32(%ebp)
	movl	-28(%ebp), %edx
	movl	%edx, (%eax)
	movl	-36(%ebp), %edx
	movl	-32(%ebp), %eax
	movl	%edx, (%eax)
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC7, (%esp)
	call	print_str
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC8, (%esp)
	call	print_str
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC5, (%esp)
	call	print_str
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
	movl	$.LC0, (%esp)
	call	print_str
	movl	$.LC1, (%esp)
	call	print_str
	movl	$.LC6, (%esp)
	call	print_str
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	print_U32
	call	print_newline
#APP
# 313 "kernel16/startup.c" 1
	movw		$0xb800, %ax 
	movw		%ax, %es 
	xor		%di, %di 
	movb		$70, %es:(%di) 
	inc		%di 
	movb		$0x1e, %es:(%di) 
	
# 0 "" 2
#NO_APP
	movl	$0, %eax
	addl	$52, %esp
	popl	%edi
	popl	%ebp
	ret
	.size	kmain, .-kmain
	.ident	"GCC: (GNU) 4.8.2 20140120 (Red Hat 4.8.2-15)"
	.section	.note.GNU-stack,"",@progbits
