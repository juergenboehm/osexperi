#ifndef __drivers_vga_h
#define __drivers_vga_h

#include "kerneltypes.h"
#include "fs/gendrivers.h"
#include "fs/vfs.h"


void screen_goto(int screen, int line, int col);
int screen_reset(int screen, int line, int col, int a_num_lines, int a_line_width);

void screen_print_char(int screen, uint8_t ch);
void screen_blank(int screen);

int screen_update();


// file system interface

int vga_open(inode_t* inode, file_t* fil);
int vga_write(file_t* fil, char* buf, size_t count, size_t* offset);



#define NUM_SCREENS		4

#define MAX_NUM_LINES 	32
#define MAX_LINE_WIDTH	128


typedef struct screen_info_s {

	uint8_t* pt;
	uint8_t	out_x;
	uint8_t out_y;

	uint8_t color_byte;

	uint_t line_width;
	uint_t num_lines;

	uint8_t* buffer_base;

} screen_info_t;

extern screen_info_t screen_info_blks[NUM_SCREENS];

extern int screen_current;
extern int screen_current_old;


#endif
