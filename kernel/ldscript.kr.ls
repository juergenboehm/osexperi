TARGET(elf32-i386)
OUTPUT_FORMAT(binary)

physA  = 0x00020000;

logic1 = 0x00000000;

logic2 = 0xc0100000;

logic2x = 0x00001000;

SECTIONS
{

/* 16 bit part */

			 	. = logic1;

			 	.text1 : AT(physA)
			 	{
			 		code1 = .;
					*Aux.o(.text)
					*16.o(.text1)
					code1end = ALIGN(.,16);
				}

				lencode1 = code1end - code1;


				. = logic1 + lencode1;

       .data1 : AT(physA + lencode1)
			  {
					data1 = .;
					*Aux.o(.data)
					*16.o(.data1)
					data1end = ALIGN(., 16);
				}

				lendata1 = data1end - data1;


			 . = logic1 + lencode1 + lendata1;

       .bss1 : AT(physA + lencode1 + lendata1)
			 {
			 		bss1 = .;
			 		*16.o(.bss1)
					*16.o(COMMON)
			 		bss1end = ALIGN(., 16);
			 }

			 lenbss1 = bss1end - bss1;

			 . = logic1 + lencode1 + lendata1 + lenbss1;

			 .rodata1 : AT(physA + lencode1 + lendata1 + lenbss1)
			 {
			 		rodata1 = .;
					*16.o(.rodata1*)
			 		rodata1end = ALIGN(., 16);
			 }

			 lenrodata1 = rodata1end - rodata1;

			 . = logic1 + lencode1 + lendata1 + lenbss1 + lenrodata1;

			 aligner = ALIGN(physA + lencode1 + lendata1 + lenbss1 + lenrodata1 + 2, 512) - 2;

			 .alignit : AT(aligner)
			 {
			 		SHORT(0x1234)
			 }


			 len16 = aligner + 2 - physA; /* is a global member in stubAux.S. is length of 16-bit part of kernel */

/* 32 bit part */

		physAx = aligner + 2;

		. = logic2;

	 	.text2 : AT(physAx)
	 	{
	 		code2 = .;
			*32.o(.text2)
			code2end = ALIGN(.,16);
		}

		lencode2 = code2end - code2;


		. = logic2 + lencode2;

       .data2 : AT(physAx + lencode2)
			  {
					data2 = .;
					*32.o(.data2)
					data2end = ALIGN(., 16);
				}

				lendata2 = data2end - data2;


			 . = logic2 + lencode2 + lendata2;

       .bss2 : AT(physAx + lencode2 + lendata2)
			 {
			 		bss2 = .;
			 		*32.o(.bss2)
					*32.o(COMMON)
			 		bss2end = ALIGN(., 16);
			 }

			 lenbss2 = bss2end - bss2;

			 . = logic2 + lencode2 + lendata2 + lenbss2;

			 .rodata2 : AT(physAx + lencode2 + lendata2 + lenbss2)
			 {
			 		rodata2 = .;
					*32.o(.rodata2*)
			 		rodata2end = ALIGN(., 16);
			 }

			 lenrodata2 = rodata2end - rodata2;

			 . = logic2 + lencode2 + lendata2 + lenbss2 + lenrodata2;

			 aligner2 = ALIGN(physAx + lencode2 + lendata2 + lenbss2 + lenrodata2 + 2, 4096) - 2;

			 .alignit2 : AT(aligner2)
			 {
			 		SHORT(0x1234)
			 }
			 

/* 32 bit part user mode*/

		physAxx = aligner2 + 2;
		
		usercode_phys = physAxx - physA - len16;

		. = logic2x;

	 	.text2x : AT(physAxx)
	 	{
	 		code2x = .;
			*32_user.o(.text2u)
			code2endx = ALIGN(.,16);
		}

		lencode2x = code2endx - code2x;


		. = logic2x + lencode2x;

       .data2x : AT(physAxx + lencode2x)
			  {
					data2x = .;
					*32_user.o(.data2u)
					data2endx = ALIGN(., 16);
				}

				lendata2x = data2endx - data2x;


			 . = logic2x + lencode2x + lendata2x;

       .bss2x : AT(physAxx + lencode2x + lendata2x)
			 {
			 		bss2x = .;
			 		*32_user.o(.bss2u)
					*32_user.o(COMMON)
			 		bss2endx = ALIGN(., 16);
			 }

			 lenbss2x = bss2endx - bss2x;

			 . = logic2x + lencode2x + lendata2x + lenbss2x;

			 .rodata2x : AT(physAxx + lencode2x + lendata2x + lenbss2x)
			 {
			 		rodata2x = .;
					*32_user.o(.rodata2u*)
			 		rodata2endx = ALIGN(., 16);
			 }

			 lenrodata2x = rodata2endx - rodata2x;

			 . = logic2x + lencode2x + lendata2x + lenbss2x + lenrodata2x;

			 aligner2x = ALIGN(physAxx + lencode2x + lendata2x + lenbss2x + lenrodata2x + 2, 512) - 2;

			 .alignit2x : AT(aligner2x)
			 {
			 		SHORT(0x1234)
			 }

			 
			 
			 

			 len32 = aligner2x + 2 - physAx; /* is a global member in stubAux.S. is length of 32-bit part of kernel */
			 

			 end = .;
			 
}
