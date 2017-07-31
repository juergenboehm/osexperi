TARGET(elf32-i386)
OUTPUT_FORMAT(binary)

physA  = 0x00020000;

logic1 = 0x00000000;

logic2 = 0xc0100000;

logic2x = 0x00001000;

/*

***************** 10 07 2017: VERY IMPORTANT NOTE ***********************************

the loader scripts are now in a new logic without making use of
length computations of sections for setting the .

Instead a much simpler logic following the scheme

<name_sec>: AT(phys<Beg> + <name_sec> - <current logic>)

is used.

This removed an annoying bug in userproc.c
where a new global variable introduced for testing
gots wrongly placed and therefore wrongly addressed (which lead to
failure of uprintf() )


*/


SECTIONS
{

/* 16 bit part */

			 	. = logic1;

			 	.text1 : AT(physA + code1 - logic1)
			 	{
			 		code1 = .;
					*Aux.o(.text)
					*16.o(.text1)
					code1end = ALIGN(.,16);
				}

				lencode1 = code1end - code1;


       .data1 : AT(physA + data1 - logic1)
			  {
					data1 = .;
					*Aux.o(.data)
					*16.o(.data1)
					data1end = ALIGN(., 16);
				}

				lendata1 = data1end - data1;


       .bss1 : AT(physA + bss1 - logic1)
			 {
			 		bss1 = .;
			 		*16.o(.bss1)
					*16.o(COMMON)
			 		bss1end = ALIGN(., 16);
			 }

			 lenbss1 = bss1end - bss1;


			 .rodata1 : AT(physA + rodata1 - logic1)
			 {
			 		rodata1 = .;
					*16.o(.rodata1*)
			 		rodata1end = ALIGN(., 16);
			 }

			 lenrodata1 = rodata1end - rodata1;


			 aligner = ALIGN(physA + . - logic1 + 2, 4096) - 2;

			 .alignit : AT(aligner)
			 {
			 		SHORT(0x1234)
			 }


			 len16 = aligner + 2 - physA; /* is a global member in stubAux.S. is length of 16-bit part of kernel */

/* 32 bit part */

		physAx = aligner + 2;

		. = logic2;

	 	.text2 : AT(physAx + code2 - logic2)
	 	{
	 		code2 = .;
			*32.o(.text2)
			code2end = ALIGN(.,16);
		}

		lencode2 = code2end - code2;


       .data2 : AT(physAx + data2 - logic2)
			  {
					data2 = .;
					*32.o(.data2)
					data2end = ALIGN(., 16);
				}

				lendata2 = data2end - data2;


       .bss2 : AT(physAx + bss2 - logic2)
			 {
			 		bss2 = .;
			 		*32.o(.bss2)
					*32.o(COMMON)
			 		bss2end = ALIGN(., 16);
			 }

			 lenbss2 = bss2end - bss2;

			 .rodata2 : AT(physAx + rodata2 - logic2)
			 {
			 		rodata2 = .;
					*32.o(.rodata2*)
			 		rodata2end = ALIGN(., 16);
			 }

			 lenrodata2 = rodata2end - rodata2;



/* .eh_frame became necessary, when linking with option -lgcc is
   added
*/
			 .eh_frame : AT(physAx + eh_frame - logic2)
			 {
			 		eh_frame = .;
					*32.o(.eh_frame*)
			 		eh_frameend = ALIGN(., 16);
			 }

			 aligner2 = ALIGN(physAx + . - logic2 + 2, 4096) - 2;

			 .alignit2 : AT(aligner2)
			 {
			 		SHORT(0x1234)
			 }
			 
			 len32 = aligner2 + 2 - physAx; /* is a global member in stubAux.S. is length of 32-bit part of kernel */
			 
			 

/* 32 bit part user mode*/

		physAxx = aligner2 + 2;
		
		usercode_phys = physAxx - physA - len16;

			 end = .;
			 
}
