	.file	"syscalls.c"
	.comm	global_in_de_hash_headers,2164,32
	.comm	global_in_de_lru_list,4,4
/APP
	.code16gcc	

/NO_APP
	.globl	syscall_list
	.data
	.align 32
	.type	syscall_list, @object
	.size	syscall_list, 104
syscall_list:
	.long	sys_open
	.long	2
	.long	sys_open_3
	.long	3
	.long	sys_creat
	.long	2
	.long	sys_unlink
	.long	1
	.long	sys_mkdir
	.long	2
	.long	sys_rmdir
	.long	1
	.long	sys_rename
	.long	2
	.long	sys_lseek
	.long	3
	.long	sys_read
	.long	3
	.long	sys_write
	.long	3
	.long	sys_register_handler
	.long	1
	.long	sys_fork
	.long	1
	.long	sys_close
	.long	1
	.text
	.globl	syscall_handler
	.type	syscall_handler, @function
syscall_handler:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$92, %esp
	movl	16(%ebp), %eax
	movl	28(%eax), %eax
	movl	%eax, -36(%ebp)
	movl	16(%ebp), %eax
	movl	24(%eax), %eax
	movl	%eax, -40(%ebp)
	movl	16(%ebp), %eax
	movl	20(%eax), %eax
	movl	%eax, -44(%ebp)
	movl	16(%ebp), %eax
	movl	16(%eax), %eax
	movl	%eax, -48(%ebp)
	movl	16(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, -52(%ebp)
	movl	16(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, -56(%ebp)
	movl	$0, -60(%ebp)
	movl	-36(%ebp), %eax
	movl	syscall_list(,%eax,8), %eax
	movl	%eax, -28(%ebp)
	movl	-36(%ebp), %eax
	movl	syscall_list+4(,%eax,8), %eax
	movl	%eax, -32(%ebp)
	cmpl	$5, -32(%ebp)
	ja	.L2
	movl	-32(%ebp), %eax
	sall	$2, %eax
	addl	$.L4, %eax
	movl	(%eax), %eax
	jmp	*%eax
	.section	.rodata
	.align 4
	.align 4
.L4:
	.long	.L2
	.long	.L3
	.long	.L5
	.long	.L6
	.long	.L7
	.long	.L8
	.text
.L3:
	movl	-28(%ebp), %eax
	movl	-40(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -60(%ebp)
	jmp	.L9
.L5:
	movl	-28(%ebp), %eax
	movl	-44(%ebp), %ecx
	movl	-40(%ebp), %edx
	movl	%ecx, 4(%esp)
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -60(%ebp)
	jmp	.L9
.L6:
	movl	-28(%ebp), %eax
	movl	-48(%ebp), %ebx
	movl	-44(%ebp), %ecx
	movl	-40(%ebp), %edx
	movl	%ebx, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -60(%ebp)
	jmp	.L9
.L7:
	movl	-28(%ebp), %eax
	movl	-52(%ebp), %esi
	movl	-48(%ebp), %ebx
	movl	-44(%ebp), %ecx
	movl	-40(%ebp), %edx
	movl	%esi, 12(%esp)
	movl	%ebx, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -60(%ebp)
	jmp	.L9
.L8:
	movl	-28(%ebp), %eax
	movl	-56(%ebp), %edi
	movl	-52(%ebp), %esi
	movl	-48(%ebp), %ebx
	movl	-44(%ebp), %ecx
	movl	-40(%ebp), %edx
	movl	%edi, 16(%esp)
	movl	%esi, 12(%esp)
	movl	%ebx, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -60(%ebp)
	jmp	.L9
.L2:
	movl	$-1, -60(%ebp)
	nop
.L9:
	movl	16(%ebp), %eax
	leal	28(%eax), %edx
	movl	-60(%ebp), %eax
	movl	%eax, (%edx)
	movl	16(%ebp), %eax
	movl	%eax, (%esp)
	call	process_signals
	addl	$92, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	syscall_handler, .-syscall_handler
	.globl	sys_open
	.type	sys_open, @function
sys_open:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$-1, -12(%ebp)
	movl	$0, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	sys_open_3
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	leave
	ret
	.size	sys_open, .-sys_open
	.section	.rodata
.LC0:
	.string	"enter: sys_open\n"
	.align 4
.LC1:
	.string	"sys_open:pathname = >%s< flags = %d\n"
.LC2:
	.string	"inode found = %d\n"
	.text
	.globl	sys_open_3
	.type	sys_open_3, @function
sys_open_3:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$136, %esp
	movl	$-1, -12(%ebp)
	movl	$.LC0, (%esp)
	call	outb_printf
	movl	$0, -40(%ebp)
	movl	$255, (%esp)
	call	malloc
	movl	%eax, -20(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC1, (%esp)
	call	outb_printf
	movl	12(%ebp), %eax
	andl	$3, %eax
	testl	%eax, %eax
	je	.L13
	movl	global_root_dentry, %eax
	movl	-20(%ebp), %edx
	movl	%edx, 16(%esp)
	leal	-40(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	8(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	$1, 4(%esp)
	movl	%eax, (%esp)
	call	get_parse_path
	movl	-20(%ebp), %eax
	movl	%eax, -96(%ebp)
	movl	-40(%ebp), %eax
	movl	40(%eax), %eax
	movl	%eax, -24(%ebp)
	leal	-96(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	gen_lookup
	movl	%eax, -28(%ebp)
	cmpl	$0, -28(%ebp)
	je	.L14
	movl	12(%ebp), %eax
	andl	$64, %eax
	testl	%eax, %eax
	je	.L15
	movl	12(%ebp), %eax
	andl	$128, %eax
	testl	%eax, %eax
	je	.L15
	movl	$-1, -12(%ebp)
	jmp	.L20
.L15:
	movl	-28(%ebp), %eax
	movl	%eax, -40(%ebp)
	jmp	.L17
.L14:
	movl	12(%ebp), %eax
	andl	$64, %eax
	testl	%eax, %eax
	je	.L17
	movl	-24(%ebp), %eax
	movl	36(%eax), %eax
	movl	(%eax), %eax
	movl	16(%ebp), %edx
	movl	%edx, 8(%esp)
	leal	-96(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	-24(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jns	.L18
	jmp	.L20
.L18:
	leal	-96(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	gen_lookup
	movl	%eax, -40(%ebp)
	movl	-40(%ebp), %eax
	testl	%eax, %eax
	jne	.L17
	nop
	jmp	.L20
.L17:
	jmp	.L19
.L13:
	movl	12(%ebp), %eax
	andl	$3, %eax
	testl	%eax, %eax
	jne	.L19
	movl	global_root_dentry, %eax
	movl	-20(%ebp), %edx
	movl	%edx, 16(%esp)
	leal	-40(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	8(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	get_parse_path
	movl	-40(%ebp), %eax
	testl	%eax, %eax
	jne	.L19
	jmp	.L20
.L19:
	movl	-40(%ebp), %eax
	movl	40(%eax), %eax
	movl	72(%eax), %eax
	movl	%eax, -32(%ebp)
	movl	-32(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC2, (%esp)
	call	outb_printf
	call	get_file_t
	movl	%eax, -36(%ebp)
	movl	-36(%ebp), %eax
	movl	$0, 4(%eax)
	movl	$0, 8(%eax)
	movl	-40(%ebp), %edx
	movl	-36(%ebp), %eax
	movl	%edx, 12(%eax)
	movl	-40(%ebp), %eax
	movl	40(%eax), %eax
	movl	40(%eax), %edx
	movl	-36(%ebp), %eax
	movl	%edx, 16(%eax)
	movl	12(%ebp), %edx
	movl	-36(%ebp), %eax
	movl	%edx, 20(%eax)
	movl	-40(%ebp), %eax
	movl	52(%eax), %edx
	addl	$1, %edx
	movl	%edx, 52(%eax)
	movl	$0, -16(%ebp)
	jmp	.L21
.L23:
	movl	current, %eax
	movl	108(%eax), %eax
	movl	-16(%ebp), %edx
	movl	(%eax,%edx,4), %eax
	testl	%eax, %eax
	jne	.L22
	movl	current, %eax
	movl	108(%eax), %eax
	movl	-16(%ebp), %edx
	movl	-36(%ebp), %ecx
	movl	%ecx, (%eax,%edx,4)
	movl	-16(%ebp), %eax
	movl	%eax, -12(%ebp)
	jmp	.L20
.L22:
	addl	$1, -16(%ebp)
.L21:
	cmpl	$15, -16(%ebp)
	jle	.L23
.L20:
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	free
	movl	-12(%ebp), %eax
	leave
	ret
	.size	sys_open_3, .-sys_open_3
	.globl	sys_creat
	.type	sys_creat, @function
sys_creat:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$-1, %eax
	popl	%ebp
	ret
	.size	sys_creat, .-sys_creat
	.globl	sys_unlink
	.type	sys_unlink, @function
sys_unlink:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$-1, %eax
	popl	%ebp
	ret
	.size	sys_unlink, .-sys_unlink
	.globl	sys_mkdir
	.type	sys_mkdir, @function
sys_mkdir:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$-1, %eax
	popl	%ebp
	ret
	.size	sys_mkdir, .-sys_mkdir
	.globl	sys_rmdir
	.type	sys_rmdir, @function
sys_rmdir:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$-1, %eax
	popl	%ebp
	ret
	.size	sys_rmdir, .-sys_rmdir
	.globl	sys_rename
	.type	sys_rename, @function
sys_rename:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$-1, %eax
	popl	%ebp
	ret
	.size	sys_rename, .-sys_rename
	.globl	sys_lseek
	.type	sys_lseek, @function
sys_lseek:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$-1, %eax
	popl	%ebp
	ret
	.size	sys_lseek, .-sys_lseek
	.globl	sys_read
	.type	sys_read, @function
sys_read:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	current, %eax
	movl	108(%eax), %eax
	movl	8(%ebp), %edx
	movl	(%eax,%edx,4), %eax
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	je	.L38
	movl	-16(%ebp), %eax
	movl	16(%eax), %eax
	movl	4(%eax), %eax
	testl	%eax, %eax
	je	.L39
	movl	-16(%ebp), %eax
	movl	16(%eax), %eax
	movl	4(%eax), %eax
	movl	$0, 12(%esp)
	movl	16(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	-16(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -12(%ebp)
	jmp	.L41
.L39:
	movl	$-1, -12(%ebp)
	jmp	.L41
.L38:
	movl	$-1, -12(%ebp)
.L41:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	sys_read, .-sys_read
	.globl	sys_write
	.type	sys_write, @function
sys_write:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	current, %eax
	movl	108(%eax), %eax
	movl	8(%ebp), %edx
	movl	(%eax,%edx,4), %eax
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	je	.L44
	movl	-16(%ebp), %eax
	movl	16(%eax), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L45
	movl	-16(%ebp), %eax
	movl	16(%eax), %eax
	movl	8(%eax), %eax
	movl	$0, 12(%esp)
	movl	16(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	-16(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -12(%ebp)
	jmp	.L47
.L45:
	movl	$-1, -12(%ebp)
	jmp	.L47
.L44:
	movl	$-1, -12(%ebp)
.L47:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	sys_write, .-sys_write
	.section	.rodata
	.align 4
.LC3:
	.string	"sys_register_handler: registered = %08x\n"
	.text
	.globl	sys_register_handler
	.type	sys_register_handler, @function
sys_register_handler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	current, %eax
	movl	8(%ebp), %edx
	movl	%edx, 124(%eax)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC3, (%esp)
	call	outb_printf
	movl	$0, %eax
	leave
	ret
	.size	sys_register_handler, .-sys_register_handler
	.globl	sys_fork
	.type	sys_fork, @function
sys_fork:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	call	fork_process
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	leave
	ret
	.size	sys_fork, .-sys_fork
	.globl	sys_close
	.type	sys_close, @function
sys_close:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$-1, %eax
	popl	%ebp
	ret
	.size	sys_close, .-sys_close
	.ident	"GCC: (GNU) 4.8.2"
