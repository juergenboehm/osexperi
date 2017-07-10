
#include "libs/kerneldefs.h"

		.code32
		.text
		.globl irq_main
		.globl irq_no_errcode


// the stack is as follows when privilege escalation interrupt
// is done:
// 20 bytes IRQ return block (of privilege escalation type)
// 36 bytes data pushed from the following code:
// first 0/errcode then eax, ebx, ecx, edx, esi, edi, ebp, ds/es
// 12 bytes for the three word parameters of irq_dispatcher
// after call to irq_dispatcher:
// 8 bytes: first return address, then ebp pushed on stack by irq_dispatcher

		.align	IRQ_JUMP_TABLE_ALIGN

irq_no_errcode:

		.set cnt, 0
		.rept	256
		pushl	$0x0
		jmp		irq_main+cnt
		.align	IRQ_JUMP_TABLE_ALIGN
		.set	cnt, cnt + IRQ_JUMP_TABLE_ALIGN
		.endr



irq_main:

		.set 		cnt, 0
		.rept		256
		pushl		%eax
		movl		$cnt, %eax
		jmp			dispatch
		.align	IRQ_JUMP_TABLE_ALIGN
		.set		cnt, cnt + 1
		.endr


dispatch:
		pushl	%ebx
		pushl	%ecx
		pushl	%edx
		pushl	%esi
		pushl	%edi
		pushl	%ebp
		pushw	%ds
		pushw	%es

		pushl	%esp	// push esp, last argument of c function

		pushl	%eax	// push cnt, second argument of c function
		movl	40(%esp), %ebx
		pushl	%ebx	// push errcode, last pushed is first argument of c function
		movw	$KERNEL32_DS, %ax
		movw	%ax, %ds
		movw	%ax, %es
		call	irq_dispatcher
		add		$0x0c, %esp  // undo effects of pushl esp; pushl eax; pushl ebx (caller cleanup)

		popw	%es
		popw	%ds
		popl 	%ebp
		popl	%edi
		popl	%esi
		popl	%edx
		popl	%ecx
		popl	%ebx
		popl	%eax
		addl	$0x04, %esp // skip errcode
		iret

