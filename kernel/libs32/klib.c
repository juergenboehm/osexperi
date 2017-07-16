
#include "drivers/vga.h"
#include "drivers/hardware.h"
#include "libs/utils.h"
#include "mem/paging.h"
#include "mem/pagedesc.h"

#include "kernel32/process.h"
#include "kernel32/mutex.h"

#include "libs32/klib.h"


// the workers for printing

static uint8_t *ptqq = (uint8_t*)0xc00b8000;

void raw_print_char(char *p)
{
	while (*p)
	{
		*ptqq++ = *p;
		*ptqq++ = 0x1e;
		++p;
	}
}



// the prehistoric k.. workers

void kprint_char(uint8_t ch)
{
	IRQ_CLI_SAVE(eflags);
	screen_print_char(0, ch);
	IRQ_RESTORE(eflags);
}

int kprint_nibble(uint8_t nibble)
{
	nibble &= 0x0f;
	uint8_t outch = nibble <= 9 ? '0' + nibble : ('a' + nibble) - 10;
	kprint_char(outch);
	return 0;
}

int kprint_byte(uint8_t byte)
{
	kprint_nibble(byte >> 4);
	kprint_nibble(byte);
	return 0;
}

int kprint_U32(uint32_t num)
{
	kprint_byte((uint8_t)((num>>24) & 0xff));
	kprint_byte((uint8_t)((num>>16) & 0xff));
	kprint_byte((uint8_t)((num>>8) & 0xff));
	kprint_byte((uint8_t)(num & 0xff));
	return 0;
}



void kprint_str_raw(char* str)
{
	char* p = str;
	while (*p)
	{
		kprint_char((uint8_t)(*(p++)));
	}
}

int kprint_str(uint32_t fd, char* str)
{
	if (schedule_off || !current) {
		kprint_str_raw(str);
		return 0;
	} else {
		file_t* p_outfile = current->proc_data.io_block->base_fd_arr[fd];
		uint32_t slen = strlen(str);
		int res = p_outfile->f_fops->write(p_outfile, str, slen, 0);
		return res;
	}
}


void kprint_newline()
{
	kprint_str(1, "\n");
}


// the new workers

// first we parse a format specification

// the flag part

#define FMT_FLAG_NONE			0x00
#define	FMT_FLAG_MINUS		0x01
#define	FMT_FLAG_PLUS			0x02
#define	FMT_FLAG_SPACE		0x04
#define	FMT_FLAG_BANG			0x08
#define	FMT_FLAG_ZERO			0x10

char fmt_flag_char_list[] = {'-', '+', ' ', '#', '0'};

#define FMT_FLAG_ANZ			5

typedef size_t fmt_flag_type;


// the length part

// return result 1 for "hh" 2 for "h" and so on, 0 for not found

char* fmt_length_list[] = { "hh", "h", "ll", "l", "L", "z", "j", "t"};

#define FMT_LENGTH_LONG		4

#define FMT_LENGTH_ANZ		8

typedef size_t fmt_length_type;



// the specifier itself

#define	FMT_SPEC_none	0x00
#define FMT_SPEC_d		0x01
#define FMT_SPEC_s		0x02
#define FMT_SPEC_c		0x04
#define FMT_SPEC_o		0x08
#define FMT_SPEC_u		0x10
#define FMT_SPEC_x		0x20
#define FMT_SPEC_X		0x40

char fmt_specifier_list[] = {'d', 's', 'c', 'o', 'u', 'x', 'X'};

#define FMT_SPEC_ANZ	7

typedef size_t fmt_specifier_type;



char* parse_chars_universal(char* p,
														char* char_try_list, int try_list_len, size_t max_occur, size_t * result)
{
	size_t res = 0;

	size_t parsed = 0;
	bool try_next = true;
	while (*p && try_next && (parsed < max_occur))
	{
		try_next = false;
		int i = 0;
		for(i = 0; i < try_list_len; ++i)
		{
			if (*p == char_try_list[i])
			{
				res |= (1 << i);
				try_next = true;
				++p;
				++parsed;
				break;
			}
		}
	}
	*result = res;
	return p;
}

char* parse_strings_universal(char* p,
														  char* str_try_list[], int try_list_len, size_t * result)
{
	*result = 0;
	size_t i = 0;
	for(i = 0; i < try_list_len; ++i)
	{
		char* q = p;
		char* q1 = str_try_list[i];

		while(*q && *q1 && (*q == *q1))
		{
			++q;
			++q1;
		}
		if (*q1 == 0)
		{
			*result = i + 1;
			return q;
		}

	}

	return p;
}


char* parse_num_universal(char* p, size_t* num)
{
	size_t res = 0;
	while(*p && is_digit(*p))
	{
		res = res * 10 + ((*p) - '0');
		++p;
	}
	*num = res;
	return p;
}


char* parse_format_command(char *p, fmt_flag_type* flags,
																	size_t* width, size_t* precision,
																	fmt_length_type* length,
																	fmt_specifier_type* specif)

{

	// first the format flag

	p = parse_chars_universal(p, fmt_flag_char_list, FMT_FLAG_ANZ, MAX_INT, flags );

	// then the width

	p = parse_num_universal(p, width);

	// then the precision

	if (*p && (*p == '.'))
	{
		++p;
		p = parse_num_universal(p, precision);
	}
	else
	{
		*precision = 0;
	}

	// then the length

	p = parse_strings_universal(p, fmt_length_list, FMT_LENGTH_ANZ, length);

	// then the specifier

	p = parse_chars_universal(p, fmt_specifier_list, FMT_SPEC_ANZ, 1, specif );

	return p;
}


/* now we print a signed integer to string */

uint64_t __udivdi3(uint64_t num, uint64_t den)
{
	uint64_t q = 0;

	short i_cnt_1 = 0;

	while(num >= den)
	{
		den = den << 1;
		i_cnt_1++;
	}

	den = den >> 1;
	i_cnt_1--;

	while((i_cnt_1 >= 0) && (num >= den))
	{
		num = num - den;
		q = q | (((uint64_t)1) << i_cnt_1);
		while((i_cnt_1 > 0) && (num < den))
		{
			den = den >> 1;
			i_cnt_1--;
		}
	}

	return q;
}

uint64_t __umoddi3(uint64_t num, uint64_t den)
{

	return num - __udivdi3(num, den) * den;
}


int int_to_str(char* buf, size_t buf_size, long long val, unsigned int base, bool is_unsigned,
									fmt_flag_type flags, int width, int precision, fmt_length_type length, char** pout)
{
	char buf_aside[64];

	size_t max_digit = 16;
	char* digits = "0123456789abcdef";
	char* pp = buf_aside;
	char* p = buf;

	long long val_akt = val;

	size_t n_out = 0;
	bool overrun = false;

	unsigned long long val_akt_pos = 0;

	int sign = 0;

	bool plus_sign_too = flags & FMT_FLAG_PLUS;
	bool left_align = flags & FMT_FLAG_MINUS;
	bool prefix_with_space = flags & FMT_FLAG_SPACE;
	char pad_char = flags & FMT_FLAG_ZERO ? '0' : ' ';
	bool alternate_form = flags & FMT_FLAG_BANG;

	if(! is_unsigned)
	{

		if (val_akt < 0 )
		{
			sign = -1;
			val_akt_pos = -val_akt;
		}
		else if (val_akt == 0)
		{
			sign = 0;
			val_akt_pos = 0;
		}
		else
		{
			sign = +1;
			val_akt_pos = val_akt;
		}
	}
	else
	{
		val_akt_pos = (uint64_t)val_akt;
		sign = 1;
	}


	while(val_akt_pos > 0)
	{
		size_t digit = val_akt_pos % base;
		val_akt_pos /= base;

		*pp++ = (digit < max_digit) ? digits[digit] : '?';

	}

	size_t len = pp - buf_aside;

	if (len == 0)
	{
		*pp++ = '0';
		++len;
	}

	*pp = 0;

//	kprint_U32(width);
//	kprint_str(" * ");
//	kprint_U32(precision);
//	kprint_str("\n");

	size_t use_width = 0;
	size_t len_of_sign = ((sign >= 0) && plus_sign_too) || (sign < 0) || prefix_with_space ? 1 : 0;

	size_t len_plus_sign = len + len_of_sign;

	if (precision > 0)
	{
		use_width = min(len_plus_sign, precision);
	}
	else
	{
		use_width = len_plus_sign;
	}

	bool width_overflow = false;

	if (width > 0)
	{
		width_overflow = use_width > width;
		use_width = width;
	}

	if (width_overflow)
	{
		// we fill with #
		size_t i = 0;

		for(i = 0; i < width; ++i)
		{
			*p++ = '#';
		}

		// and exit immediately

		n_out = p - buf;

		*pout = p;

		return n_out;

	}


	// assert pad_amount >= 0
	size_t pad_amount = use_width - len_plus_sign;

	if (use_width < len_plus_sign)
	{
		kprint_str(0, "Assertion failed.\n");
		kprint_U32(use_width);
		kprint_str(0, " * ");
		kprint_U32(len_plus_sign);
		kprint_str(0, "\n");
		STOP;
	}

	if (left_align)
	{
		char sig_c = (sign < 0) ? '-' : (plus_sign_too && (sign >= 0)) ? '+' : prefix_with_space ? ' ': '#';

		if (sig_c != '#')
		{
			*p++ = sig_c;
		}

		size_t i = 0;

		for(i = 0; i < len; ++i)
		{
			*p++ = *(buf_aside + len - i - 1);
		}
		for(i = 0; i < pad_amount; ++i)
		{
			*p++ = ' ';
		}

	} // end left align
	else // right align
	{
		if (pad_char == '0')
		{
			char sig_c = (sign < 0) ? '-' : (plus_sign_too && (sign >= 0)) ? '+' : prefix_with_space ? ' ': '#';

			if (sig_c != '#')
			{
				*p++ = sig_c;
			}

			size_t i = 0;

			for(i = 0; i < pad_amount; ++i)
			{
				*p++ = '0';
			}

		}
		else
		{
			size_t i = 0;

			for(i = 0; i < pad_amount; ++i)
			{
				*p++ = ' ';
			}
			char sig_c = (sign < 0) ? '-' : (plus_sign_too && (sign >= 0)) ? '+' : prefix_with_space ? ' ': '#';

			if (sig_c != '#')
			{
				*p++ = sig_c;
			}
		}

		size_t i = 0;

		for(i = 0; i < len; ++i)
		{
			*p++ = *(buf_aside + len - i - 1);
		}
	} // end right align

	n_out = p - buf;

	*pout = p;

	return n_out;

}


// the exported functions


// the printf output group


int vprintf(char* buf, size_t buf_size, char* format, va_list ap)
{
	char* p = format;
	char* s = buf;

	size_t buf_size_akt = buf_size;

	while (*p && buf_size_akt)
	{
		if (*p == '%')
		{
			++p;

			fmt_flag_type flags;
			fmt_length_type length;
			fmt_specifier_type specif;
			unsigned int width;
			unsigned int prec;

			p = parse_format_command(p, &flags, &width, &prec, &length, &specif);

			if ((specif & FMT_SPEC_d))
			{
				int varg_i = va_arg(ap, int);
				//kprint_str("print int: "); kprint_U32(varg_i); kprint_newline();
				size_t len_out = int_to_str(s, buf_size_akt, varg_i, 10, false, flags, width, prec, length, &s);
				buf_size_akt -= len_out;
			}
			else if ((specif & FMT_SPEC_s))
			{
				char* pp_i = va_arg(ap, char*);
				while (*pp_i && buf_size_akt)
				{
					*s++ = *pp_i++;
					--buf_size_akt;
				}
			}
			else if ((specif & FMT_SPEC_o))
			{
				int varg_i = va_arg(ap, int);
				size_t len_out = int_to_str(s, buf_size_akt, varg_i, 8, true, flags, width, prec, length, &s);
				buf_size_akt -= len_out;
			}
			else if ((specif & FMT_SPEC_x))
			{

				long long varg_i = 0;

				if (length == FMT_LENGTH_LONG)
				{
					//kprint_str("Length = 4\n");
					varg_i = (long long)(uint64_t)va_arg(ap, uint64_t);
				}
				else
				{
					 varg_i = (long long)(uint64_t)va_arg(ap, uint32_t);
				}

				size_t len_out = int_to_str(s, buf_size_akt, varg_i, 16, true, flags, width, prec, length, &s);
				buf_size_akt -= len_out;
			}
			else if ((specif & FMT_SPEC_c))
			{
				int varg_i = va_arg(ap, int);
				*s = (char)(varg_i);
				++s;
				--buf_size_akt;
			}
		}
		else
		{
			*s = *p;
			--buf_size_akt;
			++s;
			++p;
		}
	}
	*s = 0;

}

int kprintf(char* format, ... )
{
	int i = 0;
	char* p = format;

	char buffer[1024];

	va_list ap;

	va_start(ap, format);

	vprintf(buffer, 1024, format, ap);

	va_end(ap);

	kprint_str_raw(buffer);

}


int outb_print(char* str)
{
	char *p = str;
	while (*p) {
		outb_0xe9( *p);
		++p;
	}
}

#define PRINTF_BUFFER_LEN	1024

int outb_printf(char* format, ... )
{
	int i = 0;
	char* p = format;

	char buffer[PRINTF_BUFFER_LEN];

	va_list ap;

	va_start(ap, format);

	vprintf(buffer, PRINTF_BUFFER_LEN, format, ap);

	va_end(ap);

	outb_print(buffer);

}

int raw_printf(char* format, ... )
{
	int i = 0;
	char* p = format;

	char buffer[PRINTF_BUFFER_LEN];

	va_list ap;

	va_start(ap, format);

	vprintf(buffer, PRINTF_BUFFER_LEN, format, ap);

	va_end(ap);

	raw_print_char(buffer);

	return 0;
}



int printf(char* format, ... )
{
	int i = 0;
	char* p = format;

	char buffer[PRINTF_BUFFER_LEN];

	va_list ap;

	va_start(ap, format);

	vprintf(buffer, PRINTF_BUFFER_LEN, format, ap);

	va_end(ap);

	return kprint_str(1, buffer);

}

int fprintf(FILE fd, char* format, ... )
{
	int i = 0;
	char* p = format;

	char buffer[PRINTF_BUFFER_LEN];

	va_list ap;

	va_start(ap, format);

	vprintf(buffer, PRINTF_BUFFER_LEN, format, ap);

	va_end(ap);

	return kprint_str(fd, buffer);

}

int sprintf(char* s, char* format, ... )
{
	int i = 0;
	char* p = format;

	va_list ap;

	va_start(ap, format);

	vprintf(s, PRINTF_BUFFER_LEN, format, ap);

	va_end(ap);

	return 0;
}





// the scanf input functions

int scanf(char* format, ... )
{
}

int fscanf(FILE fd, char* format, ... )
{
}

int sscanf(char* s, char* format, ... )
{
}


// getc, putc, gets, puts

int fgetc(FILE fd)
{
}

int fputc(int c, FILE fd)
{
}

char* fgets(char* s, int n, FILE fd)
{
}

int fputs(char* s, FILE fd)
{
}



// some string routines

int strcmp(const char* str1, const char* str2)
{
	while(*str1 && *str2 && (*str1 == *str2))
	{
		++str1;
		++str2;
	}
	if ((*str1 == 0) && (*str2 == 0))
	{
		return 0;
	}
	if (*str1 == 0)
	{
		return +1;
	}
	if (*str2 == 0)
	{
		return -1;
	}
	return *str1 < *str2 ? +1 : -1;

}

char* strcpy(char* str1, char* str2)
{
	char* p = str1;
	while (*p)
	{
		*str2++ = *p++;
	}
	return str1;
}

char* strncpy(char* str1, char* str2, size_t n)
{
	size_t i = 0;
	char* p = str1;
	while((i < n) && (*p))
	{
		*str2++ = *p++;
		++i;
	}
	return str1;
}

char* strcat(char* str1, char* str2)
{
	char* p = str1;
	while(*p)
	{
		++p;
	}
	while(*str2)
	{
		*p++ = *str2++;
	}
	return str1;
}

int strlen(char* str)
{
	int i = 0;
	char* p = str;
	while (*p++)
		++i;
	return i;
}

int atoi(char* str)
{
	char* p = str;
	int eps = 1;
	int val = 0;
	if (*p == '-')
	{
		eps = -1;
		++p;
	}

	while ('0' <= *p && *p <= '9')
	{
		val = 10 * val + ((*p) - '0');
		++p;
	}

	return eps * val;
}

//getc

int getc(uint32_t fd)
{
	file_t* p_infile = current->proc_data.io_block->base_fd_arr[fd];
	uint32_t retval = 0;
	uint32_t keyb_num = GET_MINOR_DEVICE_NUMBER(p_infile->f_dentry->d_inode->i_device);

	outb_printf("getc: keyb = %d \n", keyb_num);

	int res = p_infile->f_fops->read(p_infile, (char*)&retval, sizeof(retval), 0);
	return (int) retval;

}



// some lowlevel io functions

void waitkey()
{

	mtx_lock(&key_wait_mutex[screen_current]);

	do {} while (!key_avail(screen_current));

	uint32_t keyb_full_code = 0;
	do
	{
		keyb_full_code = read_key_with_modifiers(screen_current);
	}
	while (keyb_full_code == 0);

	mtx_unlock(&key_wait_mutex[screen_current]);
}

// memcpy

void* memcpy(void* dest, void* src, size_t n)
{
  uint8_t* p = dest;
  uint8_t* q = src;
  size_t i = 0;

	// if critical overlap
	// revert copy direction

  if (q < p && p < q + n)
	{
		p = p + n - 1;
		q = q + n - 1;
		while (i < n)
		{
			*p-- = *q--;
			++i;
		}
	}
  else
  {
		while (i < n)
		{
			*p++ = *q++;
			++i;
		}
  }
  return dest;
}

void* memset(void* dest, uint8_t val, size_t n)
{
  uint8_t* p = dest;
  size_t i = 0;
  while (i < n)
  {
    *p++ = val;
    ++i;
  }
  return dest;
}


static uint32_t rand_val = 27182811;

uint32_t rand()
{
	rand_val = (314159261 * rand_val  + 1) % (1 << 29);
	return rand_val >> 5;
}

