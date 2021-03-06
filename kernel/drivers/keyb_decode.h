#ifndef __drivers_keyb_decode_h
#define __drivers_keyb_decode_h

#include "kerneltypes.h"
#include "fs/vfs.h"

// break make tables

#define KC_Backspace		0xa0,	  0x0E,    0x8E
#define KC_Caps_Lock    0x01, 	0x3A,    0xBA
#define KC_Enter	      0x02, 	0x1C,    0x9C
#define KC_Esc	      	0x03, 	0x01,    0x81
#define KC_Left_Alt     0x04, 	0x38,    0xB8
#define KC_Left_Ctrl    0x05, 	0x1D,    0x9D
#define KC_Left_Shift   0x06, 	0x2A,    0xAA
#define KC_Num_Lock     0x07, 	0x45,    0xC5
#define KC_Right_Shift  0x08, 	0x36,    0xB6
#define KC_Scroll_Lock  0x09, 	0x46,    0xC6
#define KC_Space	      0x0a, 	0x39,    0xB9
#define KC_Sys_Req  		0x0b, 	0x54,    0xD4
#define KC_Tab	      	0x0c, 	0x0F,    0x8F


#define KC_F1			0x10, 	0x3B,    0xBB
#define KC_F2			0x11, 	0x3C,    0xBC
#define KC_F3			0x12, 	0x3D,    0xBD
#define KC_F4			0x13, 	0x3E,    0xBE
#define KC_F7			0x14, 	0x41,    0xC1
#define KC_F5			0x15, 	0x3F,    0xBF
#define KC_F6			0x16, 	0x40,    0xC0
#define KC_F8			0x17, 	0x42,    0xC2
#define KC_F9			0x18, 	0x43,    0xC3
#define KC_F10		0x19,  	0x44,    0xC4
#define KC_F11		0x1a,  	0x57,    0xD7
#define KC_F12		0x1b,  	0x58,    0xD8

#define		KC_A      0x20,  	0x1E,   0x9E
#define		KC_B      0x21,  	0x30,    0xB0
#define		KC_C      0x22,  	0x2E,    0xAE
#define		KC_D      0x23,  	0x20,    0xA0
#define		KC_E      0x24,  	0x12,    0x92
#define		KC_F      0x25,  	0x21,    0xA1
#define		KC_G      0x26,  	0x22,    0xA2
#define		KC_H      0x27,  	0x23,    0xA3
#define		KC_I      0x28, 	0x17,    0x97
#define		KC_J      0x29,  	0x24,    0xA4
#define		KC_K      0x2a,  	0x25,    0xA5
#define		KC_L      0x2b,  	0x26,    0xA6
#define		KC_M      0x2c,  	0x32,    0xB2

#define		KC_N      0x2d,  	0x31,    0xB1
#define		KC_O      0x2e,  	0x18,    0x98
#define		KC_P      0x2f,  	0x19,    0x99
#define		KC_Q      0x30,  	0x10,    0x90
#define		KC_R      0x31,  	0x13,    0x93
#define		KC_S      0x32,  	0x1F,    0x9F
#define		KC_T      0x33,  	0x14,    0x94
#define		KC_U      0x34,  	0x16,    0x96
#define		KC_V      0x35,  	0x2F,    0xAF
#define		KC_W      0x36,  	0x11,    0x91
#define		KC_X      0x37,  	0x2D,    0xAD
//#define		KC_Y      0x38,  	0x15,    0x95
//#define		KC_Z      0x39,  	0x2C,    0xAC

// we have to swap the keys Y and Z for some reason
// although we have a german keyboard layout in bochs.

#define		KC_Y      0x39,  	0x15,    0x95
#define		KC_Z      0x38,  	0x2C,    0xAC


#define		KC_0      0x40,  	0x0B,    0x8B
#define		KC_1      0x41,  	0x02,    0x82
#define		KC_2      0x42,  	0x03,    0x83
#define		KC_3      0x43,  	0x04,    0x84
#define		KC_4      0x44,  	0x05,    0x85
#define		KC_5      0x45,  	0x06,    0x86
#define		KC_6      0x46,  	0x07,    0x87
#define		KC_7      0x47,  	0x08,    0x88
#define		KC_8      0x48,  	0x09,    0x89
#define		KC_9      0x49,  	0x0A,    0x8A


#define KC_Minus      0x50, 	0x35,    0xB5
#define KC_SZ      		0x51, 	0x0C,    0x8C
#define KC_Acc      	0x52, 	0x0D,    0x8D
#define KC_Uuml      	0x53, 	0x1A,    0x9A
#define KC_Plus      	0x54, 	0x1B,    0x9B
#define KC_Ouml      	0x55, 	0x27,    0xA7
#define KC_Auml     	0x56, 	0x28,    0xA8
#define KC_Caret      0x57, 	0x29,    0xA9
#define KC_Hash      	0x58, 	0x2B,    0xAB
#define KC_Comma      0x59, 	0x33,    0xB3
#define KC_Period     0x5a, 	0x34,    0xB4
#define KC_Less				0x5b, 	0x56,    0xD6


#define	KC_Del		 			0x60, 	0xE0, 0x53,	 0xE0, 0xD3
#define	KC_Down_arrow	 	0x61,	  0xE0, 0x50,	 0xE0, 0xD0
#define	KC_End		 			0x62, 	0xE0, 0x4F,	 0xE0, 0xCF
#define	KC_Home		 			0x63,	  0xE0, 0x47,	 0xE0, 0xC7
#define	KC_Ins		 			0x64, 	0xE0, 0x52,	 0xE0, 0xD2
#define	KC_Left_arrow	 	0x65,	  0xE0, 0x4B,	 0xE0, 0xCB
#define	KC_PgDn		 			0x66,	  0xE0, 0x51,	 0xE0, 0xD1
#define	KC_PgUp		 			0x67,	  0xE0, 0x49,	 0xE0, 0xC9
#define	KC_Right_arrow	0x68,	  0xE0, 0x4D,	 0xE0, 0xCD
#define	KC_Up_arrow	 		0x69,	  0xE0, 0x48,	 0xE0, 0xC8

#define KC_Right_Alt		0x70,	0xE0, 0x38, 0xE0, 0xb8

// Virtual Key Tables


#define VK_Backspace		0xa0
#define VK_Caps_Lock    0x01
#define VK_Enter	      0x02
#define VK_Esc	      	0x03
#define VK_Left_Alt     0x04
#define VK_Left_Ctrl    0x05
#define VK_Left_Shift   0x06
#define VK_Num_Lock     0x07
#define VK_Right_Shift  0x08
#define VK_Scroll_Lock  0x09
#define VK_Space	      0x0a
#define VK_Sys_Req  		0x0b
#define VK_Tab	      	0x0c

#define VK_F1			0x10
#define VK_F2			0x11
#define VK_F3			0x12
#define VK_F4			0x13
#define VK_F7			0x14
#define VK_F5			0x15
#define VK_F6			0x16
#define VK_F8			0x17
#define VK_F9			0x18
#define VK_F10		0x19
#define VK_F11		0x1a
#define VK_F12		0x1b

#define		VK_A      0x20
#define		VK_B      0x21
#define		VK_C      0x22
#define		VK_D      0x23
#define		VK_E      0x24
#define		VK_F      0x25
#define		VK_G      0x26
#define		VK_H      0x27
#define		VK_I      0x28
#define		VK_J      0x29
#define		VK_K      0x2a
#define		VK_L      0x2b
#define		VK_M      0x2c

#define		VK_N      0x2d
#define		VK_O      0x2e
#define		VK_P      0x2f
#define		VK_Q      0x30
#define		VK_R      0x31
#define		VK_S      0x32
#define		VK_T      0x33
#define		VK_U      0x34
#define		VK_V      0x35
#define		VK_W      0x36
#define		VK_X      0x37
#define		VK_Y      0x38
#define		VK_Z      0x39



#define		VK_0      0x40
#define		VK_1      0x41
#define		VK_2      0x42
#define		VK_3      0x43
#define		VK_4      0x44
#define		VK_5      0x45
#define		VK_6      0x46
#define		VK_7      0x47
#define		VK_8      0x48
#define		VK_9      0x49


#define VK_Minus      0x50
#define VK_SZ      		0x51
#define VK_Acc      	0x52
#define VK_Uuml      	0x53
#define VK_Plus      	0x54
#define VK_Ouml      	0x55
#define VK_Auml     	0x56
#define VK_Caret      0x57
#define VK_Hash      	0x58
#define VK_Comma      0x59
#define VK_Period     0x5a
#define VK_Less				0x5b


#define	VK_Del		 			0x60
#define	VK_Down_arrow	 	0x61
#define	VK_End		 			0x62
#define	VK_Home		 			0x63
#define	VK_Ins		 			0x64
#define	VK_Left_arrow	 	0x65
#define	VK_PgDn		 			0x66
#define	VK_PgUp		 			0x67
#define	VK_Right_arrow	0x68
#define	VK_Up_arrow	 		0x69

#define VK_Right_Alt		0x70



#define KC_TABLESIZE 256


#define	ASCII_CR			0x0d
#define ASCII_BS			0x08
#define ASCII_DEL			0x7f

#define MODIF_SHIFTL	0x01
#define MODIF_SHIFTR	0x02
#define MODIF_ALTGR		0x04
#define MODIF_CTRLL		0x08


uint32_t init_keytables();
uint32_t read_key_with_modifiers(int keyb_num);


int keyb_read(file_t* fil, char* buf, size_t count, size_t* offset);


#endif
