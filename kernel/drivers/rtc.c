
#include "drivers/hardware.h"
#include "drivers/rtc.h"




uint32_t get_rtc_clock_in_sec()
{
	return 0;
}

uint8_t read_rtc_reg(uint8_t reg)
{
	IRQ_CLI_SAVE(eflags);
	outb(CMOS_ADDRESS, reg);

	io_wait();

	uint8_t retval = inb(CMOS_DATA);

	IRQ_RESTORE(eflags);
	return retval;
}

int is_update_in_progress()
{
	return read_rtc_reg(0x0a) & 0x80;
}


int wait_for_uip_set_clear_transition()
{
	while (!is_update_in_progress());
	while (is_update_in_progress());
	return 0;
}

#define BCD_TO_DECIMAL(x) (((x) >> 4) * 10 + ((x) & 0x0f))

// set means is not bcd but binary mode
#define FORMAT_BINARY_FLAG		0x04

//set means is 24h mode not am/pm mode
#define FORMAT_24H_FLAG		0x02


int get_rtc_clock(tm_t* ptime)
{

	wait_for_uip_set_clear_transition();

	uint8_t second = read_rtc_reg(0x00);
	uint8_t minute = read_rtc_reg(0x02);
	uint8_t hour = read_rtc_reg(0x04);
	uint8_t day = read_rtc_reg(0x07);
	uint8_t month = read_rtc_reg(0x08);
	uint8_t year = read_rtc_reg(0x09);

	uint8_t rtc_regB = read_rtc_reg(0x0b);

	uint8_t hour_is_pm = hour & 0x80;
	hour &= 0x7f;

	if (!(rtc_regB & FORMAT_BINARY_FLAG))
	{
		//convert from BCD to decimal
		second = BCD_TO_DECIMAL(second);
		minute = BCD_TO_DECIMAL(minute);
		hour = BCD_TO_DECIMAL(hour);
		day = BCD_TO_DECIMAL(day);
		month = BCD_TO_DECIMAL(month);
		year = BCD_TO_DECIMAL(year);
	}
	if (!(rtc_regB & FORMAT_24H_FLAG))
	{
		hour = hour % 12 + (hour_is_pm ? 12 : 0);
	}

	uint32_t year_long = 2000 + year;

	ptime->sec = second;
	ptime->minute = minute;
	ptime->hour = hour;
	ptime->day = day;
	ptime->month = month;
	ptime->year = year_long;

	return 0;
}

