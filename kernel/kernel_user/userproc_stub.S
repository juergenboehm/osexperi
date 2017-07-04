
#include "libs/kerneldefs.h"

		.code32
		.text
		.globl uproc_1
		.globl entry_uproc_1

entry_uproc_1:

repeat:
		movb $'Z', %al
		outb %al, $0xe9
		call uproc_1
		movl $0x1000000, %eax
loop:
		decl %eax
		jne loop
		jmp repeat
