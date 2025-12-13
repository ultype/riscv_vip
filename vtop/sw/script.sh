# 1. Compile & Link (Standard)
riscv64-unknown-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -c start.s -o start.o
riscv64-unknown-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -c main.c -o main.o
riscv64-unknown-elf-ld -m elf32lriscv -T linker.ld start.o main.o -o full.elf

# 2. Extract IMEM Hex (Code)
# Step 1: Extract raw binary (no headers, just bytes)
riscv64-unknown-elf-objcopy -O binary --only-section=.text full.elf imem.bin
# Step 2: Format to 32-bit hex per line
# -v : Do not suppress repeated lines (keeps all zeros)
# -e : Format string '1/4' (1 unit of 4 bytes) printed as '%08x' (8 hex digits)
hexdump -v -e '1/4 "%08x" "\n"' imem.bin > imem.hex

# Step 1: Extract raw binary with address shifts
riscv64-unknown-elf-objcopy -O binary \
    --remove-section=.text \
    --set-section-flags .bss=alloc,load,contents \
    --change-section-lma .data=-0x00400000 \
    --change-section-lma .rodata=-0x00400000 \
    --change-section-lma .bss=-0x00400000 \
    full.elf dmem.bin

# Step 2: Format to 32-bit hex per line
hexdump -v -e '1/4 "%08x" "\n"' dmem.bin > dmem.hex
