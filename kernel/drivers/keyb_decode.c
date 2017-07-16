
#include "drivers/vga.h"
#include "drivers/keyb_decode.h"
#include "drivers/keyb.h"
#include "kernel32/mutex.h"


uint8_t mod_state_table_make[KC_TABLESIZE];
uint8_t mod_state_table_break[KC_TABLESIZE];

uint8_t mkc_table_1[KC_TABLESIZE];
uint8_t mkc_table_2[KC_TABLESIZE];

uint8_t brkc_table_1[KC_TABLESIZE];
uint8_t brkc_table_2[KC_TABLESIZE];

uint8_t keycode_to_make_1[KC_TABLESIZE];
uint8_t keycode_to_break_1[KC_TABLESIZE];



uint32_t ascii_normal[KC_TABLESIZE];
uint32_t ascii_shift[KC_TABLESIZE];
uint32_t ascii_altgr[KC_TABLESIZE];


// internal linkage


int process_key_line_1(uint8_t keycode, uint8_t make_code, uint8_t break_code);
int process_key_line_2(uint8_t keycode, uint8_t make_code_1, uint8_t make_code_2,
												uint8_t break_code_1, uint8_t break_code_2 );
uint32_t init_keytables_codes();

static uint32_t akt_state[NUM_SCREENS] = {0, 0, 0, 0};
volatile uint8_t modifier_state[NUM_SCREENS];

// external linkage


int keyb_read(file_t* fil, char* buf, size_t count, size_t* offset)
{
	int keyb_num = GET_MINOR_DEVICE_NUMBER(fil->f_dentry->d_inode->i_device);

	mtx_lock(&key_wait_mutex[keyb_num]);

	uint32_t val = 0;

	while (!val)
	{
		val = read_key_with_modifiers(keyb_num);
	}

	mtx_unlock(&key_wait_mutex[keyb_num]);

	*(uint32_t*) buf = val;

	return 4;
}

#define REL_KB(var) var[keyb_num]

uint32_t read_key_with_modifiers(int keyb_num)
{
	uint32_t key_ret = 0;

	uint32_t keyb_byte = read_keyb_byte(keyb_num);

	if (REL_KB(akt_state) == 0)
	{
		if (mkc_table_1[keyb_byte] == 0xe0)
		{
			REL_KB(akt_state) = 1;
			return key_ret;
		}
		if (mkc_table_1[keyb_byte] != 0xff)
		{
			REL_KB(modifier_state) |= (mod_state_table_make[mkc_table_1[keyb_byte]] & (uint8_t)0xff);
			key_ret =  mkc_table_1[keyb_byte] | (REL_KB(modifier_state) << 8);
			REL_KB(akt_state) = 0;
		}
		else if (brkc_table_1[keyb_byte] != 0xff)
		{
			REL_KB(modifier_state) &= ((~mod_state_table_break[brkc_table_1[keyb_byte]]) & (uint8_t)0xff);
			REL_KB(akt_state) = 0;
		}
	}
	else if (REL_KB(akt_state) == 1)
	{
		if (mkc_table_2[keyb_byte] != 0xff)
		{
			//printf("&");
			if (mkc_table_2[keyb_byte] == VK_Right_Alt)
			{
				//printf(">> got VK_right alt <<");
				REL_KB(modifier_state) |= MODIF_ALTGR;
			}
			key_ret = mkc_table_2[keyb_byte] | (REL_KB(modifier_state) << 8);
			REL_KB(akt_state) = 0;
		}
		else if (brkc_table_2[keyb_byte] != 0xff)
		{
			if (brkc_table_2[keyb_byte] == VK_Right_Alt)
			{
				REL_KB(modifier_state) &= ~MODIF_ALTGR;
			}
			REL_KB(akt_state) = 0;
		}
	}
	else
	{
		REL_KB(akt_state) = 0;
		REL_KB(modifier_state) = 0;
		outb_printf("++++++ keyb_decode: invalid state\n");
	}

  uint8_t vk_key = key_ret & 0xff;
  uint8_t ascii_val = 0;

  if (REL_KB(modifier_state) & MODIF_CTRLL)
  {
  	uint32_t ascii_std = ascii_normal[vk_key];
  	//printf(" modifier state ctrl: ascii_std = %d \n", ascii_std);
  	if (0x61 <= ascii_std && ascii_std <= 0x7a)
  	{
  		ascii_val = ascii_std - 0x60;
  	}
  }
  else
  {
    ascii_val = REL_KB(modifier_state) == 0 ? ascii_normal[vk_key] :
    		REL_KB(modifier_state) & MODIF_ALTGR ? ascii_altgr[vk_key] :
    		REL_KB(modifier_state) & (MODIF_SHIFTL | MODIF_SHIFTR) ? ascii_shift[vk_key]: 0;
  }

  key_ret |= (ascii_val << 16);
  //outb_printf("read_key_with_modifiers (key_num: %d) key_ret: <%08x>", keyb_num, key_ret);
	return key_ret;
}

uint32_t init_keytables()
{
	int i;
	for(i = 0; i < NUM_SCREENS; ++i)
	{
		modifier_state[i] = 0;
	}

	for(i = 0; i < KC_TABLESIZE; ++i)
	{

		mkc_table_1[i] = 0xff;
		mkc_table_2[i] = 0xff;
		brkc_table_1[i] = 0xff;
		brkc_table_2[i] = 0xff;
		mod_state_table_make[i] = 0x00;
		mod_state_table_break[i] = 0x00;

		ascii_normal[i] = 0;
		ascii_shift[i] = 0;
		ascii_altgr[i] = 0;
	}

	for(i = 0; i < 26; ++i)
	{
		ascii_normal[i + VK_A] = i + (uint32_t)('a');
		ascii_shift[i + VK_A] = i + (uint32_t)('A');
	}
	for(i = 0; i < 10; ++i)
	{
		ascii_normal[i + VK_0] = i + (uint32_t)('0');
	}
	ascii_shift[0 + VK_0] = (uint32_t)('=');
	ascii_shift[1 + VK_0] = (uint32_t)('!');
	ascii_shift[2 + VK_0] = (uint32_t)('"');
	ascii_shift[3 + VK_0] = (uint32_t)('#');
	ascii_shift[4 + VK_0] = (uint32_t)('$');
	ascii_shift[5 + VK_0] = (uint32_t)('%');
	ascii_shift[6 + VK_0] = (uint32_t)('&');
	ascii_shift[7 + VK_0] = (uint32_t)('/');
	ascii_shift[8 + VK_0] = (uint32_t)('(');
	ascii_shift[9 + VK_0] = (uint32_t)(')');

	ascii_altgr[7 + VK_0] = (uint32_t)('{');
	ascii_altgr[8 + VK_0] = (uint32_t)('[');
	ascii_altgr[9 + VK_0] = (uint32_t)(']');
	ascii_altgr[0 + VK_0] = (uint32_t)('}');

	ascii_normal[VK_Minus] = (uint32_t)('-');
	ascii_shift[VK_Minus] = (uint32_t)('_');

	ascii_normal[VK_Space] = (uint32_t)(' ');
	ascii_shift[VK_Space] = (uint32_t)(' ');

	ascii_normal[VK_Enter] = (uint32_t)(ASCII_CR);
	ascii_shift[VK_Enter] = (uint32_t)(ASCII_CR);

	ascii_normal[VK_Backspace] = (uint32_t)(ASCII_BS);

	ascii_normal[VK_SZ] = (uint32_t)(225);
	ascii_shift[VK_SZ] = (uint32_t)('?');
	ascii_altgr[VK_SZ] = (uint32_t)('\\');

	//ascii_normal[VK_Acc] = (uint32_t)();
	ascii_shift[VK_Acc] = (uint32_t)('`');

	ascii_normal[VK_Uuml] = (uint32_t)(129);
	ascii_shift[VK_Uuml] = (uint32_t)(154);

	ascii_normal[VK_Plus] = (uint32_t)('+');
	ascii_shift[VK_Plus] = (uint32_t)('*');
	ascii_altgr[VK_Plus] = (uint32_t)('~');

	ascii_normal[VK_Ouml] = (uint32_t)(148);
	ascii_shift[VK_Ouml] = (uint32_t)(153);

	ascii_normal[VK_Auml] = (uint32_t)(132);
	ascii_shift[VK_Auml] = (uint32_t)(142);

	ascii_normal[VK_Caret] = (uint32_t)('^');
	ascii_shift[VK_Caret] = (uint32_t)(248);

	ascii_normal[VK_Hash] = (uint32_t)('#');
	ascii_shift[VK_Hash] = (uint32_t)('\'');

	ascii_normal[VK_Comma] = (uint32_t)(',');
	ascii_shift[VK_Comma] = (uint32_t)(';');

	ascii_normal[VK_Period] = (uint32_t)('.');
	ascii_shift[VK_Period] = (uint32_t)(':');

	ascii_normal[VK_Less] = (uint32_t)('<');
	ascii_shift[VK_Less] = (uint32_t)('>');
	ascii_altgr[VK_Less] = (uint32_t)('|');



	init_keytables_codes();

	mod_state_table_make[VK_Left_Shift] = MODIF_SHIFTL;
	mod_state_table_make[VK_Right_Shift] = MODIF_SHIFTR;
	mod_state_table_make[VK_Right_Alt] = MODIF_ALTGR;
	mod_state_table_make[VK_Left_Ctrl] = MODIF_CTRLL;

	mod_state_table_break[VK_Left_Shift] = MODIF_SHIFTL;
	mod_state_table_break[VK_Right_Shift] = MODIF_SHIFTR;
	mod_state_table_break[VK_Right_Alt] = MODIF_ALTGR;
	mod_state_table_break[VK_Left_Ctrl] = MODIF_CTRLL;

	return 0;
}





int process_key_line_1(uint8_t keycode, uint8_t make_code, uint8_t break_code)
{
	mkc_table_1[make_code] = keycode;
	brkc_table_1[break_code] = keycode;

	keycode_to_make_1[keycode] = make_code;
	keycode_to_break_1[keycode] = break_code;

	return 0;
}


int process_key_line_2(uint8_t keycode, uint8_t make_code_1, uint8_t make_code_2,
												uint8_t break_code_1, uint8_t break_code_2 )
{
	mkc_table_1[make_code_1] = 0xe0;
  mkc_table_2[make_code_2] = keycode;

  brkc_table_1[break_code_1] = 0xe0;
  brkc_table_2[break_code_2] = keycode;

	return 0;
}


uint32_t init_keytables_codes()
{

	process_key_line_1(KC_Backspace);
	process_key_line_1(KC_Caps_Lock);
	process_key_line_1(KC_Enter);
	process_key_line_1(KC_Esc);
	process_key_line_1(KC_Left_Alt);
	process_key_line_1(KC_Left_Ctrl);
	process_key_line_1(KC_Left_Shift);
	process_key_line_1(KC_Num_Lock);
	process_key_line_1(KC_Right_Shift);
	process_key_line_1(KC_Scroll_Lock);
	process_key_line_1(KC_Space);
	process_key_line_1(KC_Sys_Req);
	process_key_line_1(KC_Tab);


	process_key_line_1(KC_F1);
	process_key_line_1(KC_F2);
	process_key_line_1(KC_F3);
	process_key_line_1(KC_F4);
	process_key_line_1(KC_F7);
	process_key_line_1(KC_F5);
	process_key_line_1(KC_F6);
	process_key_line_1(KC_F8);
	process_key_line_1(KC_F9);
	process_key_line_1(KC_F10);
	process_key_line_1(KC_F11);
	process_key_line_1(KC_F12);

	process_key_line_1(KC_A);
	process_key_line_1(KC_B);
	process_key_line_1(KC_C);
	process_key_line_1(KC_D);
	process_key_line_1(KC_E);
	process_key_line_1(KC_F);
	process_key_line_1(KC_G);
	process_key_line_1(KC_H);
	process_key_line_1(KC_I);
	process_key_line_1(KC_J);
	process_key_line_1(KC_K);
	process_key_line_1(KC_L);
	process_key_line_1(KC_M);

	process_key_line_1(KC_N);
	process_key_line_1(KC_O);
	process_key_line_1(KC_P);
	process_key_line_1(KC_Q);
	process_key_line_1(KC_R);
	process_key_line_1(KC_S);
	process_key_line_1(KC_T);
	process_key_line_1(KC_U);
	process_key_line_1(KC_V);
	process_key_line_1(KC_W);
	process_key_line_1(KC_X);
	process_key_line_1(KC_Y);
	process_key_line_1(KC_Z);

	process_key_line_1(KC_0);
	process_key_line_1(KC_1);
	process_key_line_1(KC_2);
	process_key_line_1(KC_3);
	process_key_line_1(KC_4);
	process_key_line_1(KC_5);
	process_key_line_1(KC_6);
	process_key_line_1(KC_7);
	process_key_line_1(KC_8);
	process_key_line_1(KC_9);

	process_key_line_1(KC_Minus);
	process_key_line_1(KC_SZ);
	process_key_line_1(KC_Acc);
	process_key_line_1(KC_Uuml);
	process_key_line_1(KC_Plus);
	process_key_line_1(KC_Ouml);
	process_key_line_1(KC_Auml);
	process_key_line_1(KC_Caret);
	process_key_line_1(KC_Hash);
	process_key_line_1(KC_Comma);
	process_key_line_1(KC_Period);
	process_key_line_1(KC_Less);


	process_key_line_2(KC_Del);
	process_key_line_2(KC_Down_arrow);
	process_key_line_2(KC_End);
	process_key_line_2(KC_Home);
	process_key_line_2(KC_Ins);
	process_key_line_2(KC_Left_arrow);
	process_key_line_2(KC_PgDn);
	process_key_line_2(KC_PgUp);
	process_key_line_2(KC_Right_arrow);
	process_key_line_2(KC_Up_arrow);

	process_key_line_2(KC_Right_Alt);

	return 0;

}
