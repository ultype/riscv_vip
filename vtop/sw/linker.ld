/* Filename: link.ld */
OUTPUT_ARCH( "riscv" )
ENTRY( _start )

MEMORY
{
  /* Instruction Memory: 0x00000000 -> 0x003FFFFF (4MB) */
  IMEM (rx) : ORIGIN = 0x00000000, LENGTH = 4M

  /* Data Memory:        0x00400000 -> 0x007FFFFF (4MB) */
  DMEM (rw) : ORIGIN = 0x00400000, LENGTH = 4M
}

SECTIONS
{
  /* --- Code Section (IMEM) --- */
  .text : {
    *(.text.init)
    *(.text)
    *(.text.*)
  } > IMEM

  /* --- Data Sections (DMEM) --- */
  .rodata : {
    . = ALIGN(4);
    *(.rodata)
    *(.rodata.*)
  } > DMEM

  .data : {
    . = ALIGN(4);
    __global_pointer$ = . + 0x800;
    *(.data)
    *(.data.*)
    *(.sdata)
  } > DMEM

  .bss : {
    . = ALIGN(4);
    _bss_start = .;
    *(.bss)
    *(.bss.*)
    *(COMMON)
    . = ALIGN(4);
    _bss_end = .;
  } > DMEM

  /* Stack at the very end of DMEM */
  . = ALIGN(16);
  _stack_top = ORIGIN(DMEM) + LENGTH(DMEM);
}