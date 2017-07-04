#ifndef __drivers_ide_h
#define __drivers_ide_h

#include "kerneltypes.h"
#include "libs/utils.h"


/* IDE harddisk functions */

#define 	IDE_PRIM_COMMAND_BLOCK	0x1f0
#define		IDE_PRIM_CONTROL_BLOCK	0x3f4

// Com

#define		IDE_DATA_REG					0x00
#define		IDE_FEATURES_REG			0x01
#define		IDE_SECTOR_COUNT_REG	0x02
#define		IDE_LBA_LOW_REG				0x03
#define		IDE_LBA_MID_REG				0x04
#define		IDE_LBA_HIGH_REG			0x05
#define		IDE_DEVICE_REG				0x06
#define		IDE_COMMAND_REG				0x07


#define		IDE_SEL(x)		(1 << (x))

// Control

#define		IDE_CB_DEVICE_CONTROL		0x02
#define		IDE_CB_ALT_STATUS				0x02

#define		IDE_STATUS_REG				0x07
#define		IDE_ERROR_REG					0x01

#define		IDE_CMD_READ_DMA					0xc8
#define		IDE_CMD_WRITE_DMA					0xca
#define		IDE_CMD_IDENTIFY_DEVICE		0xec

volatile uint32_t ide_irq_sema;
volatile uint32_t ide_res_sema;


typedef struct __PACKED s_ide_ctrlice {

	uint8_t	features;
	uint8_t	error;
	uint8_t	sector_count;
	uint8_t	lba_low;
	uint8_t	lba_mid;
	uint8_t	lba_high;
	uint8_t	device;
	uint8_t	command;
	
	uint8_t	cb_device_control;
	uint8_t	cb_alt_status;
	
	uint8_t	selected_drv;
	
	uint8_t* buffer;
	
	uint8_t	BSY;
	uint8_t	DRDY;
	uint8_t	DF;
	
	uint8_t	DRQ;
	uint8_t	ERR;
	

} ide_ctrl_t;


typedef struct __PACKED s_prd_entry {
	
	uint32_t	base_address;
	uint16_t	byte_count;
	uint16_t upper_hword_eot;

} prd_entry_t;


ide_ctrl_t* ide_ctrl_PM;


uint32_t ide_init();

uint32_t ide_check_status_ok(ide_ctrl_t* ide_ctrl, uint8_t drv_num);

uint32_t ide_prepare_rw(ide_ctrl_t* ide_ctrl, uint16_t sector_count, uint32_t lba, uint8_t drv_num);

uint32_t ide_submit_rw(ide_ctrl_t* ide_ctrl, uint8_t rw);

uint32_t ide_submit_cmd(ide_ctrl_t* ide_ctrl, uint8_t sel_mask);

uint32_t ide_select_drive(ide_ctrl_t* ide_ctrl, uint8_t drv_num);


// currently SET_FEATURE sets only Mode to Ultra-DMA 5

uint32_t ide_SET_FEATURE(ide_ctrl_t* ide_ctrl, uint8_t drv_num);

uint32_t ide_IDENTIFY_DEVICE(ide_ctrl_t* ide_ctrl, uint8_t drv_num);

uint32_t ide_READ_DMA(ide_ctrl_t* ide_ctrl, prd_entry_t* prd_table, 
											uint16_t sector_count, uint32_t lba, uint8_t drv_num);

uint32_t ide_WRITE_DMA(ide_ctrl_t* ide_ctrl, prd_entry_t* prd_table,
											uint16_t sector_count, uint32_t lba, uint8_t drv_num);


void ide_irq_handler(uint32_t errcode, uint32_t irq_num, void* esp);








































#endif
