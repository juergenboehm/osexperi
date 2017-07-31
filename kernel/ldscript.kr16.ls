TARGET(elf32-i386)
OUTPUT_FORMAT(elf32-i386)

physA16  = 0x00000000;

logic1 = 0x00000010;


EXTERN(len16);
EXTERN(len32);
EXTERN(usercode_phys);


SECTIONS
{


/* 16 bit part */

			 	. = logic1;
       
			 	.text1 : AT(physA16 + code1 - logic1)
			 	{ 
			 		code1 = .;
					*.o(.text)
					code1end = ALIGN(.,16);
				}
				
				lencode1 = code1end - code1;
				
																								
       .data1 : AT(physA16 + data1 - logic1)
			  { 
					data1 = .;
					*.o(.data) 
					data1end = ALIGN(., 16);
				}
				
				lendata1 = data1end - data1;
				
								
       .bss1 : AT(physA16 + bss1 - logic1)
			 {
			 		bss1 = .; 
			 		*.o(.bss)
					*.o(COMMON)
			 		bss1end = ALIGN(., 16);
			 }
			 
			 lenbss1 = bss1end - bss1;
			 		 
			 .rodata1 : AT(physA16 + rodata1 - logic1)
			 {
			 		rodata1 = .;
					*.o(.rodata*)
			 		rodata1end = ALIGN(., 16);
			 }
			 
			 lenrodata1 = rodata1end - rodata1;
			 

/*
			 aligner = ALIGN(physA16 + lencode1 + lendata1 + lenbss1 + lenrodata1 + 2, 512) - 2;
			 			 
			 .alignit : AT(aligner)
			 {
			 		SHORT(0x1234)
			 }
*/			 
			 
			 end16 = .;
			 
}
