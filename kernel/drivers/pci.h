#ifndef __drivers_pci_h
#define __drivers_pci_h


/* PCI functions */

#define PCI_CONFIG_ADDRESS	0xcf8
#define PCI_CONFIG_DATA			0xcfc

typedef struct s_pci_access_data {

	uint16_t bus_number;
	uint16_t device_number;
	uint16_t function_number;
	uint16_t register_number;

} pci_access_data_t;

extern pci_access_data_t pci_addr_ide_contr[1];


uint32_t pci_read_word(uint16_t bus_number, uint16_t device_number, uint16_t function_number, uint16_t register_number);

uint16_t pci_read_hword(uint16_t bus_number, uint16_t device_number, uint16_t function_number, uint16_t register_number, 
			uint16_t hword_num);

uint8_t pci_read_byte(uint16_t bus_number, uint16_t device_number, uint16_t function_number, uint16_t register_number, 
			uint16_t byte_num);


uint16_t pci_read_vendor(uint16_t bus_number, uint16_t device_number, uint16_t function_number);

uint32_t pci_read_class_code_and_subclass(uint16_t bus_number, uint16_t device_number, uint16_t function_number);


void enumerate_pci_bus(pci_access_data_t* pci_addr_ide_contr);

#endif
