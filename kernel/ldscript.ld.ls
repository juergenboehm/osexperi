TARGET(elf32-i386)
OUTPUT_FORMAT(binary)
phys1  = 0x00000000;
logic1 = 0x00000000;
offset = 0x00010000;

SECTIONS
{

			 	. = logic1;
       
			 	.text1 : AT(phys1)
			 	{ 
			 		code1 = .;
					*.o(.text)
					code1end = ALIGN(.,16);
				}
				
				lencode1 = code1end - code1;
				
																
				. = logic1 + lencode1;
									
       .data1 : AT(phys1 + lencode1)
			  { 
					data1 = .;
					*.o(.data)
					data1end = ALIGN(., 16);
				}
				
				lendata1 = data1end - data1;
				
								
			 . = logic1 + lencode1 + lendata1;

       .bss1 : AT(phys1 + lencode1 + lendata1)
			 {
			 		bss1 = .; 
			 		*.o(.bss)
					*.o(COMMON)
			 		bss1end = ALIGN(., 16);
			 }
			 
			 lenbss1 = bss1end - bss1;
			 
			 . = logic1 + lencode1 + lendata1 + lenbss1;
			 
			 .rodata1 : AT(phys1 + lencode1 + lendata1 + lenbss1)
			 {
			 		rodata1 = .;
					*.o(.rodata*)
			 		rodata1end = ALIGN(., 16);
			 }
			 
			 lenrodata1 = rodata1end - rodata1;
			 
			 . = logic1 + lencode1 + lendata1 + lenbss1 + lenrodata1;
			 
			 aligner = ALIGN(phys1 + lencode1 + lendata1 + lenbss1 + lenrodata1 + 2, 512) - 2;
			 			 
			 .alignit : AT(aligner)
			 {
			 		SHORT(0x1234)
			 }
			 
			 			 
			 end = .;
}
