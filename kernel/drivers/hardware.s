	.file	"hardware.c"
	.text
	.globl	set_cr3
	.type	set_cr3, @function
set_cr3:
	pushl	%ebp
	movl	%esp, %ebp
#APP
# 13 "drivers/hardware.c" 1
	movl 8(%ebp), %eax 
	 movl %eax, %cr3 
	
# 0 "" 2
#NO_APP
	popl	%ebp
	ret
	.size	set_cr3, .-set_cr3
	.ident	"GCC: (GNU) 4.8.2 20140120 (Red Hat 4.8.2-15)"
	.section	.note.GNU-stack,"",@progbits
