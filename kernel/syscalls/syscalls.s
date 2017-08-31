	.file	"syscalls.c"
	.comm	global_in_de_hash_headers,2164,32
	.comm	global_in_de_lru_list,4,4
	.comm	global_ino_hash_headers,2164,32
	.comm	malloc_sizes_log,60,32
	.comm	malloc_heads,60,32
/APP
	.code16gcc	

/NO_APP
	.globl	syscall_list
	.data
	.align 32
	.type	syscall_list, @object
	.size	syscall_list, 120
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
	.long	sys_chdir
	.long	1
	.long	sys_readdir
	.long	2
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
	.string	"sys_open_3: inode found = %d\n"
	.text
	.globl	sys_open_3
	.type	sys_open_3, @function
sys_open_3:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$152, %esp
	movl	$-1, -12(%ebp)
	movl	$255, (%esp)
	call	malloc
	movl	%eax, -24(%ebp)
	movl	$.LC0, (%esp)
	call	outb_printf
	movl	$-1, -20(%ebp)
	movl	$0, -16(%ebp)
	jmp	.L13
.L16:
	movl	current, %eax
	movl	108(%eax), %eax
	movl	-16(%ebp), %edx
	movl	8(%eax,%edx,4), %eax
	testl	%eax, %eax
	jne	.L14
	movl	-16(%ebp), %eax
	movl	%eax, -20(%ebp)
	jmp	.L15
.L14:
	addl	$1, -16(%ebp)
.L13:
	cmpl	$15, -16(%ebp)
	jle	.L16
.L15:
	cmpl	$0, -20(%ebp)
	jns	.L17
	movl	$-1, -12(%ebp)
	jmp	.L18
.L17:
	movl	current, %eax
	movl	108(%eax), %eax
	movl	(%eax), %eax
	movl	%eax, -28(%ebp)
	movl	current, %eax
	movl	108(%eax), %eax
	movl	4(%eax), %eax
	movl	%eax, -32(%ebp)
	movl	$0, -60(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC1, (%esp)
	call	outb_printf
	movl	12(%ebp), %eax
	andl	$3, %eax
	testl	%eax, %eax
	je	.L19
	movl	-24(%ebp), %eax
	movl	%eax, 20(%esp)
	leal	-60(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$1, 8(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	get_parse_path
	movl	%eax, -36(%ebp)
	cmpl	$0, -36(%ebp)
	jns	.L20
	movl	$-1, -12(%ebp)
	jmp	.L18
.L20:
	movl	-24(%ebp), %eax
	movl	%eax, -120(%ebp)
	movl	-60(%ebp), %eax
	movl	44(%eax), %eax
	movl	%eax, -40(%ebp)
	leal	-120(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	gen_lookup
	movl	%eax, -44(%ebp)
	cmpl	$0, -44(%ebp)
	je	.L22
	movl	12(%ebp), %eax
	andl	$64, %eax
	testl	%eax, %eax
	je	.L23
	movl	12(%ebp), %eax
	andl	$128, %eax
	testl	%eax, %eax
	je	.L23
	movl	$-1, -12(%ebp)
	jmp	.L18
.L23:
	movl	-44(%ebp), %eax
	movl	%eax, -60(%ebp)
	jmp	.L24
.L22:
	movl	12(%ebp), %eax
	andl	$64, %eax
	testl	%eax, %eax
	je	.L24
	movl	-40(%ebp), %eax
	movl	36(%eax), %eax
	movl	(%eax), %eax
	movl	16(%ebp), %edx
	movl	%edx, 8(%esp)
	leal	-120(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	-40(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jns	.L25
	movl	$-1, -12(%ebp)
	jmp	.L18
.L25:
	leal	-120(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	gen_lookup
	movl	%eax, -60(%ebp)
	movl	-60(%ebp), %eax
	testl	%eax, %eax
	jne	.L24
	movl	$-1, -12(%ebp)
	nop
	jmp	.L18
.L24:
	jmp	.L26
.L19:
	movl	12(%ebp), %eax
	andl	$3, %eax
	testl	%eax, %eax
	jne	.L26
	movl	-24(%ebp), %eax
	movl	%eax, 20(%esp)
	leal	-60(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$0, 8(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	get_parse_path
	movl	%eax, -48(%ebp)
	cmpl	$0, -48(%ebp)
	jns	.L27
	movl	$-1, -12(%ebp)
	jmp	.L18
.L27:
	movl	-60(%ebp), %eax
	testl	%eax, %eax
	jne	.L26
	movl	$-1, -12(%ebp)
	jmp	.L18
.L26:
	movl	-60(%ebp), %eax
	movl	44(%eax), %eax
	movl	84(%eax), %eax
	movl	%eax, -52(%ebp)
	movl	-52(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$.LC2, (%esp)
	call	outb_printf
	call	get_file_t
	movl	%eax, -56(%ebp)
	movl	-56(%ebp), %eax
	movl	$0, 4(%eax)
	movl	$0, 8(%eax)
	movl	-60(%ebp), %eax
	movl	-56(%ebp), %edx
	addl	$12, %edx
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	link_dentry_t
	movl	-60(%ebp), %eax
	movl	44(%eax), %eax
	movl	40(%eax), %edx
	movl	-56(%ebp), %eax
	movl	%edx, 16(%eax)
	movl	12(%ebp), %edx
	movl	-56(%ebp), %eax
	movl	%edx, 20(%eax)
	movl	current, %eax
	movl	108(%eax), %eax
	movl	-20(%ebp), %edx
	sall	$2, %edx
	addl	%edx, %eax
	leal	8(%eax), %edx
	movl	-56(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	link_file_t
	movl	-20(%ebp), %eax
	movl	%eax, -12(%ebp)
.L18:
	movl	-24(%ebp), %eax
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
	subl	$136, %esp
	movl	$-1, -12(%ebp)
	movl	$255, (%esp)
	call	malloc
	movl	%eax, -16(%ebp)
	movl	current, %eax
	movl	108(%eax), %eax
	movl	(%eax), %eax
	movl	%eax, -20(%ebp)
	movl	current, %eax
	movl	108(%eax), %eax
	movl	4(%eax), %eax
	movl	%eax, -24(%ebp)
	movl	$0, -36(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, 20(%esp)
	leal	-36(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$1, 8(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	get_parse_path
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	js	.L32
	movl	-36(%ebp), %eax
	testl	%eax, %eax
	je	.L32
	movl	-36(%ebp), %eax
	movl	44(%eax), %eax
	movl	%eax, -28(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, -96(%ebp)
	leal	-96(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	gen_lookup
	movl	%eax, -32(%ebp)
	cmpl	$0, -32(%ebp)
	jne	.L33
	movl	$-1, -12(%ebp)
	jmp	.L32
.L33:
	movl	-32(%ebp), %eax
	movl	56(%eax), %eax
	testl	%eax, %eax
	je	.L34
	movl	$-1, -12(%ebp)
	jmp	.L32
.L34:
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	delete_in_de_hash_elem
	movl	-28(%ebp), %eax
	movl	36(%eax), %eax
	movl	8(%eax), %eax
	leal	-96(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	-28(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jns	.L35
	jmp	.L32
.L35:
	movl	$0, -12(%ebp)
.L32:
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	free
	movl	-12(%ebp), %eax
	leave
	ret
	.size	sys_unlink, .-sys_unlink
	.globl	sys_mkdir
	.type	sys_mkdir, @function
sys_mkdir:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$136, %esp
	movl	$-1, -12(%ebp)
	movl	$255, (%esp)
	call	malloc
	movl	%eax, -16(%ebp)
	movl	current, %eax
	movl	108(%eax), %eax
	movl	(%eax), %eax
	movl	%eax, -20(%ebp)
	movl	current, %eax
	movl	108(%eax), %eax
	movl	4(%eax), %eax
	movl	%eax, -24(%ebp)
	movl	$0, -32(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, 20(%esp)
	leal	-32(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$1, 8(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	get_parse_path
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	js	.L38
	movl	-32(%ebp), %eax
	testl	%eax, %eax
	je	.L38
	movl	-32(%ebp), %eax
	movl	44(%eax), %eax
	movl	%eax, -28(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, -92(%ebp)
	movl	-28(%ebp), %eax
	movl	36(%eax), %eax
	movl	12(%eax), %eax
	movl	12(%ebp), %edx
	movl	%edx, 8(%esp)
	leal	-92(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	-28(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jns	.L39
	jmp	.L38
.L39:
	movl	$0, -12(%ebp)
.L38:
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	free
	movl	-12(%ebp), %eax
	leave
	ret
	.size	sys_mkdir, .-sys_mkdir
	.section	.rodata
.LC3:
	.string	"."
.LC4:
	.string	"syscalls/syscalls.c"
.LC5:
	.string	"[Debug: %s:%d]"
.LC6:
	.string	" failed"
.LC7:
	.string	"dot_dentry == 0 && 1"
.LC8:
	.string	"%s %s\n"
.LC9:
	.string	".."
.LC10:
	.string	"dot_dentry == 0 && 2"
	.text
	.globl	sys_rmdir
	.type	sys_rmdir, @function
sys_rmdir:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$200, %esp
	movl	$-1, -12(%ebp)
	movl	$255, (%esp)
	call	malloc
	movl	%eax, -16(%ebp)
	movl	current, %eax
	movl	108(%eax), %eax
	movl	(%eax), %eax
	movl	%eax, -20(%ebp)
	movl	current, %eax
	movl	108(%eax), %eax
	movl	4(%eax), %eax
	movl	%eax, -24(%ebp)
	movl	$0, -40(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, 20(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$1, 8(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	get_parse_path
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	js	.L42
	movl	-40(%ebp), %eax
	testl	%eax, %eax
	je	.L42
	movl	-40(%ebp), %eax
	movl	44(%eax), %eax
	movl	%eax, -28(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, -100(%ebp)
	leal	-100(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	gen_lookup
	movl	%eax, -32(%ebp)
	cmpl	$0, -32(%ebp)
	jne	.L43
	movl	$-1, -12(%ebp)
	jmp	.L42
.L43:
	movl	-32(%ebp), %eax
	movl	56(%eax), %eax
	testl	%eax, %eax
	je	.L44
	movl	$-1, -12(%ebp)
	jmp	.L42
.L44:
	movl	$.LC3, -160(%ebp)
	movl	-32(%ebp), %eax
	movl	44(%eax), %eax
	leal	-160(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	gen_lookup
	movl	%eax, -36(%ebp)
	cmpl	$0, -36(%ebp)
	jne	.L45
	cmpl	$0, -36(%ebp)
	je	.L45
	movl	$400, 8(%esp)
	movl	$.LC4, 4(%esp)
	movl	$.LC5, (%esp)
	call	printf
	movl	$.LC6, 8(%esp)
	movl	$.LC7, 4(%esp)
	movl	$.LC8, (%esp)
	call	printf
.L46:
	jmp	.L46
.L45:
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	delete_in_de_hash_elem
	movl	$.LC9, -160(%ebp)
	movl	-32(%ebp), %eax
	movl	44(%eax), %eax
	leal	-160(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	gen_lookup
	movl	%eax, -36(%ebp)
	cmpl	$0, -36(%ebp)
	jne	.L47
	cmpl	$0, -36(%ebp)
	je	.L47
	movl	$414, 8(%esp)
	movl	$.LC4, 4(%esp)
	movl	$.LC5, (%esp)
	call	printf
	movl	$.LC6, 8(%esp)
	movl	$.LC10, 4(%esp)
	movl	$.LC8, (%esp)
	call	printf
.L48:
	jmp	.L48
.L47:
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	delete_in_de_hash_elem
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	delete_in_de_hash_elem
	movl	-28(%ebp), %eax
	movl	36(%eax), %eax
	movl	16(%eax), %eax
	leal	-100(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	-28(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jns	.L49
	jmp	.L42
.L49:
	movl	$0, -12(%ebp)
.L42:
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	free
	movl	-12(%ebp), %eax
	leave
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
	movl	8(%eax,%edx,4), %eax
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	je	.L56
	movl	-16(%ebp), %eax
	movl	16(%eax), %eax
	movl	4(%eax), %eax
	testl	%eax, %eax
	je	.L57
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
	jmp	.L59
.L57:
	movl	$-1, -12(%ebp)
	jmp	.L59
.L56:
	movl	$-1, -12(%ebp)
.L59:
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
	movl	8(%eax,%edx,4), %eax
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	je	.L62
	movl	-16(%ebp), %eax
	movl	16(%eax), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L63
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
	jmp	.L65
.L63:
	movl	$-1, -12(%ebp)
	jmp	.L65
.L62:
	movl	$-1, -12(%ebp)
.L65:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	sys_write, .-sys_write
	.section	.rodata
	.align 4
.LC11:
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
	movl	$.LC11, (%esp)
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
	subl	$40, %esp
	movl	$-1, -12(%ebp)
	movl	current, %eax
	movl	108(%eax), %eax
	movl	8(%ebp), %edx
	movl	8(%eax,%edx,4), %eax
	testl	%eax, %eax
	jne	.L72
	jmp	.L73
.L72:
	movl	current, %eax
	movl	108(%eax), %eax
	movl	8(%ebp), %edx
	movl	8(%eax,%edx,4), %eax
	movl	12(%eax), %eax
	movl	%eax, (%esp)
	call	unlink_dentry_t
	movl	current, %eax
	movl	108(%eax), %eax
	movl	8(%ebp), %edx
	movl	8(%eax,%edx,4), %eax
	movl	%eax, (%esp)
	call	unlink_file_t
	movl	current, %eax
	movl	108(%eax), %eax
	movl	8(%ebp), %edx
	movl	$0, 8(%eax,%edx,4)
	movl	$0, -12(%ebp)
.L73:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	sys_close, .-sys_close
	.globl	sys_chdir
	.type	sys_chdir, @function
sys_chdir:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$72, %esp
	movl	$-1, -12(%ebp)
	movl	$255, (%esp)
	call	malloc
	movl	%eax, -16(%ebp)
	movl	current, %eax
	movl	108(%eax), %eax
	movl	(%eax), %eax
	movl	%eax, -20(%ebp)
	movl	current, %eax
	movl	108(%eax), %eax
	movl	4(%eax), %eax
	movl	%eax, -24(%ebp)
	movl	$0, -28(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, 20(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$0, 8(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	get_parse_path
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	js	.L76
	movl	-28(%ebp), %eax
	testl	%eax, %eax
	je	.L76
	movl	current, %eax
	movl	108(%eax), %eax
	movl	4(%eax), %eax
	movl	%eax, (%esp)
	call	unlink_dentry_t
	movl	-28(%ebp), %eax
	movl	current, %edx
	movl	108(%edx), %edx
	addl	$4, %edx
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	link_dentry_t
.L76:
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	free
	movl	-12(%ebp), %eax
	leave
	ret
	.size	sys_chdir, .-sys_chdir
	.globl	sys_readdir
	.type	sys_readdir, @function
sys_readdir:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$-1, -12(%ebp)
	movl	current, %eax
	movl	108(%eax), %eax
	movl	8(%ebp), %edx
	movl	8(%eax,%edx,4), %eax
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	jne	.L79
	jmp	.L80
.L79:
	movl	-16(%ebp), %eax
	movl	16(%eax), %eax
	movl	24(%eax), %eax
	movl	$0, 8(%esp)
	movl	12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	-16(%ebp), %edx
	movl	%edx, (%esp)
	call	*%eax
	movl	%eax, -12(%ebp)
.L80:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	sys_readdir, .-sys_readdir
	.ident	"GCC: (GNU) 4.8.2"
