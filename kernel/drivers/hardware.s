	.file	"hardware.c"
	.text
.globl set_cr3
	.type	set_cr3, @function
set_cr3:
	pushl	%ebp
	movl	%esp, %ebp
#APP
# 7 "drivers/hardware.c" 1
	mov 8(%ebp), %eax 
	 mov %eax, %cr3 
	 .L99999: jmp 1f 
	 1: 
	 nop 
	
# 0 "" 2
#NO_APP
	popl	%ebp
	ret
	.size	set_cr3, .-set_cr3
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5.1) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
