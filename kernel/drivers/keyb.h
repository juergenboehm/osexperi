#ifndef __drivers_keyb_h
#define __drivers_keyb_h

#include "kerneltypes.h"
#include "libs/structs.h"

#include "vga.h"

// data fields

#define KEYBUF_SIZE 32

extern uint32_t keyb_special_counter;
extern uint32_t keyb_buf[NUM_SCREENS][KEYBUF_SIZE];

extern queue_contr_t keyb_queue[NUM_SCREENS];


volatile extern uint32_t keyb_sema;


// routines

void keyb_irq_handler(uint32_t errcode, uint32_t irq_num, void* esp);


uint32_t key_avail(int keyb);
uint32_t read_keyb_byte();


uint32_t key_avail_raw(int keyb);
uint32_t read_keyb_byte_raw(int keyb);


uint32_t init_keyboard();

uint32_t reset_keyboard();


#endif
