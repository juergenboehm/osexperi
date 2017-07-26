TARGET(elf32-i386)
OUTPUT_FORMAT(binary)

physA32u  = 0x00000000;

logic2u = 0x00001000;

SECTIONS
{
			 				 
/* 32 bit part user mode */

				. = logic2u;

			 	.text2u : AT(physA32u)
			 	{ 
			 		code2u = .;
					*.o(.text)
					code2endu = ALIGN(.,16);
				}
				
				lencode2u = code2endu - code2u;
				
																
/*				. = logic2u + lencode2u; */
				

	       .data2u : AT( data2u - logic2u )       			
			  { 
					data2u = .;
					*.o(.data) 
					data2endu = ALIGN(., 16);
				}
				
				lendata2u = data2endu - data2u;
				
								
/*			 . = logic2u + lencode2u + lendata2u; */

       .bss2u : AT(bss2u - logic2u)
			 {
			 		bss2u = .; 
			 		*.o(.bss)
					*.o(COMMON)
			 		bss2endu = ALIGN(., 16);
			 }
			 
			 lenbss2u = bss2endu - bss2u;
			 
/*			 . = logic2u + lencode2u + lendata2u + lenbss2u; */
			 
			 .rodata2u : AT(rodata2u - logic2u)
			 {
			 		rodata2u = .;
					*.o(.rodata*)
			 		rodata2endu = ALIGN(., 16);
			 }
			 
			 lenrodata2u = rodata2endu - rodata2u;
			 
			 . = rodata2endu;

/*			 
			 . = logic2u + lencode2u + lendata2u + lenbss2u + lenrodata2u;
*/

/*			 
			 aligner2 = ALIGN(physA32 + . - logic2u + 2, 512) - 2;
			 			 
			 .alignit2 : AT(aligner2)
			 {
			 		SHORT(0x1234)
			 }
*/
			 
			 end32_user = .;
}
