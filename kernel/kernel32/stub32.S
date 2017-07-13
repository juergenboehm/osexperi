
#include "libs/kerneldefs.h"

	.code32
	.text

//	ljmp $KERNEL32_CS, $next

next:


	mov 	$KERNEL32_DS, %ax
	mov 	%ax, %ds
	mov 	%ax, %es
	mov 	%ax, %fs
	mov 	%ax, %gs
	mov 	%ax, %ss
	movl 	$KERNEL_STACK_PROVIS, %esp


/*

	print a lot (0x100) of 'B' = 0x66
	yellow on blue = 0x1e
	to show we are here

	we don't need this at the moment

*/


/*

	movl 	$(0xb8000), %edi
	movl 	$0x100, %ecx

loop:

	movb 	$66, %ds:(%edi)
	inc 	%edi
	movb 	$0x1e, %ds:(%edi)
	inc 	%edi
	dec 	%ecx
	cmp 	$0, %ecx
	jne 	loop

*/

	movl 	$(0xb8000), %edi
	movb 	$'Q', %ds:(%edi)				// write a 'Q'
	inc 	%edi
	movb 	$0x1e, %ds:(%edi)
	inc 	%edi

	calll 	init_paging_system_provis

	movl 	$(0xb8000), %edi
	movb 	$'R', %ds:(%edi)				// write a 'R'
	inc 	%edi
	movb 	$0x1e, %ds:(%edi)
	inc 	%edi



#define PG_PAGE_DIR_START_ADDR		0x52000

// start paging

	movl	$(PG_PAGE_DIR_START_ADDR), %eax
	movl	%eax, %cr3
	movl	%cr0, %eax
	orl 	$0x80000000, %eax
	movl	%eax, %cr0

	ljmp	$0x20, $(flush)

flush:

	nop
	nop
	nop
	nop

	// 2048 pages above KERNEL_UPPER
	movl 	$(0x800000 +  KERNEL_UPPER), %esp
	//movl 	$(0x512000 +  KERNEL_UPPER), %esp



	movl 	$(0xb8000), %edi
	movb 	$'S', %ds:(%edi)				// write a 'S'
	inc 	%edi
	movb 	$0x1e, %ds:(%edi)
	inc 	%edi


	calll 	kmain32

halt:
	jmp halt


