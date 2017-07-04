TARGET(elf32-i386)
OUTPUT_FORMAT(elf32-i386)

physA32  = 0x00000000;

logic2 = 0xc0100000;

logic2u = 0x00001000;

EXTERN(uproc_1)

SECTIONS
{
			 				 
/* 32 bit part */

				. = logic2;

			 	.text2 : AT(physA32)
			 	{ 
			 		code2 = .;
					*.o(.text)
					code2end = ALIGN(.,16);
				}
				
				lencode2 = code2end - code2;
				
																
				. = logic2 + lencode2;
									
       .data2 : AT(physA32 + lencode2)
			  { 
					data2 = .;
					*.o(.data) 
					data2end = ALIGN(., 16);
				}
				
				lendata2 = data2end - data2;
				
								
			 . = logic2 + lencode2 + lendata2;

       .bss2 : AT(physA32 + lencode2 + lendata2)
			 {
			 		bss2 = .; 
			 		*.o(.bss)
					*.o(COMMON)
			 		bss2end = ALIGN(., 16);
			 }
			 
			 lenbss2 = bss2end - bss2;
			 
			 . = logic2 + lencode2 + lendata2 + lenbss2;
			 
			 .rodata2 : AT(physA32 + lencode2 + lendata2 + lenbss2)
			 {
			 		rodata2 = .;
					*.o(.rodata*)
			 		rodata2end = ALIGN(., 16);
			 }
			 
			 lenrodata2 = rodata2end - rodata2;
			 
			 . = logic2 + lencode2 + lendata2 + lenbss2 + lenrodata2;


/*			 
			 aligner2 = ALIGN(physA32 + lencode2 + lendata2 + lenbss2 + lenrodata2 + 2, 512) - 2;
			 			 
			 .alignit2 : AT(aligner2)
			 {
			 		SHORT(0x1234)
			 }
*/
			 
			 end32 = .;
}
