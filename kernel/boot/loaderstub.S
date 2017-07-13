
			.section	.text
			.code16

			.globl		_startmain
			.globl	KERNEL16_SEGMENT

			#define		KERNEL16_SEG	0x2000
			#define		LOADER16_SEG	0x1000

			#define		VGA_MEM_SEG		0xb800

_startmain:

startA:

			cli

			movw			$LOADER16_SEG, %ax
			movw			%ax, %ds

 	  		movw 			%ax, %ss
			movw 			$0x8000, %sp

			sti

      // print 'C'
			movb			$67, %al
			movb 			$0x0e, %ah
			movb			$0x00, %bh
			movb			$0x0c, %bl
			int				$0x10

#				movb 			$0x00, %ah
#				movb 			$0x03, %al
#				int 			$0x10

      // print 'D'
			movb			$68, %al
			movb 			$0x0e, %ah
			movb			$0x00, %bh
			movb			$0x0c, %bl
			int				$0x10

			movw			$VGA_MEM_SEG, %ax	# address of VGA mem: 0xb8000
			movw			%ax, %es


			call			lmain


			xor				%di, %di
			movw			$termin_str, %si

loop:
			movb			%ds:(%si), %al
			cmpb			$0x00, %al
			jz				ende
			call			putc
			movb			%ds:(%si), %al
			movb			%al, %es:(%di)
			inc				%di
			movb			$0x1e, %es:(%di)
			inc				%di
			inc				%si
			jmp				loop

ende:
//	        jmp ende

halt:

			ljmp			$(KERNEL16_SEG), $0000

putc:
			movb 			$0x0e, %ah
			movb			$0x00, %bh
			movb			$0x0c, %bl
			int				$0x10
			ret


			.align		16
			.set sizetext, . - _startmain


			.section	.data
			.set datastart, .

termin_str:
			.asciz			"loaderA terminated."

			.set sizedata, . - datastart


#			.set skipsize, 512 - sizetext - sizedata
#			.skip skipsize
