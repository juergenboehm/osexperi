
			.section	.text
			.code16
			
			.globl		_startmain
			.globl	BOOT_SEG

#define		BOOT_SEG 0x0000
#define		LOADER_SEG 0x1000

#define		VGA_MEM_SEG		0xb800

#define		BIOS_READ_DISK	0x42
#define		DISK_CODE	0x80

#define	DISKBUF_SIZE	512

#define NUM_SEC_VAL 1
#define OFFSET_BUF_VAL 0x6000
#define DAPA_BLOCK_SIZE 16

#define START_SEC 1
#define NUM_SEC_TO_READ 17

			packetsize = 0
			always_zero = 1
			numsec = 2
			offset_buf = 4
			segment_buf = 6
			start_lba = 8
			start_lba_upper = 12


_startmain:

			jmp		$0x0, $startA

startA:

			cli

			movw	$(BOOT_SEG), %ax
			movw	%ax, %ds		// setting data segment to BOOT_SEG
			movw	%ax, %ss
			movw $0x7a00, %sp
			
			sti

			movw	$(LOADER_SEG), %ax
			movw	%ax, %es		// setting extra segment to LOADER_SEG, target of disk transfer


// init main loop
			movl	$START_SEC, %eax // set sector counter to 1
			movw	$0x0, %cx		// set loop counter sector read loop to 0
			movw	$0x0, %di		// destination counter. always incremented.
.loop:
			cmpw  $NUM_SEC_TO_READ, %cx
			je		.finish


			pushl	%eax
			pushw	%cx
			pushw	%di
			call	load_sec
			popw	%di

// transfer buffer
// first init everything
			movw	$OFFSET_BUF_VAL, %si
			movw	$0x0, %dx  // loop counter inner loop
.loop_transfer:
			cmpw	$DISKBUF_SIZE, %dx
			je		.done_inner
			movb	%ds:(%si), %al
			movb	%al, %es:(%di)
// now inc all counters
			inc		%si
			inc		%di
			inc		%dx
			jmp	.loop_transfer
.done_inner:
			call .print_char
			popw	%cx
			popl 	%eax
			inc		%cx 	// inc main loop counter
			inc		%eax	// inc sector counter
			jmp	.loop	

.finish:

			ljmp			$(LOADER_SEG), $0000


// print char

#define	OUT_CHAR	'A'

.print_char:		
			movb			$OUT_CHAR, %al
			movb 			$0x0e, %ah
			movb			$0x00, %bh
			movb			$0x0c, %bl
			int				$0x10
			ret
			

// param 1 %eax = lba_number

load_sec:
			call init_dapa
			movw $dapa, %si
			movb $BIOS_READ_DISK, %ah
			movb $DISK_CODE, %dl

// BIOS call should preserve all regs except explicit returns
// especially segment registers, especially %es

			int $0x13
			jc	load_sec
			ret

init_dapa:

			// param 1 %eax = lba_number


			movw	$dapa, %si
			movb	$DAPA_BLOCK_SIZE, (%si)
			movb	$0x00, always_zero(%si)
			movw	$NUM_SEC_VAL, numsec(%si)
			movw	$OFFSET_BUF_VAL, offset_buf(%si)
			movw	$BOOT_SEG, segment_buf(%si)
			movl	%eax, start_lba(%si)
			movl	$0x0, start_lba_upper(%si)
			ret

			.align		16
			.set sizetext, . - _startmain		

			
			.section	.data			
			.set datastart, .
dapa:
			.skip			16

sector:
			.long 0

			
termin_msg:
			.asciz			"loaderA terminated."	
						
			.set sizedata, . - datastart
	
	
			.skip 512 - sizetext - sizedata - 2
			
			.word 0xaa55
			
			
			
			

