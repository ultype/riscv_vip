# 1. Compile & Link (Standard)
riscv64-unknown-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -c start.s -o start.o
riscv64-unknown-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -c main.c -o main.o
riscv64-unknown-elf-ld -m elf32lriscv -T linker.ld start.o main.o -o firmware.elf


# 2. Create a binary of the WHOLE thing
riscv64-unknown-elf-objcopy -O binary firmware.elf firmware.bin

# 3. Convert to 32-bit Hex
#    This file will contain code at the top, followed immediately by data.
hexdump -v -e '1/4 "%08x" "\n"' firmware.bin > ram.hex
