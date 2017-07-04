
#include "libs32/klib.h"
#include "drivers/hardware.h"
#include "drivers/pci.h"

// pci device

pci_access_data_t pci_addr_ide_contr[1];



/* PCI bus functions */


uint32_t pci_read_word(uint16_t bus_number, uint16_t device_number, uint16_t function_number, uint16_t register_number)
{

	uint32_t bus = ((uint32_t) (bus_number & 0xff)) << 16;
	uint32_t dev = ((uint32_t) (device_number & 0x1f)) << 11;
	uint32_t fun = ((uint32_t) (function_number & 0x07)) << 8;
	uint32_t reg = ((uint32_t) (register_number & 0x3f)) << 2;

	uint32_t address = ((uint32_t)(1 << 31)) | bus | dev | fun | reg;

	outl( PCI_CONFIG_ADDRESS, address);

	uint32_t res = inl(PCI_CONFIG_DATA);
	return res;

}

uint16_t pci_read_hword(uint16_t bus_number, uint16_t device_number, uint16_t function_number, uint16_t register_number, 
			uint16_t hword_num)
{
	uint32_t word = pci_read_word(bus_number, device_number, function_number, register_number );
	return (uint16_t)((word >> (hword_num * 16)) & 0xffff);
}

uint8_t pci_read_byte(uint16_t bus_number, uint16_t device_number, uint16_t function_number, uint16_t register_number, 
			uint16_t byte_num)
{
	uint32_t word = pci_read_word(bus_number, device_number, function_number, register_number );
	return (uint8_t)((word >> (byte_num * 8)) & 0xff);
}


uint16_t pci_read_vendor(uint16_t bus_number, uint16_t device_number, uint16_t function_number)
{
		uint16_t val = pci_read_hword(bus_number, device_number, function_number, 0x00, 0x00 );
		return val;
}

uint32_t pci_read_class_code_and_subclass(uint16_t bus_number, uint16_t device_number, uint16_t function_number)
{
		uint32_t val = pci_read_word(bus_number, device_number, function_number, 0x02 );
		return val;
}


// enumerieren des PCI-Bus


#define PCI_NUM_IDE_CONTR	2

struct __PACKED { 
	uint16_t v; 
	uint16_t d;
	uint16_t r; 
} pci_ide_controller_list[PCI_NUM_IDE_CONTR] = {{0x8086, 0x7010, 0x20}, {0x8086, 0x7111, 0x20}};


void enumerate_pci_bus(pci_access_data_t* pci_addr_ide_contr)
{
	uint32_t bus_num = 0;
	uint32_t dev_num = 0;
	uint32_t fun_num = 0;
	
	printf("enumerate_pci_bus: start.\n");

	int cnt = 0;
	
	for(bus_num = 0; bus_num < 256; ++bus_num)
	{
		for(dev_num = 0; dev_num < 32; ++dev_num)
		{
		
			fun_num = 0;
		

			uint16_t vendor_id = pci_read_vendor(bus_num, dev_num, fun_num);

			uint16_t device_id = pci_read_hword(bus_num, dev_num, fun_num, 0x00, 0x01);

			uint8_t header_type = pci_read_byte(bus_num, dev_num, fun_num, 0x03, 0x02);

			uint8_t fun_num_max = header_type & 0x80 ? 0x08 : 0x01;

			for(fun_num = 0; fun_num < fun_num_max; ++fun_num)
			{

				uint8_t sub_ord_bus = 0;
				uint8_t sec_bus = 0;
				uint8_t prim_bus = 0;

				uint16_t vendor_id = pci_read_vendor(bus_num, dev_num, fun_num);

				uint16_t device_id = pci_read_hword(bus_num, dev_num, fun_num, 0x00, 0x01);


				if (vendor_id != 0xffff)
				{
					if (header_type == 0x01)
					{
						sub_ord_bus = pci_read_byte(bus_num, dev_num, fun_num, 0x06, 0x02 );
						sec_bus = pci_read_byte(bus_num, dev_num, fun_num, 0x06, 0x01 );
						prim_bus = pci_read_byte(bus_num, dev_num, fun_num, 0x06, 0x00 );
					}
					
					int i = 0;
					for( i = 0; i < PCI_NUM_IDE_CONTR; ++i )
					{
						if ((pci_ide_controller_list[i].v == vendor_id) &&
								(pci_ide_controller_list[i].d == device_id))
						{
							pci_addr_ide_contr->bus_number = bus_num;
							pci_addr_ide_contr->device_number = dev_num;
							pci_addr_ide_contr->function_number = fun_num;
							pci_addr_ide_contr->register_number = pci_ide_controller_list[i].r;	

							printf("ide controller found\n");
						}
					}

					uint32_t class_subclass = pci_read_class_code_and_subclass(bus_num, dev_num, fun_num);
					printf("*** %09d: bus: %02x dev: %02x : fun: %02x : %08x\n", cnt++, bus_num, dev_num, 
							fun_num, class_subclass);
					printf("** DeviceId: %04x Vendor Id: %04x\n", device_id, vendor_id );
					printf("** Header type: %02x: sub: %02x prim: %02x sec: %02x\n\n",
							header_type, sub_ord_bus, prim_bus, sec_bus );

					waitkey();
				}
			}
		}
	}
}
