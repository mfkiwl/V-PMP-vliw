CC=gcc
TARGET=pmp_asm

all: ./src/common.h ./src/main.c ./src/utils.c ./src/opcode.h
	$(CC) $^ -fno-stack-protector -o $(TARGET)

clean: 
	rm -rf $(TARGET) i_mem.vhd
