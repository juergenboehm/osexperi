
#include "libs/kerneldefs.h"
#include "drivers/hardware.h"
#include "drivers/keyb_decode.h"
#include "fs/vfs.h"

#include "drivers/vga.h"



#define		LINE_WIDTH	screen_info_blks[screen].line_width
#define		NUM_LINES		screen_info_blks[screen].num_lines
#define		BYTES_PER_CHAR	2

#define		BUFFER_ANF	VGA_ADDR
#define		BUFFER_ANF_SCREEN		screen_info_blks[screen].buffer_base

#define		COLOR_BYTE	0x1e

#define		START_ADDR(line,col) (BUFFER_ANF_SCREEN + ((line) * LINE_WIDTH + (col)) * BYTES_PER_CHAR)
#define		START_ADDR_VGA(line,col) (BUFFER_ANF + ((line) * LINE_WIDTH + (col)) * BYTES_PER_CHAR)

screen_info_t screen_info_blks[NUM_SCREENS];
int screen_current;
int screen_current_old;


// file system init

int vga_open(inode_t* inode, file_t* fil)
{
	int minor = GET_MINOR_DEVICE_NUMBER(fil->f_dentry->d_inode->i_device);

	outb_printf(" vga_open reached: minor = %d\n", minor);

	int ret = screen_reset(minor, 0,0, 25, 80);
	return ret;
}

int vga_write(file_t* fil, char* buf, size_t count, size_t* offset)
{

	int minor = GET_MINOR_DEVICE_NUMBER(fil->f_dentry->d_inode->i_device);

	outb_printf("vga_write: minor_number = %d\n", minor);

	size_t i = 0;
	char* p = buf;

	while ((*p) && (i < count))
	{

		uint32_t eflags = irq_cli_save();
		screen_print_char(minor, (uint8_t)(*p));
		irq_restore(eflags);

		fil->f_pos++;
		++i;
		++p;
	}

	return i;
}


int refresh_rectangle(int screen, int line_1, int col_1, int line_2, int col_2)
{
	int i;
	int j;

	if (screen != screen_current) {
		return 1;
	}

	//outb_printf("refresh_rectangle: screen = %d line_1 = %d col_1 = %d line_2 = %d col_2 = %d \n",
	//		screen, line_1, col_1, line_2, col_2);

	for(i = line_1; i < line_2; ++i) {
		for(j = col_1; j < col_2; ++j) {

			uint8_t* p_from = (uint8_t*)START_ADDR(i, j);
			uint8_t* p_to = (uint8_t*)START_ADDR_VGA(i, j);

			//outb_printf("offset p_from = %d ", (uint32_t)(p_from - screen_info_blks[screen].buffer_base));
			//outb_printf("offset p_to = %d ", (uint32_t)(p_to - VGA_ADDR));

			*p_to++ = *p_from++;
			*p_to = *p_from;
		}
	}

	return 0;
}


// cursor control

void switch_cursor(int screen, int state)
{
	uint8_t misc_output_reg = inb(0x3cc);
	io_wait();
	uint16_t reg_access_offset = (misc_output_reg & 0x01) ? 0xd0 : 0xb0;

	uint16_t reg_addr_base = 0x304;
	uint16_t reg_data_base = 0x305;

	uint16_t reg_addr = reg_addr_base + reg_access_offset;
	uint16_t reg_data = reg_data_base + reg_access_offset;

	outb(reg_addr, 0x0a);
	io_wait();
	outb(reg_data, 1 << 5);

}


void cursor_to_line_col(int screen, int line, int col)
{
	uint8_t misc_output_reg = inb(0x3cc);
	io_wait();
	uint16_t reg_access_offset = (misc_output_reg & 0x01) ? 0xd0 : 0xb0;

	uint16_t reg_addr_base = 0x304;
	uint16_t reg_data_base = 0x305;

	uint16_t reg_addr = reg_addr_base + reg_access_offset;
	uint16_t reg_data = reg_data_base + reg_access_offset;

	uint16_t cursor_addr = line * LINE_WIDTH + col;
	uint8_t cursor_addr_low = ((uint8_t)(cursor_addr & 0xff));
	uint8_t cursor_addr_high = ((uint8_t)((cursor_addr >> 8) &0xff));


	outb(reg_addr, 0x0e);
	io_wait();
	outb(reg_data, cursor_addr_high);
	io_wait();

	outb(reg_addr, 0x0f);
	io_wait();
	outb(reg_data, cursor_addr_low);
	io_wait();

}

void update_cursor(int screen)
{
	cursor_to_line_col(screen, screen_info_blks[screen].out_y, screen_info_blks[screen].out_x);
}


// screen output routines


void screen_blank(int screen)
{
	int line = 0;
	int col = 0;

	uint8_t* ptx = (uint8_t*)START_ADDR(line, col);

	screen_goto(screen, 0,0);
	for(line = 0; line < NUM_LINES; ++line)
	{
		for(col = 0; col < LINE_WIDTH; ++col)
		{
			*(ptx++) = ' ';
			*(ptx++) = screen_info_blks[screen].color_byte;
		}
	}

	refresh_rectangle(screen, 0, 0,
			screen_info_blks[screen].num_lines, screen_info_blks[screen].line_width);
}

void insert_empty_last_line(int screen)
{
	uint8_t* dest = (uint8_t*)START_ADDR(NUM_LINES - 1, 0);
	int cnt = 0;
	for(cnt = 0; cnt < LINE_WIDTH; ++cnt)
	{
		*(dest++) = ' ';
		*(dest++) = screen_info_blks[screen].color_byte;
	}

	refresh_rectangle(screen,
			screen_info_blks[screen].num_lines-1, 0,
			screen_info_blks[screen].num_lines, screen_info_blks[screen].line_width);


}

void scroll_upward(int screen)
{
	uint8_t*	dest_addr = (uint8_t*)START_ADDR(0,0);
	uint8_t* src_addr = (uint8_t*)START_ADDR(1,0);

	int num_to_move = (NUM_LINES - 1) * LINE_WIDTH * BYTES_PER_CHAR;
	while( num_to_move > 0)
	{
		*dest_addr = *src_addr;
		dest_addr++;
		src_addr++;
		num_to_move--;
	}
	insert_empty_last_line(screen);

	refresh_rectangle(screen, 0, 0,
			screen_info_blks[screen].num_lines, screen_info_blks[screen].line_width);

}

void normalize_buffer(int screen)
{
	if (screen_info_blks[screen].out_y >= NUM_LINES)
	{
		scroll_upward(screen);
		screen_info_blks[screen].out_y--;
	}
}

// prints at pt
void screen_print_char_visible(int screen, uint8_t ch)
{
	int offset = (screen_info_blks[screen].pt - screen_info_blks[screen].buffer_base);

	int line_size = BYTES_PER_CHAR * screen_info_blks[screen].line_width;

	int line = offset / line_size;
	int col = offset % line_size;

	col = col/BYTES_PER_CHAR;

	*screen_info_blks[screen].pt = ch;
	screen_info_blks[screen].pt++;
	*screen_info_blks[screen].pt = 0x1e;
	screen_info_blks[screen].pt++;

	refresh_rectangle(screen, line, col, line + 1, col + 1);

	screen_info_blks[screen].out_x++;
	if (screen_info_blks[screen].out_x >= LINE_WIDTH)
	{
		screen_info_blks[screen].out_y++;
		screen_info_blks[screen].out_x = 0;
		normalize_buffer(screen);
	}

}



void screen_print_char(int screen, uint8_t ch)
{
	//uint32_t eflags = irq_cli_save();
	switch (ch)
	{
		case '\r':
			screen_info_blks[screen].out_x = 0;
			normalize_buffer(screen);
			screen_info_blks[screen].pt =
					(uint8_t*) START_ADDR(screen_info_blks[screen].out_y, screen_info_blks[screen].out_x);
			break;
		case '\n':
			screen_info_blks[screen].out_x = 0;
			screen_info_blks[screen].out_y++;
			normalize_buffer(screen);
			screen_info_blks[screen].pt =
					(uint8_t*) START_ADDR(screen_info_blks[screen].out_y, screen_info_blks[screen].out_x);
			break;
		case ASCII_BS:
			//printf("BS pressed.\n");
			if (screen_info_blks[screen].out_x > 0) {
				--screen_info_blks[screen].out_x;
				screen_info_blks[screen].pt =
						(uint8_t*) START_ADDR(screen_info_blks[screen].out_y, screen_info_blks[screen].out_x);
				screen_print_char_visible(screen, ' ');
				--screen_info_blks[screen].out_x;
				screen_info_blks[screen].pt =
						(uint8_t*) START_ADDR(screen_info_blks[screen].out_y, screen_info_blks[screen].out_x);
			}
			break;
		default:
			screen_print_char_visible(screen, ch);
			break;
	}

	if (screen == screen_current)
	{
		update_cursor(screen);
	}
	//irq_restore(eflags);
}


void screen_goto(int screen, int line, int col)
{
	screen_info_blks[screen].pt = (uint8_t*) START_ADDR(line, col);
}


int screen_reset(int screen, int line, int col, int a_num_lines, int a_line_width)
{

	if (a_num_lines > MAX_NUM_LINES || a_line_width > MAX_LINE_WIDTH) {
		return -1;
	}

	screen_current = 0;
	screen_current_old = 0;

	uint8_t* p =
			(uint8_t*) kalloc_fixed_aligned(BYTES_PER_CHAR * MAX_NUM_LINES * MAX_LINE_WIDTH, sizeof(uint32_t));

	if (!p) {
		return -1;
	}

	outb_printf("screen_reset: p = %08x\n", (uint32_t)p );

	screen_info_blks[screen].buffer_base = p;

	screen_info_blks[screen].num_lines = a_num_lines;
	screen_info_blks[screen].line_width = a_line_width;
	screen_info_blks[screen].color_byte = COLOR_BYTE;
	screen_blank(screen);
	screen_goto(screen, line, col);

	screen_info_blks[screen].out_x = 0;
	screen_info_blks[screen].out_y = 0;

	update_cursor(screen);

	return 0;
}


int screen_update()
{
	refresh_rectangle(screen_current, 0, 0,
			screen_info_blks[screen_current].num_lines, screen_info_blks[screen_current].line_width);

	update_cursor(screen_current);

	screen_current_old = screen_current;

	return 0;
}

