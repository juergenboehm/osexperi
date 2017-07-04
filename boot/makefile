

ccflags = -m32 -Os -c -march=i686 -nostdinc -nostdlib -ffreestanding -Werror
ccflagsS = $(ccflags) -DASM_SOURCE=1

ldflags = -melf_i386 --cref

# objects in bootsector

objects_boot = boot.o


# headers

headers = *.h 
headerboot = boot/*.h 
headerslibs16 = libs16/*.h
headerslibs16 = libs32/*.h
headerslibs   = libs/*.h

headerskernel = kernel16/*.h libs16/*.h libs32/*.h kernel32/*.h libs/*.h drivers/*.h fs/*.h

headersall = $(headers) $(headersboot) $(headerskernel) $(headerslibs16) $(headerslibs32) \
		$(headerslibs)

debugs = libs16/bioslib.s kernel16/startup.s kernel32/startup32.s drivers/hardware.s



# compiler section

#boot

$(objects_boot): %.o : %.S
	gcc $(ccflagsS) -o $@ -c $<



#ld for boot

boot.bin: $(objects_boot)
	ld $(ldflags) -M -o boot.bin $(objects_boot) -T ./ldscript.boot.ls


# shortcuts



.PHONY	: rebuild
		
		
rebuild : clean all
	




	
			

.PHONY	: clean

clean	:
				rm *.o
				rm boot.bin

	
.PHONY	: all

all	: boot.bin
			dd if=boot.bin of=../bochs/c.img bs=512 count=1 conv=notrunc

