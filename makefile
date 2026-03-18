override BIN := bin
override SRC := src
override FSRC := $(SRC)/boot.S
override OUTPUT := $(BIN)/BootC.boot
override DISK := $(BIN)/BootC.img
override AS := nasm
override AS_FLAGS :=
override AS_OUTPUT :=
override LISTING := temp.lst

$(OUTPUT): $(FSRC) | $(BIN)
	$(AS) $(AS_FLAGS) $< $(AS_OUTPUT) -o $@

$(DISK): $(OUTPUT)
	dd if=/dev/zero of=$(DISK) bs=512 count=2880
	dd if=$(OUTPUT) of=$(DISK) bs=512 conv=notrunc

$(BIN):
	mkdir -p $(BIN)

.PHONY: all
all: $(OUTPUT)

.PHONY: disk
disk: $(DISK)

.PHONY: run
run: $(DISK)
	qemu-system-i386 -drive format=raw,file=$(DISK),if=floppy

.PHONY: clean
clean:
	rm -rf obj bin

.PHONY: l
l:
	objdump -b binary -D $(BIN)/BootC.boot -mi8086 > $(LISTING)

