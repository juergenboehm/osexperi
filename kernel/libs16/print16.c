
#include "print16.h"

int print_nibble(uint8_t nibble)
{
	nibble &= 0x0f;
	uint8_t outch = nibble <= 9 ? '0' + nibble : ('a' + nibble) - 10;
	print_char(outch);
	return 0;
}

int print_byte(uint8_t byte)
{
	print_nibble(byte >> 4);
	print_nibble(byte);
	return 0;
}

int print_U32(uint32_t num)
{
	print_byte((uint8_t)((num>>24) & 0xff));
	print_byte((uint8_t)((num>>16) & 0xff));
	print_byte((uint8_t)((num>>8) & 0xff));
	print_byte((uint8_t)(num & 0xff));
	return 0;
}



void print_str(char* str)
{
	char* p = str;
	while (*p)
	{
		print_char((uint8_t)(*(p++)));
	}
}


void print_newline()
{
	print_str("\r\n");
}


void print_gdt_entry(descriptor_t* p)
{

	print_str("limit 1 = ");
	print_U32(p->limit_1);
	print_newline();

	print_str("base 1 = ");
	print_U32(p->base_1);
	print_newline();

	print_str("base 2 = ");
	print_U32(p->base_2);
	print_newline();

	print_str("byte_AR 1 = ");
	print_U32(p->byte_AR);
	print_newline();

	print_str("limit_2_gdou 1 = ");
	print_U32(p->limit_2_gdou);
	print_newline();

	print_str("base_3 = ");
	print_U32(p->base_3);
	print_newline();

}

void memset16(void* p, uint8_t val, uint16_t size)
{

	int i = 0;
	uint8_t* pp = (uint8_t*) p;
	for(i = 0; i < size; ++i)
	{
		*pp = val;
		++pp;
	}
}


