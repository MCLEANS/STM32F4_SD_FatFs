
# list of source files
#CXX SOURCE_FILES
CXX_SOURCES = main.cpp
CXX_SOURCES += clockconfig.cpp

#C SOURCE FILES
#SOURCES  = main.c
SOURCES  += ./dependencies/system_stm32f4xx.c
SOURCES += ./dependencies/stm32f4xx_it.c
SOURCES += ./startup/startup_stm32f40_41xxx.s

#------------FATFS-----------------------------#
SOURCES += ./sd_src/misc.c 
SOURCES += ./sd_src/stm32f4xx_dma.c 
SOURCES += ./sd_src/stm32f4xx_gpio.c 
SOURCES += ./sd_src/stm32f4xx_rcc.c 
SOURCES += ./sd_src/stm32f4xx_sdio.c 
SOURCES += ./sd_src/stm32f4xx_spi.c 
SOURCES += ./sd_src/tm_stm32f4_delay.c 
SOURCES += ./sd_src/tm_stm32f4_fatfs.c 
SOURCES += ./sd_src/tm_stm32f4_gpio.c 
SOURCES += ./sd_src/tm_stm32f4_spi.c
SOURCES += ./fatfs/diskio.c 
SOURCES += ./fatfs/ff.c 
SOURCES += ./fatfs/drivers/fatfs_sd_sdio.c
SOURCES += ./fatfs/option/syscall.c 
SOURCES += ./fatfs/option/unicode.c



# name for output binary files
PROJECT = main

# compiler, objcopy (should be in PATH)
CC = arm-none-eabi-gcc
CXX = arm-none-eabi-g++
OBJCOPY = arm-none-eabi-objcopy

# path to st-flash (or should be specified in PATH)
ST_FLASH = st-flash

# specify compiler flags
CFLAGS  = -g -O2 -Wall
CFLAGS += -T  STM32F417IG_FLASH.ld -specs=nano.specs -specs=nosys.specs
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=soft -mfpu=fpv4-sp-d16
CFLAGS += -DSTM32F40_41xxx
CFLAGS += -Wl,--gc-sections
CFLAGS += -I ./Includes
CFLAGS += -I .

#-------------FATFS--------------------#
CFLAGS += -I ./fatfs
CFLAGS += -I ./fatfs/drivers
CFLAGS += -I ./sd_includes

all: $(PROJECT).elf

# compile
$(PROJECT).elf: $(CXX_SOURCES)
	$(CXX) $(CFLAGS) $(CXX_SOURCES) $(SOURCES) -o $@
	$(OBJCOPY) -O ihex $(PROJECT).elf $(PROJECT).hex
	$(OBJCOPY) -O binary $(PROJECT).elf $(PROJECT).bin

# remove binary files
clean:
	rm -f *.o *.elf *.hex *.bin

# flash
flash:
	sudo $(ST_FLASH) write $(PROJECT).bin 0x8000000
