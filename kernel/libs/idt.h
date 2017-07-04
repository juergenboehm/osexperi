#ifndef __idt_h
#define __idt_h

#include "kerneltypes.h"
#include "utils.h"

// this should better be called IDT descriptor, as this is the
// "official" name, see "80386 programmer's reference manual"
// section 9.5
// it is pictured there coming in three "flavours" namely
//
// task gate, see section 7.4, section 9.5
// a task gate is a special beast, it can live in an LDT and in an IDT
// and if "activated" (how?) provides only an index into the GDT, where
// the actual TSS Descriptor (described in gdt.h) lives, which contains
// the actual address and aux data to reach the TSS (for performing a
// task switch presumably)
//
// interrupt gate
// trap gate


typedef struct __PACKED s_idt_entry {

	uint16_t		offset_1;
	uint16_t		indicator;
	uint8_t		byte_U_1;
	uint8_t		byte_U_2;
	uint16_t		offset_2;

} idt_entry;


// set offset

#define IDT_ENTRY_SET_OFFSET_1(p, offs) \
				{ (p).offset_1 = (uint16_t)((((uint32_t)offs)) & ((uint32_t) (uint16_t)0xffff)); };

#define IDT_ENTRY_SET_OFFSET_2(p, offs) \
				{ (p).offset_2 = (uint16_t)((((uint32_t)offs)>>16) & ((uint32_t)(uint16_t)0xffff)); };

#define	IDT_ENTRY_SET_OFFSET(p, offs) \
			 {IDT_ENTRY_SET_OFFSET_1(p, offs); IDT_ENTRY_SET_OFFSET_2(p, offs); }

// set indicator


#define IDT_ENTRY_SET_INDICATOR(p, indic) \
			{ (p).indicator = (uint16_t)(indic); }


// set DPL

#define IDT_ENTRY_SET_DPL(p, dpl) SET_BYTE_GENERIC((p).byte_U_2, dpl, 5, 2)
#define IDT_ENTRY_SET_P(p, pr) SET_BYTE_GENERIC((p).byte_U_2, pr, 7, 1)

#define IDT_ENTRY_SET_TYP(p, typ) SET_BYTE_GENERIC((p).byte_U_2, typ, 0, 4)

// compact form

#define IDT_ENTRY_ZERO(p) \
					{ (p).offset_1 = 0; (p).indicator = 0; (p).byte_U_1 = 0; (p).byte_U_2 = 0; \
						(p).offset_2 = 0; }

#define IDT_ENTRY_SET_P_DPL_TYP(x, indic, offs, p, dpl, typ) \
					{ IDT_ENTRY_ZERO(x); \
						IDT_ENTRY_SET_INDICATOR(x, indic); \
						IDT_ENTRY_SET_OFFSET(x, offs); \
						IDT_ENTRY_SET_P(x, p); \
						IDT_ENTRY_SET_DPL(x, dpl); \
						IDT_ENTRY_SET_TYP(x, typ); }


#define IDT_TYP_TRAP		0xf
#define	IDT_TYP_IRQ			0xe
#define IDT_TYP_TSSGATE	0x5

#define IDT_ENTRY_SET_P_DPL_TRAP(x, indic, offs, p, dpl) \
					{ IDT_ENTRY_SET_P_DPL_TYP(x, indic, offs, p, dpl, IDT_TYP_TRAP); }

#define IDT_ENTRY_SET_P_DPL_IRQ(x, indic, offs, p, dpl) \
					{ IDT_ENTRY_SET_P_DPL_TYP(x, indic, offs, p, dpl, IDT_TYP_IRQ); }

#define IDT_ENTRY_SET_P_DPL_TSSGATE(x, indic, offs, p, dpl) \
					{ IDT_ENTRY_SET_P_DPL_TYP(x, indic, offs, p, dpl, IDT_TYP_TSSGATE); }



#endif
