
#include "libs/kerneldefs.h"

	.text
	.code16
	.globl	kmain
	.globl	entry16


entry16:


	movw		$(KERNEL16_SEG), %ax
	movw		%ax, %ds

// very important that %ss and %ds are equal

	movw		%ax, %ss
	movw		$(KERNEL16_SP), %sp

	call		kmain

	cli

// write a character 'B' yellow on blue
// at first screen position

	movw		$VGA_SEG, %ax
	movw	 	%ax, %es

	xor 		%di, %di
	movb 		$66, %es:(%di)
	inc 		%di
	movb 		$0x1e, %es:(%di)


// switch to protected mode

	movl	 	%cr0, %eax
	orb			$0x1, %al

	movl 		%eax, %cr0


// the following is a trick to do a full 16:32
// ljmp  $0x20, $val
// although being in 16 bit mode for ip
// prefix 0x66 loads full eip with $val, not just ip

// 0x20 is index of KERNEL_32_KERNEL_CS in the provisional GDT table.
// The entry describes a 4G memory area, starting with 0x00000000

	.byte		0x66, 0xea
	.long		(KERNEL16_SEG << 4) + low32
	.word		KERNEL32_CS

	.code32
	.align	8

low32:


	movw		$0x28, %ax
	movw		%ax, %ds
	movw		%ax, %es
	movw		%ax, %fs
	movw		%ax, %gs
	movw		%ax, %ss
	movl		$KERNEL_STACK_PROVIS, %esp


// move kernel in extmem down by len16.

#define LEN16_OFFSET 4
#define LEN32_OFFSET 8

	movl		(KERNEL16_SEG << 4) + LEN16_OFFSET, %edx // set %edx to len16.

	movl		$KERNEL_32_START, %eax
	addl		%edx, %eax
	movl		%eax, %esi  // KERNEL_32_START + len16 is first source index.

	movl		$KERNEL_32_START, %edi // KERNEL_32_START is first destination index.

	movl		(KERNEL16_SEG << 4) + LEN32_OFFSET, %ecx // set %ecx to len32. This is the number of bytes to be moved.

1:
	movb		(%esi), %al
	movb		%al, (%edi)
	inc			%esi
	inc			%edi
	dec			%ecx
	cmpl		$0, %ecx
	jne			1b

//2:
//	jmp			2b

	ljmp		$0x20, $0x100000
