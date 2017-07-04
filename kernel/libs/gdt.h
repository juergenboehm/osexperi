#ifndef __gdt_h
#define __gdt_h

#include "kerneltypes.h"
#include "utils.h"

// TODO: this is actually something more generally,
// namely a descriptor, and should therefore be called such
// it can be a DSS (Data Segment Descriptor)
// an Executable Segment Descriptor
// a System Segment Descriptor
// at last in can be a TSS Descriptor(Task State Segment Descriptor)

// TSS Descriptors reside only in the GDT (insofar they are indeed
// "gdt_entrys")

// Segment descriptors actually live in the tables that are their "home"
// namely the GDT and the LDT. The bases of these tables are held
// in correspondingly named processor registers

// in protected mode the segment registers (still 16 bit!) are "selectors"
// resp. indices into the GDT or LDT table. into which table of these
// both is decided by bit 2 in the respective segment register.

// a descriptor has the same size as a interrupt gate that lives in the
// idt. For details about these, see idt.h

#define TSS_GDT_INDEX 10
#define TSS_GDT_TYPX 9


typedef struct __PACKED s_descriptor {

	uint16_t		limit_1;
	uint16_t		base_1;
	uint8_t		base_2;
	uint8_t		byte_AR;
	uint8_t		limit_2_gdou;
	uint8_t		base_3;


} descriptor_t;


// set base

#define DESCRIPTOR_SET_BASE_1(p, bas) \
				{ (p).base_1 = (uint16_t)((((uint32_t)bas)) & ((uint32_t) (uint16_t)0xffff)); };

#define DESCRIPTOR_SET_BASE_2(p, bas) \
				{ (p).base_2 = (uint8_t)((((uint32_t)bas)>>16) & 0xff); };

#define DESCRIPTOR_SET_BASE_3(p, bas) \
				{ (p).base_3 = (uint8_t)((((uint32_t)bas)>>24) & 0xff); };

#define	DESCRIPTOR_SET_BASE(p, bas) \
			 {DESCRIPTOR_SET_BASE_1(p, bas); DESCRIPTOR_SET_BASE_2(p, bas); \
				DESCRIPTOR_SET_BASE_3(p, bas); }

// set limit

#define DESCRIPTOR_SET_LIMIT_1(p, lim) \
				(p).limit_1 = (uint16_t)((((uint32_t)lim)) & ((uint32_t)0xffff))

#define DESCRIPTOR_SET_LIMIT_2(p, lim) \
				SET_BYTE_GENERIC(((p).limit_2_gdou), (((uint32_t)lim)>>16), 0, 4)

#define DESCRIPTOR_SET_LIMIT(p, lim) \
			{ DESCRIPTOR_SET_LIMIT_1(p, lim); \
				DESCRIPTOR_SET_LIMIT_2(p, lim); }

// set gdou

#define DESCRIPTOR_SET_G(p, g) SET_BYTE_GENERIC(((p).limit_2_gdou), g, 7, 1)
#define DESCRIPTOR_SET_D(p, d) SET_BYTE_GENERIC(((p).limit_2_gdou), d, 6, 1)
#define DESCRIPTOR_SET_O(p, o) SET_BYTE_GENERIC(((p).limit_2_gdou), o, 5, 1)
#define DESCRIPTOR_SET_U(p, u) SET_BYTE_GENERIC(((p).limit_2_gdou), u, 4, 1)

// set DPL, set S(ystem), set P(resent), set TYP (bits 1..3), set TYPX (bits 0..3)

#define DESCRIPTOR_SET_DPL(p, dpl) SET_BYTE_GENERIC((p).byte_AR, dpl, 5, 2)
#define DESCRIPTOR_SET_S(p, s) SET_BYTE_GENERIC((p).byte_AR, s, 4, 1)
#define DESCRIPTOR_SET_P(p, pr) SET_BYTE_GENERIC((p).byte_AR, pr, 7, 1)

#define DESCRIPTOR_SET_TYP(p, typ) SET_BYTE_GENERIC((p).byte_AR, typ, 1, 3)
#define DESCRIPTOR_SET_TYPX(p, typx) SET_BYTE_GENERIC((p).byte_AR, typx, 0, 4)

// compact form

#define DESCRIPTOR_SET_GD_P_DPL_S_TYP(x, bas, lim, g, d, p, dpl, s, typ) \
					{ DESCRIPTOR_SET_BASE(x, bas); DESCRIPTOR_SET_LIMIT(x, lim); \
						DESCRIPTOR_SET_G(x, g); DESCRIPTOR_SET_D(x, d); \
						DESCRIPTOR_SET_P(x, p); DESCRIPTOR_SET_DPL(x, dpl); \
						DESCRIPTOR_SET_S(x, s); DESCRIPTOR_SET_TYP(x, typ); }

#define DESCRIPTOR_SET_GD_P_DPL_S_TYPX(x, bas, lim, g, d, p, dpl, s, typ) \
					{ DESCRIPTOR_SET_BASE(x, bas); DESCRIPTOR_SET_LIMIT(x, lim); \
						DESCRIPTOR_SET_G(x, g); DESCRIPTOR_SET_D(x, d); \
						DESCRIPTOR_SET_O(x, 0); \
						DESCRIPTOR_SET_P(x, p); DESCRIPTOR_SET_DPL(x, dpl); \
						DESCRIPTOR_SET_S(x, s); DESCRIPTOR_SET_TYPX(x, typ); }

// set zero entry

#define DESCRIPTOR_SET_SEG_ZERO(p) \
					{ DESCRIPTOR_SET_BASE(p, 0x0); \
						DESCRIPTOR_SET_LIMIT(p, (uint32_t)0x0 ); \
						DESCRIPTOR_SET_G(p, 0); \
						DESCRIPTOR_SET_D(p, 0); \
						DESCRIPTOR_SET_O(p, 0); \
						DESCRIPTOR_SET_U(p, 0); \
						DESCRIPTOR_SET_S(p, 0); \
						DESCRIPTOR_SET_P(p, 0); \
						DESCRIPTOR_SET_DPL(p, 0); \
						DESCRIPTOR_SET_TYP(p, 0); \
					}


#define CODE_SEG_TYP 5
#define	DATA_SEG_TYP 1

#define DESCRIPTOR_SET_SEG_GENERIC(p, dpl) \
					{ DESCRIPTOR_SET_BASE(p, 0x0000); \
						DESCRIPTOR_SET_LIMIT(p, (uint32_t)0xfffff ); \
						DESCRIPTOR_SET_G(p, 1); \
						DESCRIPTOR_SET_D(p, 1); \
						DESCRIPTOR_SET_O(p, 0); \
						DESCRIPTOR_SET_U(p, 0); \
						DESCRIPTOR_SET_S(p, 1); \
						DESCRIPTOR_SET_P(p, 1); \
						DESCRIPTOR_SET_DPL(p, dpl); \
					}

#define DESCRIPTOR_SET_CODE_SEG(p, dpl) \
				{ DESCRIPTOR_SET_SEG_GENERIC(p, dpl); \
					DESCRIPTOR_SET_TYPX(p, CODE_SEG_TYP << 1); \
				}

#define DESCRIPTOR_SET_DATA_SEG(p, dpl) \
				{ DESCRIPTOR_SET_SEG_GENERIC(p, dpl); \
					DESCRIPTOR_SET_TYPX(p, DATA_SEG_TYP << 1); \
				}


#endif
