

	.text
	.code16
	.globl entry16
	.globl plen16
	.globl plen32
	.globl pusercode_phys

	jmp		entry16

	.align	4

	.long len16 // later contains len of 16-bit part of kernel
	.long len32 // later contains len of 32-bit-part of kernel
	.long usercode_phys // start of usercode in kernel
