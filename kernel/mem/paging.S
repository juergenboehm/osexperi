	.file	"paging.c"
	.text
	.globl	create_page_table_init
	.type	create_page_table_init, @function
create_page_table_init:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$12, %esp
	pushl	$4096
	pushl	$4096
	call	kalloc_fixed_aligned
	movl	%eax, %ebx
	addl	$12, %esp
	pushl	$4096
	pushl	$0
	pushl	%eax
	call	memset
	movl	%ebx, %eax
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	create_page_table_init, .-create_page_table_init
	.globl	wait
	.type	wait, @function
wait:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	$0, -4(%ebp)
	movl	$0, -4(%ebp)
.L4:
	movl	-4(%ebp), %eax
	cmpl	8(%ebp), %eax
	jae	.L8
	movl	-4(%ebp), %eax
	incl	%eax
	movl	%eax, -4(%ebp)
	jmp	.L4
.L8:
	leave
	ret
	.size	wait, .-wait
	.globl	kprint_U32x
	.type	kprint_U32x, @function
kprint_U32x:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	8(%ebp), %eax
	movl	$28, %ecx
.L13:
	movl	12(%ebp), %edx
	shrl	%cl, %edx
	andl	$15, %edx
	movl	(%eax), %esi
	leal	48(%edx), %ebx
	cmpl	$9, %edx
	jbe	.L11
	leal	87(%edx), %ebx
.L11:
	movb	%bl, (%esi)
	movl	(%eax), %edx
	leal	1(%edx), %ebx
	movl	%ebx, (%eax)
	movb	$30, 1(%edx)
	incl	(%eax)
	subl	$4, %ecx
	cmpl	$-4, %ecx
	jne	.L13
	movl	(%eax), %edx
	movb	$32, (%edx)
	movl	(%eax), %edx
	leal	1(%edx), %ecx
	movl	%ecx, (%eax)
	movb	$30, 1(%edx)
	movl	(%eax), %edx
	leal	1(%edx), %ecx
	movl	%ecx, (%eax)
	movb	$32, 1(%edx)
	movl	(%eax), %edx
	leal	1(%edx), %ecx
	movl	%ecx, (%eax)
	movb	$30, 1(%edx)
	movl	(%eax), %esi
	leal	1(%esi), %edx
	cmpl	$757504, %edx
	jbe	.L14
	movl	$753664, %edx
.L14:
	movl	%edx, (%eax)
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	kprint_U32x, .-kprint_U32x
	.globl	init_paging_system_provis
	.type	init_paging_system_provis, @function
init_paging_system_provis:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$16, %esp
	movl	$753664, -12(%ebp)
	xorl	%esi, %esi
	xorl	%ebx, %ebx
.L18:
	movl	%ebx, %edx
	sall	$12, %edx
	orl	$3, %edx
	movl	%edx, 327680(%esi)
	leal	1024(%ebx), %eax
	sall	$12, %eax
	orl	$3, %eax
	movl	%eax, 331776(%esi)
	pushl	%edx
	pushl	$ptx
	call	kprint_U32x
	movl	$0, 335872(%esi)
	incl	%ebx
	addl	$4, %esi
	popl	%eax
	popl	%edx
	cmpl	$1024, %ebx
	jne	.L18
	movl	$327683, 335872
	movl	$331779, 335876
	movl	$327683, 338944
	movl	$331779, 338948
	pushl	$327683
	pushl	$ptx
	call	kprint_U32x
	pushl	335876
	pushl	$ptx
	call	kprint_U32x
	pushl	338944
	pushl	$ptx
	call	kprint_U32x
	pushl	338948
	leal	-12(%ebp), %eax
	pushl	%eax
	call	kprint_U32x
	xorl	%eax, %eax
	leal	-8(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	init_paging_system_provis, .-init_paging_system_provis
	.globl	create_page_table_main
	.type	create_page_table_main, @function
create_page_table_main:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$16, %esp
	pushl	$4096
	call	malloc
	movl	%eax, %ebx
	addl	$12, %esp
	pushl	$4096
	pushl	$0
	pushl	%eax
	call	memset
	movl	%ebx, %eax
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	create_page_table_main, .-create_page_table_main
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"mem/paging.c"
.LC1:
	.string	"[Debug: %s:%d]"
.LC2:
	.string	"enter map_page vaddr = %08x, paddr = %08x\n"
	.text
	.globl	map_page
	.type	map_page, @function
map_page:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$12, %esp
	movl	8(%ebp), %ebx
	movl	12(%ebp), %esi
	cmpl	$-1073741825, %ebx
	ja	.L23
	pushl	%eax
	pushl	$127
	pushl	$.LC0
	pushl	$.LC1
	call	printf
	addl	$12, %esp
	pushl	%esi
	pushl	%ebx
	pushl	$.LC2
	call	printf
	addl	$16, %esp
.L23:
	movl	%ebx, %edi
	andl	$4190208, %edi
	shrl	$12, %edi
	shrl	$22, %ebx
	movl	16(%ebp), %eax
	leal	(%eax,%ebx,4), %ebx
	movl	(%ebx), %eax
	testl	%eax, %eax
	jne	.L24
	call	*create_page_table
	leal	1073741824(%eax), %edx
	andl	$-4096, %edx
	movl	20(%ebp), %ecx
	andl	$4095, %ecx
	orl	%ecx, %edx
	movl	%edx, (%ebx)
	jmp	.L25
.L24:
	andl	$-4096, %eax
	subl	$1073741824, %eax
.L25:
	andl	$-4096, %esi
	movl	20(%ebp), %edx
	andl	$4095, %edx
	orl	%edx, %esi
	movl	%esi, (%eax,%edi,4)
	xorl	%eax, %eax
	leal	-12(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	map_page, .-map_page
	.globl	init_paging_system
	.type	init_paging_system, @function
init_paging_system:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	movl	$create_page_table_init, create_page_table
	call	create_page_table_init
	movl	%eax, %esi
	pushl	%eax
	pushl	%eax
	pushl	%esi
	pushl	$ptx
	call	kprint_U32x
	addl	$16, %esp
	movl	$-1073741824, %ebx
.L29:
	pushl	$3
	pushl	%esi
	leal	1073741824(%ebx), %eax
	pushl	%eax
	pushl	%ebx
	call	map_page
	addl	$16, %esp
	addl	$4096, %ebx
	jne	.L29
	movl	%esi, page_dir_sys
	subl	$12, %esp
	addl	$1073741824, %esi
	pushl	%esi
	call	set_cr3
	xorl	%eax, %eax
	leal	-8(%ebp), %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	init_paging_system, .-init_paging_system
	.globl	make_page_directory
	.type	make_page_directory, @function
make_page_directory:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%ecx
	call	*create_page_table
	movl	12(%ebp), %edx
	movl	%eax, (%edx)
	xorl	%edx, %edx
.L33:
	movl	$0, (%eax,%edx,4)
	incl	%edx
	cmpl	$768, %edx
	jne	.L33
	movl	$-1073741824, %edx
.L35:
	movl	%edx, %ecx
	shrl	$22, %ecx
	movl	page_dir_sys, %ebx
	movl	(%ebx,%ecx,4), %ebx
	movl	%ebx, (%eax,%ecx,4)
	addl	$4096, %edx
	jne	.L35
	addl	$1073741824, %eax
	movl	8(%ebp), %edx
	movl	%eax, (%edx)
	xorl	%eax, %eax
	popl	%edx
	popl	%ebx
	popl	%ebp
	ret
	.size	make_page_directory, .-make_page_directory
	.globl	get_page_dir_entry
	.type	get_page_dir_entry, @function
get_page_dir_entry:
	pushl	%ebp
	movl	%esp, %ebp
	movl	12(%ebp), %edx
	movl	8(%ebp), %eax
	movl	-1073741824(%eax,%edx,4), %edx
	movl	16(%ebp), %eax
	movl	%edx, (%eax)
	popl	%ebp
	ret
	.size	get_page_dir_entry, .-get_page_dir_entry
	.section	.rodata.str1.1
.LC3:
	.string	"page fault = %d %d 0x%08x esp = 0x%08x cs = %08x\n"
	.text
	.globl	page_fault_handler
	.type	page_fault_handler, @function
page_fault_handler:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$28, %esp
#APP
# 240 "mem/paging.c" 1
	movl %esp, %eax
# 0 "" 2
# 242 "mem/paging.c" 1
	movl %cr2, %ebx
# 0 "" 2
# 110 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	movw %cs, %dx
# 0 "" 2
#NO_APP
	movzwl	%dx, %edx
	pushl	%edx
	pushl	%eax
	pushl	%ebx
	pushl	12(%ebp)
	pushl	8(%ebp)
	pushl	$.LC3
	call	printf
	addl	$20, %esp
	pushl	$4096
	call	malloc
#APP
# 96 "/home/juergen/osexperi/kernel/drivers/hardware.h" 1
	movl %cr3, %edx
# 0 "" 2
#NO_APP
	pushl	$7
	subl	$1073741824, %edx
	pushl	%edx
	addl	$1073741824, %eax
	pushl	%eax
	pushl	%ebx
	call	map_page
	addl	$32, %esp
	movl	$16777216, %eax
.L41:
	movl	$0, -12(%ebp)
	decl	%eax
	jne	.L41
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	page_fault_handler, .-page_fault_handler
	.data
	.align 4
	.type	ptx, @object
	.size	ptx, 4
ptx:
	.long	753664
	.comm	create_page_table,4,4
	.comm	page_dir_sys,4,4
	.comm	malloc_heads,60,4
	.comm	malloc_sizes_log,60,4
	.ident	"GCC: (GNU) 4.8.2 20140120 (Red Hat 4.8.2-15)"
	.section	.note.GNU-stack,"",@progbits
