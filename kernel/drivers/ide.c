
#include "kerneltypes.h"

#include "libs/kerneldefs.h"
#include "libs32/klib.h"

#include "drivers/hardware.h"
#include "drivers/pic.h"
#include "drivers/pci.h"
#include "drivers/ide.h"



/* IDE harddisk functions */

static uint16_t bmibase = 0;

#define IDE_BM_COMMAND		(bmibase + 0x00)
#define IDE_BM_STATUS			(bmibase + 0x02)
#define IDE_BM_IDTP				(bmibase + 0x04)

#define IDE_ERROR_NOT_READY			0xffff
#define IDE_STATE_NO_DATA				0xfffe


// was 0xb1
#define IDE_DMA_MODE_BYTE_OFFSET	0xb0



static uint8_t dma_mode_byte = 0;
static uint8_t current_is_write = 0;


uint32_t ide_PACKET()
{
	uint16_t outbas = IDE_PRIM_COMMAND_BLOCK;
	uint16_t	outcnt = IDE_FEATURES_REG;
	uint16_t outport = outbas + outcnt;

	outb(outport++, 0x01);
	outb(outport++, 0x00 );
	outport++;
	outb(outport++, 0x00 );
	outb(outport++, 0x00 );
	outb(outport++, 0x00 );

	outb(outbas + IDE_COMMAND_REG, 0xa0);

	return 1;



}


static ide_ctrl_t ide_ctrl_blk[4];



/* checking if ready for command */


uint32_t ide_set_status(ide_ctrl_t* ide_ctrl, uint8_t ide_status)
{
	ide_ctrl->BSY 	= 	(ide_status & (1 << 7)) >> 7;
	ide_ctrl->DRDY = 	(ide_status & (1 << 6)) >> 6;
	ide_ctrl->DF 	= 	(ide_status & (1 << 5)) >> 5;
	ide_ctrl->DRQ 	= 	(ide_status & (1 << 3)) >> 3;
	ide_ctrl->ERR 	= 	(ide_status & (1 << 0)) >> 0;

	return 0;
}

uint32_t	ide_select_drive(ide_ctrl_t* ide_ctrl, uint8_t drv_num)
{

// TODO: Enter 400ns code

	ide_ctrl->selected_drv = drv_num;

	return 0;
}

uint32_t ide_check_status_ok(ide_ctrl_t* ide_ctrl, uint8_t drv_num)
{

	if (ide_ctrl->selected_drv == drv_num)
	{

		uint8_t drv_status = inb(IDE_PRIM_COMMAND_BLOCK + IDE_STATUS_REG);
		ide_set_status(ide_ctrl, drv_status);

		return !(ide_ctrl->BSY) && !(ide_ctrl->DRQ) ? 0x0 : IDE_ERROR_NOT_READY;
	}
	else
	{
		ide_select_drive(ide_ctrl, drv_num);
		uint32_t ok = ide_check_status_ok(ide_ctrl, drv_num);
		return ok;
	}
}

#define PCICMD_REG	0x04
#define IDETIM_REG	0x40


uint32_t ide_init(pci_access_data_t* pci_dev)
{
	bmibase = (uint16_t)(pci_read_word(pci_dev->bus_number, pci_dev->device_number,
																		pci_dev->function_number, pci_dev->register_number >> 2) & 0xffff);
	bmibase &= 0xfffc; // lowest two bits zeroed out

	ide_irq_sema = 0;
	ide_res_sema = 0;


	uint16_t pcicmd_val = (uint16_t)(pci_read_word(pci_dev->bus_number, pci_dev->device_number,
																		pci_dev->function_number, PCICMD_REG >> 2) & 0xffff);

	uint16_t idetim_val = (uint16_t)(pci_read_word(pci_dev->bus_number, pci_dev->device_number,
			pci_dev->function_number, IDETIM_REG >> 2) & 0xffff);


	printf("pcicmd = %08x, idetim = %08x\n", pcicmd_val, idetim_val);


	memset(ide_ctrl_blk, 0, sizeof(ide_ctrl_blk));

	ide_ctrl_PM = ide_ctrl_blk;

	outb(IDE_PRIM_CONTROL_BLOCK + IDE_CB_DEVICE_CONTROL, 0x00);  //nIEN: bit 1 is zero, enable interrupts
	outb(IDE_BM_COMMAND, 0x00);
	outb(IDE_BM_STATUS, 0x00);

	//ide_PACKET();

	return 1;

}

uint32_t ide_SET_FEATURE(ide_ctrl_t* ide_ctrl, uint8_t drv_num)
{
	uint32_t ok = ide_check_status_ok(ide_ctrl, drv_num);

	if (ok == IDE_ERROR_NOT_READY)
	{
		return ok;
	}

	printf("ide_SET_FEATURE: dma_mode_byte = %02x\n", dma_mode_byte);

	uint32_t mode_cnt = 0;
	while(((1 << mode_cnt) & dma_mode_byte) && (mode_cnt < 5))
	{
		++mode_cnt;
	}

	printf("ide_SET_FEATURE: mode_cnt = %08x\n", (uint32_t) mode_cnt);

	ide_ctrl->features = 0x03; // subcommand 03
	//ide_ctrl->sector_count = 0x45; // Ultra DMA 5 mode
	ide_ctrl->sector_count = 0x40 | (uint8_t)mode_cnt;

	ide_ctrl->command = 0xef; // command SET_FEATURE

	// FEATURES_REG, SECTOR_COUNT_REG, COMMAND_REG
	ide_submit_cmd(ide_ctrl, IDE_SEL(IDE_FEATURES_REG) | IDE_SEL(IDE_SECTOR_COUNT_REG)
										| IDE_SEL(IDE_COMMAND_REG) );


	uint8_t drv_status = inb(IDE_PRIM_COMMAND_BLOCK + IDE_STATUS_REG);
	ide_set_status(ide_ctrl, drv_status);

	return drv_status;
}



uint32_t ide_IDENTIFY_DEVICE(ide_ctrl_t* ide_ctrl, uint8_t drv_num)
{
	uint8_t* buf = ide_ctrl->buffer;

	uint32_t ok = ide_check_status_ok(ide_ctrl, drv_num);

	if (ok == IDE_ERROR_NOT_READY)
	{
		return ok;
	}

	printf("ide_IDENTIFY_DEVICE: start\n" );

	ide_ctrl->device = 0xa0 | ((ide_ctrl->selected_drv & 0x01) << 4);
	ide_ctrl->command = IDE_CMD_IDENTIFY_DEVICE;

	// DEVICE_REG, COMMAND_REG
	ide_submit_cmd(ide_ctrl, IDE_SEL(IDE_DEVICE_REG) | IDE_SEL(IDE_COMMAND_REG));


	printf("ide_IDENTIFY_DEVICE: end:\n" );
	printf("ide_IDENTIFY_DEVICE: ide_irq_sema = %08x\n", ide_irq_sema);

	while(!ide_irq_sema)
	{
	}
	ide_irq_sema = 0;

	// in the irq routine the non-busmaster/pio path must be activated.

	if (!(ide_res_sema & 0xff)) // means ok
	{
		int i = 0;

		uint16_t pioIn = IDE_PRIM_COMMAND_BLOCK + IDE_DATA_REG;

		for(i = 0; i < 512; i+=2)
		{
			*(uint16_t*)(buf+i) = inw(pioIn);
		}
	}

	dma_mode_byte = buf[IDE_DMA_MODE_BYTE_OFFSET];

	printf("ide_IDENTIFY_DEVICE: dma_mode_byte = %08x\n", (uint16_t)*((uint16_t *)(buf+176)));

	return ide_res_sema;
}



uint32_t ide_prepare_rw(ide_ctrl_t* ide_ctrl, uint16_t sector_count, uint32_t lba, uint8_t drv_num)
{

	uint32_t ok = ide_check_status_ok(ide_ctrl, drv_num);

	if (ok == IDE_ERROR_NOT_READY)
	{
		return ok;
	}

	ide_ctrl->sector_count = (uint8_t)(sector_count & 0xff);
	ide_ctrl->lba_low = (uint8_t)(lba & 0xff);
	ide_ctrl->lba_mid = (uint8_t)((lba >> 8) & 0xff);
	ide_ctrl->lba_high = (uint8_t)((lba >> 16) & 0xff);
	ide_ctrl->device = (uint8_t)((lba >> 24) & 0x0f);

	ide_ctrl->device |= (0x40 | ((0x01 & ide_ctrl->selected_drv)<<4));

	return 1;
}

uint32_t ide_submit_cmd(ide_ctrl_t* ide_ctrl, uint8_t sel_mask)
{
	uint16_t obas = IDE_PRIM_COMMAND_BLOCK;

	printf("ide_submit_cmd: start:");

	if (sel_mask & 0x02)
		outb(obas + IDE_FEATURES_REG, ide_ctrl->features);
	if (sel_mask & 0x04)
		outb(obas + IDE_SECTOR_COUNT_REG, ide_ctrl->sector_count);
	if (sel_mask & 0x08)
		outb(obas + IDE_LBA_LOW_REG, ide_ctrl->lba_low );
	if (sel_mask & 0x10)
		outb(obas + IDE_LBA_MID_REG, ide_ctrl->lba_mid );
	if (sel_mask & 0x20)
		outb(obas + IDE_LBA_HIGH_REG, ide_ctrl->lba_high );
	if (sel_mask & 0x40)
		outb(obas + IDE_DEVICE_REG, ide_ctrl->device );
	if (sel_mask & 0x80)
		outb(obas + IDE_COMMAND_REG, ide_ctrl->command );

	printf("ide_submit_cmd: end:\n" );

	return 0;

}



uint32_t ide_submit_rw(ide_ctrl_t* ide_ctrl, uint8_t is_write)
{

	ide_ctrl->command = is_write ? IDE_CMD_WRITE_DMA : IDE_CMD_READ_DMA;

	// submit all registers but not the features reg
	ide_submit_cmd(ide_ctrl, 0xff & ~0x01 & ~IDE_SEL(IDE_FEATURES_REG));

	return 1;
}

uint32_t ide_busmaster_prepare(prd_entry_t* prd_table, uint8_t is_write)
{

	current_is_write = is_write;

	outl(IDE_BM_IDTP, (uint32_t)__PHYS(prd_table));

// read/write bit 3 = 1 for read = 0 for write (sic!)

	outb(IDE_BM_COMMAND, (uint8_t) (is_write ? 0x00 : (0x01 << 3)));


// reset IDE IRQ status, IDE DMA Error

	uint8_t val = inb(IDE_BM_STATUS);

	val |= (0x11 << 1);
	//val |= (0x01 << 1);

	outb(IDE_BM_STATUS, val);

	return 1;

}

uint32_t ide_busmaster_engage()
{
	outb(IDE_BM_COMMAND, ((current_is_write ? 0x00 : (0x01 << 3))) | 0x01); // start Bus Master
	return 1;

}


uint32_t ide_READ_DMA(ide_ctrl_t* ide_ctrl, prd_entry_t* prd_table,
											uint16_t sector_count, uint32_t lba, uint8_t drv_num)
{

	uint32_t size = sector_count * 512;

	prd_table[0].base_address = (uint32_t)__PHYS(ide_ctrl->buffer);
	prd_table[0].byte_count = size;
	prd_table[0].upper_hword_eot = 0x8000;

	ide_busmaster_prepare(prd_table, 0x00);

	printf("ide_READ_DMA: bmibase = %04x\n", bmibase );

	uint32_t ok = ide_prepare_rw(ide_ctrl, sector_count, lba, drv_num);

	if (ok == IDE_ERROR_NOT_READY)
	{
		return ok;
	}


	ide_submit_rw(ide_ctrl, 0x00);

	ide_busmaster_engage();

	printf("ide_READ_DMA: wait for ide_irq_sema\n" );

	while(! ide_irq_sema)
	{
	}
	ide_irq_sema = 0;

	ide_set_status(ide_ctrl, (uint8_t)(ide_res_sema & 0xff));

	return ide_res_sema;
}

uint32_t ide_WRITE_DMA(ide_ctrl_t* ide_ctrl, prd_entry_t* prd_table,
										uint16_t sector_count, uint32_t lba, uint8_t drv_num)
{

	uint32_t size = sector_count * 512;

	prd_table[0].base_address = (uint32_t)__PHYS(ide_ctrl->buffer);
	prd_table[0].byte_count = size;
	prd_table[0].upper_hword_eot = 0x8000;

	ide_busmaster_prepare(prd_table, 0x01);

	uint32_t ok = ide_prepare_rw(ide_ctrl, sector_count, lba, drv_num);

	if (ok == IDE_ERROR_NOT_READY)
	{
		return ok;
	}


	ide_submit_rw(ide_ctrl, 0x01);

	ide_busmaster_engage();

	while(! ide_irq_sema)
	{
	}
	ide_irq_sema = 0;

	ide_set_status(ide_ctrl, (uint8_t)(ide_res_sema & 0xff));

	return ide_res_sema;
}


void ide_irq_handler(uint32_t errcode, uint32_t irq_num, void* esp)
{

	printf("\nide irq caught.\n");

	//uint8_t* vga_addr = (uint8_t*)(uint32_t)VGA_ADDR;

	uint8_t val_com = inb(IDE_BM_COMMAND);

	uint8_t val_stat = inb(IDE_BM_STATUS);

	printf("val_com = %02x, val_stat = %02x\n", val_com, val_stat);


	if (val_com & 0x01)
	{

		// bus master has been active

		printf("bus master has been active: valcom = %02x.\n", val_com);

		outb(IDE_BM_COMMAND, 0x00); // stop Bus Master

		uint8_t val = inb(IDE_BM_STATUS); // read Bus Master status byte

		uint8_t stat_dsk = inb(IDE_PRIM_CONTROL_BLOCK + IDE_CB_ALT_STATUS);

		stat_dsk = inb(IDE_PRIM_COMMAND_BLOCK + IDE_STATUS_REG);

		ide_res_sema = (val << 8) | stat_dsk;

		ide_irq_sema = 1;

	}
	else
	{
		// maybe a PIO caused IRQ requesting data read/write

		uint8_t bsy = 1;
		uint8_t drq = 0;

		uint8_t stat_dsk;

		printf("non busmaster path\n");

		do
		{

			stat_dsk = inb(IDE_PRIM_CONTROL_BLOCK + IDE_CB_ALT_STATUS);

			stat_dsk = inb(IDE_PRIM_COMMAND_BLOCK + IDE_STATUS_REG);

			bsy = stat_dsk & 0x80;
			drq = stat_dsk & 0x08;

		} while ((bsy) && (!drq));

		if (!bsy && drq)
		{
			ide_res_sema = stat_dsk << 8;
			ide_irq_sema = 1;
		}
		else
		{
			ide_res_sema = IDE_STATE_NO_DATA;
			ide_irq_sema = 1;
		}
	}

	// port A is command port. used to acknowledge interrupt.

	outb(PIC1_COMMAND, PIC_EOI);
	io_wait();
	outb(PIC2_COMMAND, PIC_EOI);
	io_wait();


}

