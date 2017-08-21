

# number of sectors that loader.bin occupies
loader_sec = 13

# the global debug level
DEB_LEVEL = 0

# the tools

GCC = i686-elf-gcc
LD = i686-elf-gcc


ccflags = -c -DDEBUG_LEVEL=${DEB_LEVEL} -nostdlib -ffreestanding \
		-fno-asynchronous-unwind-tables -Werror
ccflagsS = $(ccflags) -DASM_SOURCE=1

ldflags = -nostdlib #--cref

# objects in a library common to loader and kernel

objectsLib16 =  libs16/print16.o libs16/bioslib.o


# objects in a library of kernel

objectsLib32 =  libs32/klib.o \
		libs32/kalloc.o \
		libs32/utils32.o \
		libs/lists.o \
		libs/structs.o

objectsSLib32 =

objectsLib32All = $(objectsLib32) $(objectsSLib32)

# objects of loader.bin proper

objectsS_loader =  boot/loaderstub.o

objectsC16_loader = boot/loader.o
objectsAll_loader = $(objectsS_loader) $(objectsC16_loader) $(objectsLib16)

# objects of kernel.bin proper

objectsS_kernel16 = kernel16/stub.o
objectsC_kernel16 = kernel16/startup.o


objectsS_kernel32 = kernel32/stub32.o \
			kernel32/irq_stub.o

objectsC_kernel32 = kernel32/startup32.o \
			drivers/hardware.o \
			drivers/pic.o \
			kernel32/irq.o \
			drivers/vga.o \
			drivers/keyb.o \
			drivers/keyb_decode.o \
			drivers/ide.o \
			drivers/timer.o \
			drivers/rtc.o \
			fs/vfs.o \
			fs/ext2.o \
			fs/gendrivers.o \
			fs/bufcache.o \
			fs/vfsext2.o \
			drivers/pci.o \
			mem/paging.o \
			mem/memareas.o \
			mem/memmain.o \
			mem/gdt32.o \
			mem/pagedesc.o \
			mem/vmem_area.o \
			mem/malloc.o \
			kernel32/process.o \
			kernel32/procstart.o \
			kernel32/baseprocs.o \
			kernel32/mutex.o \
			kernel32/proclife.o \
			kernel32/objects.o \
			syscalls/syscalls.o \

objectsC_kernel_user_mode = kernel_user/stdlib.o \
							kernel_user/userproc.o
							
objectsS_kernel_user_mode = kernel_user/userproc_stub.o


objectsS_kernelAux = kernel16/stubAux.o


objects16_kernel = $(objectsLib16) $(objectsS_kernel16) $(objectsC_kernel16)

# note carefully: objectsS_kernel32 must(!) be linked first because it contains
# the default entry point 0x10:0000
objects32_kernel =  $(objectsS_kernel32) $(objectsC_kernel32) $(objectsLib32All)

kernel_objects:   $(objects32_kernel)


#objects_kernel_combined = kernel16/stubAux.o kernel16.o kernel32.o kernel32_user.o
objects_kernel_combined = kernel16/stubAux.o kernel16.o kernel32.o


# headers

headers = *.h
headerboot = boot/*.h
headerslibs16 = libs16/*.h
headerslibs16 = libs32/*.h
headerslibs   = libs/*.h

headerskernel = kernel16/*.h libs16/*.h libs32/*.h kernel32/*.h libs/*.h drivers/*.h fs/*.h mem/*.h syscalls/*.h

headersall = $(headers) $(headersboot) $(headerskernel) $(headerslibs16) $(headerslibs32) \
		$(headerslibs)

debugs = boot/loader.s libs16/bioslib.s kernel16/startup.s kernel32/startup32.s \
		kernel32/process.s drivers/hardware.s kernel_user/stdlib.s kernel32/irq.s syscalls/syscalls.s \
		kernel_user/userproc.s

# ld for loader

loader.bin: $(objectsAll_loader) $(debugs)
	$(LD)  $(ldflags) -o loader.bin $(objectsAll_loader) -T ./ldscript.ld.ls


# ld for kernel

kernel.bin: $(objects_kernel_combined)
	$(LD)  $(ldflags)  -o kernel.bin $(objects_kernel_combined) -T ./ldscript.kr.ls

kernel16.o: $(objects16_kernel)
	$(LD)  $(ldflags) -o kernel16.o $(objects16_kernel) -T ./ldscript.kr16.ls

kernel32.o: $(objects32_kernel)
	$(LD)  $(ldflags) -o kernel32.o  $(objects32_kernel) -lgcc -T ./ldscript.kr32.ls

#kernel32_user.o: $(objectsS_kernel_user_mode) $(objectsC_kernel_user_mode)
#	$(LD) $(ldflags) -o kernel32_user.o $(objectsS_kernel_user_mode) $(objectsC_kernel_user_mode) \
#			 -T ./ldscript.kr32_user.ls

user.bin: $(objectsS_kernel_user_mode) $(objectsC_kernel_user_mode)
	$(LD) $(ldflags) -o user.bin $(objectsS_kernel_user_mode) $(objectsC_kernel_user_mode) \
			 -lgcc -T ./ldscript.user.ls



# shortcuts

.PHONY	: krx


krx	: kernel.bin



.PHONY	: ldx


ldx	: loader.bin

.PHONY	: rebuild


rebuild : clean all





# compiler section

# debug .s

$(debugs): %.s : %.c *.h boot/*.h libs16/*.h
	$(GCC) $(ccflags) -I$(PWD) -I. -I kernel32 -I libs32 -I libs16 -DCODE16 -DKERNEL_LEN=`stat -c %s kernel.bin` -DNUM_LOADER_SEC=$(loader_sec)\
	 -S -o $@ -c $<

#loader

$(objectsLib16): %.o : %.c *.h boot/*.h libs16/*.h
	$(GCC) $(ccflags) -I$(PWD) -I. -DCODE16  -o $@ -c $<

## Attention: NUM_LOADER_SEC must be kept corresponding to size of loader.bin manually

$(objectsC16_loader): %.o : %.c *.h boot/*.h libs16/*.h kernel.bin
	$(GCC) $(ccflags) -I$(PWD) -I. -DCODE16 -DKERNEL_LEN=`stat -c %s kernel.bin` \
		-DNUM_LOADER_SEC=$(loader_sec) -o $@ -c $<

$(objectsS_loader) : %.o : %.S
	$(GCC) $(ccflagsS) -o $@ -c $<

# kernel

$(objectsC_kernel16): %.o : %.c *.h kernel16/*.h libs16/*.h libs32/*.h kernel32/*.h libs/*.h
	$(GCC) $(ccflags) -I$(PWD) -I. -I kernel32 -I libs32 -I libs16 -DCODE16 -o $@ -c $<

$(objectsC_kernel32): %.o : %.c *.h $(headerskernel)
	$(GCC) $(ccflags) -I$(PWD) -I. -I kernel32 -I libs32 -I libs16 -o $@ -c $<


$(objectsS_kernel16) : %.o : %.S
	$(GCC) $(ccflagsS) -I. -o $@ -c $<

$(objectsS_kernelAux) : %.o : %.S
	$(GCC) $(ccflagsS) -I. -o $@ -c $<


$(objectsS_kernel32) : %.o : %.S
	$(GCC) $(ccflagsS) -I. -o $@ -c $<

# kernel usermode

$(objectsC_kernel_user_mode): %.o : %.c *.h $(headerskernel)
	$(GCC) $(ccflags) -I$(PWD) -I. -I kernel32 -I libs32 -I libs16 -o $@ -c $<

$(objectsS_kernel_user_mode) : %.o : %.S
	$(GCC) $(ccflagsS) -I. -o $@ -c $<


# lib32

$(objectsLib32): %.o : %.c *.h libs32/*.h libs/*.h
	$(GCC) $(ccflags) -I$(PWD) -I. -o $@ -c $<

$(objectsSLib32) : %.o : %.S
	$(GCC) $(ccflagsS) -I. -o $@ -c $<


.PHONY	: debug

debug:	kernel16/startup.c $(debugs)
	$(GCC) $(ccflags) -I$(PWD) -I. -I kernel32 -I libs32 -I libs16 -DCODE16 -E -o kernel16/startup1.c -c kernel16/startup.c
	$(GCC) $(ccflags) -I$(PWD) -I. -I kernel32 -I libs32  -S -o mem/paging.S -c mem/paging.c


.PHONY	: clean

clean	:
	rm -f kernel16/*.o
	rm -f boot/*.o
	rm -f libs16/*.o
	rm -f libs32/*.o
	rm -f drivers/*.o
	rm -f kernel32/*.o
	rm -f kernel_user/*.o
	rm -f mem/*.o
	rm -f libs/*.o
	rm -f fs/*.o
	rm -f syscalls/*.o
	rm -f kernel.bin
	rm -f loader.bin
	rm -f user.bin
	rm -f kernel16.o kernel32.o

.PHONY	: all

all	: loader.bin kernel.bin user.bin

.PHONY	: libs

libs	: $(objectsLib16) $(objectsLib32)

