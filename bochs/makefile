
all	: kr ld

.PHONY	: kr
.PHONY	: krc
.PHONY	: krs
.PHONY	: ldc
.PHONY	: krseek
.PHONY	: lds

krc	:
	cp ../kernel/kernel.bin ./

ldc	:
	cp ../kernel/loader.bin ./



krs	:
	$(eval KKS = $(shell echo "$(shell stat -c %s kernel.bin) / 512" | bc))
	@echo $(KKS)

lds	:
	$(eval LDS = $(shell echo "$(shell stat -c %s loader.bin) / 512" | bc))
	@echo $(LDS)



krseek	:
	$(eval KRSEEK = $(shell echo "$(shell stat -c %s loader.bin) / 512 + 1" | bc))
	@echo $(KRSEEK)



kr	: krc krs krseek
	dd if=./kernel.bin of=./c.img bs=512 count=$(KKS) conv=notrunc seek=$(KRSEEK)


.PHONY	: ld

ld	: ldc lds
	dd if=./loader.bin of=./c.img bs=512 count=$(LDS) conv=notrunc seek=1
	

.PHONY	: it

it	:
	cp ../boot/try ./
	dd if=./try of=./c.img bs=512 count=1 conv=notrunc

.PHONY	: itFD

itFD	:
	cp ../boot/tryFD ./
	dd if=./tryFD of=./a.img bs=512 count=1 conv=notrunc
	

.PHONY	: ldFD

ldFD	: ldc lds 
	dd if=./loader.bin of=./a.img bs=512 count=$(LDS) conv=notrunc seek=1
	

.PHONY	: krFD

krFD	: krc krs krseek
	dd if=./kernel.bin of=./a.img bs=512 count=$(KKS) conv=notrunc seek=$(KRSEEK)


.PHONY	: bofd
	
bofd	: itFD ldFD krFD
	

