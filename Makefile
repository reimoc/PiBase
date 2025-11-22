RPI_VERSION ?= 4

ARMGNU ?= aarch64-linux-gnu

COPS = -DRPI_VERSION=$(RPI_VERSION) -Wall -nostdlib -nostartfiles -ffreestanding \
	   -Iinclude -mgeneral-regs-only

ASMOPS = -Iinclude

BUILD_DIR = build
SRC_DIR = src
OUTPUT_DIR = output/rpi$(RPI_VERSION)


KERNEL_ELF = $(BUILD_DIR)/kernel8-rpi$(RPI_VERSION).elf
KERNEL_MAP = $(BUILD_DIR)/kernel8-rpi$(RPI_VERSION).map
KERNEL_IMG = kernel8-rpi$(RPI_VERSION).img


all : $(KERNEL_IMG)

CLEAN_VERSIONS = 4

#Dynamic rules for clean
$(foreach v,$(CLEAN_VERSIONS),\
  $(eval clean$(v): ; rm -rf $(BUILD_DIR) $(OUTPUT_DIR)/rpi$(v))\
)

#Deletes current RPI_VERSION-Directory 
clean :
	rm -rf $(BUILD_DIR) output/rpi$(RPI_VERSION)

#Compile C-Files
$(BUILD_DIR)/%_c.o: $(SRC_DIR)/%.c
	mkdir -p $(@D)
	$(ARMGNU)-gcc $(COPS) -MMD -c $< -o $@

#Compile ASM-Files
$(BUILD_DIR)/%_s.o: $(SRC_DIR)/%.S
	mkdir -p $(@D)
	$(ARMGNU)-gcc $(COPS) -MMD -c $< -o $@

C_FILES = $(wildcard $(SRC_DIR)/*.c)
ASM_FILES = $(wildcard $(SRC_DIR)/*.S)
OBJ_FILES = $(C_FILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%_c.o)
OBJ_FILES += $(ASM_FILES:$(SRC_DIR)/%.S=$(BUILD_DIR)/%_s.o)

DEP_FILES = $(OBJ_FILES:%.o=%.d)
-include $(DEP_FILES)

$(KERNEL_IMG): $(SRC_DIR)/linker.ld $(OBJ_FILES)

	@echo ""
	@echo "===================================="
	@echo " Building for Raspberry Pi $(RPI_VERSION)"
	@echo " Output: $(KERNEL_IMG)"
	@echo "===================================="

	mkdir -p $(OUTPUT_DIR)
	$(ARMGNU)-ld -T $(SRC_DIR)/linker.ld -o $(KERNEL_ELF) $(OBJ_FILES) -Map=$(KERNEL_MAP)
	$(ARMGNU)-objcopy $(KERNEL_ELF) -O binary $(KERNEL_IMG)

	cp $(KERNEL_IMG) $(OUTPUT_DIR)/
	cp config.txt $(OUTPUT_DIR)/ || true
	sync

	@echo "Generating LLVM disassembly..."
	llvm-objdump -d $(KERNEL_ELF) > $(BUILD_DIR)/kernel8-rpi$(RPI_VERSION)_llvm.asm

.PHONY: rpi4

rpi4 :
	$(MAKE) RPI_VERSION=4 clean4 all