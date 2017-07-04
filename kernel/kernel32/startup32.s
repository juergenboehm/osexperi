	.file	"startup32.c"
#APP
	.code16gcc	

	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"ide test: IDENTIFY_DEVICE: ok = %08x\n"
.LC1:
	.string	"ide test: BSY %01x DRDY %01x DF %01x DRQ %01x ERR %01x\n\n"
.LC2:
	.string	"ide test: SET_FEATURE: ok = %08x\n"
.LC3:
	.string	"ide test: ok = %08x\n"
#NO_APP
	.text
	.globl	ide_test
	.type	ide_test, @function
ide_test:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$12, %esp
	movl	ide_ctrl_PM, %ebx
	movl	ide_buffer, %eax
	movl	%eax, 11(%ebx)
	pushl	$0
	pushl	%ebx
	call	ide_IDENTIFY_DEVICE
	popl	%edx
	popl	%ecx
	pushl	%eax
	pushl	$.LC0
	call	printf
	popl	%eax
	popl	%edx
	movzbl	19(%ebx), %eax
	pushl	%eax
	movzbl	18(%ebx), %eax
	pushl	%eax
	movzbl	17(%ebx), %eax
	pushl	%eax
	movzbl	16(%ebx), %eax
	pushl	%eax
	movzbl	15(%ebx), %eax
	pushl	%eax
	pushl	$.LC1
	call	printf
	addl	$24, %esp
	pushl	$512
	pushl	ide_buffer
	call	display_buffer
	popl	%ecx
	popl	%eax
	pushl	$0
	pushl	%ebx
	call	ide_SET_FEATURE
	popl	%edx
	popl	%ecx
	pushl	%eax
	pushl	$.LC2
	call	printf
	popl	%eax
	popl	%edx
	movzbl	19(%ebx), %eax
	pushl	%eax
	movzbl	18(%ebx), %eax
	pushl	%eax
	movzbl	17(%ebx), %eax
	pushl	%eax
	movzbl	16(%ebx), %eax
	pushl	%eax
	movzbl	15(%ebx), %eax
	pushl	%eax
	pushl	$.LC1
	call	printf
	addl	$24, %esp
	pushl	$0
	pushl	%ebx
	call	ide_IDENTIFY_DEVICE
	popl	%ecx
	popl	%edx
	pushl	%eax
	pushl	$.LC0
	call	printf
	popl	%ecx
	popl	%eax
	movzbl	19(%ebx), %eax
	pushl	%eax
	movzbl	18(%ebx), %eax
	pushl	%eax
	movzbl	17(%ebx), %eax
	pushl	%eax
	movzbl	16(%ebx), %eax
	pushl	%eax
	movzbl	15(%ebx), %eax
	pushl	%eax
	pushl	$.LC1
	call	printf
	addl	$24, %esp
	pushl	$512
	pushl	ide_buffer
	call	display_buffer
	movl	$0, (%esp)
	pushl	$0
	pushl	$1
	pushl	prd_table
	pushl	%ebx
	call	ide_READ_DMA
	addl	$24, %esp
	pushl	%eax
	pushl	$.LC3
	call	printf
	popl	%eax
	popl	%edx
	movzbl	19(%ebx), %eax
	pushl	%eax
	movzbl	18(%ebx), %eax
	pushl	%eax
	movzbl	17(%ebx), %eax
	pushl	%eax
	movzbl	16(%ebx), %eax
	pushl	%eax
	movzbl	15(%ebx), %eax
	pushl	%eax
	pushl	$.LC1
	call	printf
	addl	$24, %esp
	pushl	$512
	pushl	ide_buffer
	call	display_buffer
	movl	$0, (%esp)
	pushl	$1
	pushl	$1
	pushl	prd_table
	pushl	%ebx
	call	ide_READ_DMA
	addl	$24, %esp
	pushl	%eax
	pushl	$.LC3
	call	printf
	popl	%ecx
	popl	%eax
	movzbl	19(%ebx), %eax
	pushl	%eax
	movzbl	18(%ebx), %eax
	pushl	%eax
	movzbl	17(%ebx), %eax
	pushl	%eax
	movzbl	16(%ebx), %eax
	pushl	%eax
	movzbl	15(%ebx), %eax
	pushl	%eax
	pushl	$.LC1
	call	printf
	addl	$24, %esp
	pushl	$512
	pushl	ide_buffer
	call	display_buffer
	addl	$16, %esp
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	ide_test, .-ide_test
	.globl	keyb_controller_comreg
	.type	keyb_controller_comreg, @function
keyb_controller_comreg:
	pushl	%ebp
	movl	%esp, %ebp
	movb	$32, %al
#APP
# 25 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	outb %al, $100
# 0 "" 2
# 18 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	inb $96, %al
# 0 "" 2
#NO_APP
	movb	%al, %dl
	movb	$96, %al
#APP
# 25 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	outb %al, $100
# 0 "" 2
#NO_APP
	movb	%dl, %al
#APP
# 25 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	outb %al, $96
# 0 "" 2
#NO_APP
	popl	%ebp
	ret
	.size	keyb_controller_comreg, .-keyb_controller_comreg
	.section	.rodata.str1.1
.LC4:
	.string	"/dev/vga0"
.LC5:
	.string	"/dev/vga1"
.LC6:
	.string	"/dev/vga2"
.LC7:
	.string	"/dev/vga3"
.LC8:
	.string	"Protected mode.\n"
.LC9:
	.string	"Paging enabled.\n\n"
.LC10:
	.string	"\nkmain32: ide_buffer = %08x\n"
.LC11:
	.string	"\nkmain32: prd_table = %08x\n"
	.text
	.globl	kmain32
	.type	kmain32, @function
kmain32:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	$0, current
	call	init_base_files
	call	init_kalloc_fixed
	pushl	%eax
	pushl	%eax
	pushl	$1
	pushl	$.LC4
	call	do_open
	popl	%eax
	popl	%edx
	pushl	$1
	pushl	$.LC5
	call	do_open
	popl	%ecx
	popl	%eax
	pushl	$1
	pushl	$.LC6
	call	do_open
	popl	%eax
	popl	%edx
	pushl	$1
	pushl	$.LC7
	call	do_open
	call	test_ext2
	call	init_mem_system
	call	init_malloc_system
	movl	$.LC8, (%esp)
	call	printf
	movl	$.LC9, (%esp)
	call	printf
	call	init_gdt_table_32
	movl	$2048, (%esp)
	call	malloc
	movl	%eax, idt_table
	call	init_idt_table
	call	init_pic
	movl	$1, schedule_off
	movl	$0, timer_special_counter
	movl	$0, keyb_special_counter
	movl	$128, (%esp)
	call	malloc
	movw	$2047, idt_ptr
	movl	idt_table, %eax
	movl	%eax, idt_ptr+2
#APP
# 181 "kernel32/startup32.c" 1
	lidt idt_ptr
# 0 "" 2
#NO_APP
	call	init_global_tss
#APP
# 60 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	sti
# 0 "" 2
# 72 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	pushfl 
	popl %eax 
	cli 
	
# 0 "" 2
#NO_APP
	addl	$16, %esp
	testb	$2, %ah
	je	.L6
#APP
# 85 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	sti
# 0 "" 2
#NO_APP
.L6:
	call	init_keyboard
	call	init_keytables
	movl	$0, keyb_sema
	movl	$0, timer_sema
	call	display_bios_mem_area_table
	call	waitkey
	subl	$12, %esp
	pushl	$pci_addr_ide_contr
	call	enumerate_pci_bus
	movl	$pci_addr_ide_contr, (%esp)
	call	ide_init
	popl	%eax
	popl	%edx
	pushl	$65536
	pushl	$512
	call	kalloc_fixed_aligned
	movl	%eax, ide_buffer
	popl	%ecx
	popl	%edx
	pushl	%eax
	pushl	$.LC10
	call	printf
	popl	%ecx
	popl	%eax
	pushl	$65536
	pushl	$128
	call	kalloc_fixed_aligned
	movl	%eax, prd_table
	popl	%edx
	popl	%ecx
	pushl	%eax
	pushl	$.LC11
	call	printf
	call	waitkey
	call	waitkey
	call	waitkey
	call	waitkey
	call	waitkey
	call	waitkey
	movl	$4096, (%esp)
	call	init_process_1_xp
	addl	$16, %esp
	leave
	ret
	.size	kmain32, .-kmain32
	.comm	prd_table,4,4
	.comm	ide_buffer,4,4
	.comm	malloc_heads,60,4
	.comm	malloc_sizes_log,60,4
	.comm	ide_ctrl_PM,4,4
	.comm	ide_res_sema,4,4
	.comm	ide_irq_sema,4,4
	.ident	"GCC: (GNU) 4.8.2 20140120 (Red Hat 4.8.2-15)"
	.section	.note.GNU-stack,"",@progbits
