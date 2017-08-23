	.file	"startup32.c"
	.text
	.type	inb, @function
inb:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	8(%ebp), %eax
	movw	%ax, -20(%ebp)
	movzwl	-20(%ebp), %eax
	movl	%eax, %edx
/APP
/  18 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	inb %dx, %al
/  0 "" 2
/NO_APP
	movb	%al, -1(%ebp)
	movzbl	-1(%ebp), %eax
	leave
	ret
	.size	inb, .-inb
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
/  25 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	outb %al, %dx
/  0 "" 2
/NO_APP
	leave
	ret
	.size	outb, .-outb
	.type	sti, @function
sti:
	pushl	%ebp
	movl	%esp, %ebp
/APP
/  60 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	sti
/  0 "" 2
/NO_APP
	popl	%ebp
	ret
	.size	sti, .-sti
/APP
	.code16gcc	

/NO_APP
	.comm	global_in_de_hash_headers,2164,32
	.comm	global_in_de_lru_list,4,4
	.comm	ide_result,4,4
	.comm	ide_ctrl_PM,4,4
	.comm	malloc_sizes_log,60,32
	.comm	malloc_heads,60,32
	.comm	ide_buffer,4,4
	.comm	prd_table,4,4
	.globl	keyb_controller_comreg
	.type	keyb_controller_comreg, @function
keyb_controller_comreg:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$32, 4(%esp)
	movl	$100, (%esp)
	call	outb
	movl	$96, (%esp)
	call	inb
	movb	%al, -1(%ebp)
	movl	$96, 4(%esp)
	movl	$100, (%esp)
	call	outb
	movzbl	-1(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$96, (%esp)
	call	outb
	leave
	ret
	.size	keyb_controller_comreg, .-keyb_controller_comreg
	.section	.rodata
.LC0:
	.string	"kmain32 started.\n"
.LC1:
	.string	"kalloc_fixed_done.\n"
.LC2:
	.string	"init_mem_system done.\n"
.LC3:
	.string	"init_malloc_system done.\n"
.LC4:
	.string	"init_base_files done.\n"
.LC5:
	.string	"/dev/vga0"
.LC6:
	.string	"/dev/vga1"
.LC7:
	.string	"/dev/vga2"
.LC8:
	.string	"/dev/vga3"
.LC9:
	.string	"Protected mode.\n"
.LC10:
	.string	"Paging enabled.\n\n"
.LC11:
	.string	"kernel32/startup32.c"
.LC12:
	.string	"[Debug: %s:%d]"
.LC13:
	.string	"Len16: %08x\n"
.LC14:
	.string	"Len32: %08x\n\n"
.LC15:
	.string	"\nkmain32: ide_buffer = %08x\n"
.LC16:
	.string	"\nkmain32: prd_table = %08x\n"
.LC17:
	.string	"val1 = %016lx\n"
	.text
	.globl	kmain32
	.type	kmain32, @function
kmain32:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$72, %esp
	movl	$0, current
	movl	$0, screen_current
	movl	$0, -12(%ebp)
	jmp	.L7
.L8:
	movl	-12(%ebp), %eax
	addl	$pidbuf, %eax
	movb	$0, (%eax)
	addl	$1, -12(%ebp)
.L7:
	cmpl	$3, -12(%ebp)
	jbe	.L8
	movzbl	pidbuf, %eax
	orl	$1, %eax
	movb	%al, pidbuf
	movl	$.LC0, (%esp)
	call	outb_printf
	call	init_kalloc_fixed
	movl	$.LC1, (%esp)
	call	outb_printf
	call	init_mem_system
	movl	$.LC2, (%esp)
	call	outb_printf
	call	init_malloc_system
	movl	$.LC3, (%esp)
	call	outb_printf
	call	init_base_files
	movl	$.LC4, (%esp)
	call	outb_printf
	movl	$1, 4(%esp)
	movl	$.LC5, (%esp)
	call	do_open
	movl	%eax, -16(%ebp)
	movl	$1, 4(%esp)
	movl	$.LC6, (%esp)
	call	do_open
	movl	%eax, -20(%ebp)
	movl	$1, 4(%esp)
	movl	$.LC7, (%esp)
	call	do_open
	movl	%eax, -24(%ebp)
	movl	$1, 4(%esp)
	movl	$.LC8, (%esp)
	call	do_open
	movl	%eax, -28(%ebp)
	movl	$.LC9, (%esp)
	call	printf
	movl	$.LC10, (%esp)
	call	printf
	call	init_gdt_table_32
	movl	$137, 8(%esp)
	movl	$.LC11, 4(%esp)
	movl	$.LC12, (%esp)
	call	outb_printf
	movl	_len16, %eax
	movl	%eax, 4(%esp)
	movl	$.LC13, (%esp)
	call	outb_printf
	movl	$138, 8(%esp)
	movl	$.LC11, 4(%esp)
	movl	$.LC12, (%esp)
	call	outb_printf
	movl	_len32, %eax
	movl	%eax, 4(%esp)
	movl	$.LC14, (%esp)
	call	outb_printf
	movl	$2048, (%esp)
	call	malloc
	movl	%eax, idt_table
	call	init_idt_table
	call	init_pic_alt
	movl	$1, schedule_off
	movl	$0, keyb_special_counter
	movl	$128, (%esp)
	call	malloc
	movl	%eax, -32(%ebp)
	movl	$6, 8(%esp)
	movl	$0, 4(%esp)
	movl	$idt_ptr, (%esp)
	call	memset
	movw	$2047, idt_ptr
	movl	idt_table, %eax
	movl	%eax, idt_ptr+2
/APP
/  154 "kernel32/startup32.c" 1
	lidt idt_ptr
/  0 "" 2
/NO_APP
	call	init_global_tss
	call	init_sync_system
	call	init_objects
	call	sti
	movl	$0, -12(%ebp)
	call	init_keyboard
	call	init_keytables
	call	init_timer
	call	display_bios_mem_area_table
	call	waitkey
	movl	$pci_addr_ide_contr, (%esp)
	call	enumerate_pci_bus
	movl	$pci_addr_ide_contr, (%esp)
	call	ide_init
	movl	%eax, -36(%ebp)
	call	init_bufcache
	movl	$65536, (%esp)
	call	malloc
	movl	%eax, ide_buffer
	movl	ide_buffer, %eax
	movl	%eax, 4(%esp)
	movl	$.LC15, (%esp)
	call	printf
	movl	$65536, (%esp)
	call	malloc
	movl	%eax, prd_table
	movl	prd_table, %eax
	movl	%eax, 4(%esp)
	movl	$.LC16, (%esp)
	call	printf
	movl	$0, -40(%ebp)
	movl	$-889275714, -48(%ebp)
	movl	$1611514078, -44(%ebp)
	movl	-48(%ebp), %eax
	movl	-44(%ebp), %edx
	movl	%eax, 4(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC17, (%esp)
	call	printf
	movl	$0, -12(%ebp)
	jmp	.L9
.L10:
	call	waitkey
	addl	$1, -12(%ebp)
.L9:
	cmpl	$1, -12(%ebp)
	jbe	.L10
	movl	$4096, -52(%ebp)
	movl	-52(%ebp), %eax
	movl	%eax, (%esp)
	call	init_process_1_xp
	leave
	ret
	.size	kmain32, .-kmain32
	.ident	"GCC: (GNU) 4.8.2"
