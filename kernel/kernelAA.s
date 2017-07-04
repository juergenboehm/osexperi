
			.section	.text
			.code32
			
			.globl		_startmainB

_startmainB:

			ljmp				$0x0000, $startB

startB:

			cli
			
		  mov 			$0x0000, %eax
   		mov 			%eax, %ss
			
   		mov 			$0x2000, %esp

			mov				$0x0000, %eax
			mov				%eax, %ds
			
			mov				$0x0000, %eax
			mov				%eax, %es
			
			sti
						
			mov				$(0xb8000+ 0x20), %edi

			mov				$trystr, %esi

loop:
			movb			%ds:(%esi), %al
			cmp				$0x00, %al
			jz				halt
			movb			%al, %es:(%edi)
			inc				%edi
			movb			$0x1e, %es:(%edi)
			inc				%edi
			inc				%esi
			jmp				loop
			
halt:
			jmp				halt



			.align		16
			.set sizetext, . - _startmainB		

			
			.section	.data
			.set datastart, .
			
trystr:
			.asciz			"kernelB"			
						
			.set sizedata, . - datastart
	
	
			.set skipsize, 512 - sizetext - sizedata
			.skip skipsize
