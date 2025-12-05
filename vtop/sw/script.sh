# 1. Compile & Link (Standard)
riscv64-unknown-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -c start.s -o start.o
riscv64-unknown-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -c main.c -o main.o
riscv64-unknown-elf-ld -m elf32lriscv -T link.ld start.o main.o -o full.elf

# 2. Extract IMEM Hex (Code)
# This stays at 0x00000000, so no shifting needed.
riscv64-unknown-elf-objcopy -O verilog --only-section=.text full.elf imem.hex

# 3. Extract DMEM Hex (Data)
# We use --change-section-lma to shift the address back to 0 
# so your Verilog RAM starts filling at index 0, not index 4194304.
riscv64-unknown-elf-objcopy -O verilog \
    --remove-section=.text \
    --set-section-flags .bss=alloc,load,contents \
    --change-section-lma .data=-0x00400000 \
    --change-section-lma .rodata=-0x00400000 \
    --change-section-lma .bss=-0x00400000 \
    full.elf dmem.hex
