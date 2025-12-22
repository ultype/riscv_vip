/* Filename: link.ld */
OUTPUT_ARCH( "riscv" )
ENTRY( _start )

MEMORY
{
   /* Single 16MB Block for EVERYTHING */
   /* (rwx) = Read, Write, Execute */
   /* ORIGIN = 0, LENGTH = 16M (0x01000000 bytes) */
   RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 16M
}

SECTIONS
{
  /* ================================================= */
  /* 1. CODE (.text) - At the very bottom              */
  /* ================================================= */
  .text : {
    *(.text.init)   /* Boot code at 0x00000000 */
    *(.text)
    *(.text.*)
  } > RAM

  /* ================================================= */
  /* 2. READ-ONLY DATA (.rodata)                       */
  /* ================================================= */
  .rodata : {
    . = ALIGN(4);
    *(.rodata)
    *(.rodata.*)
  } > RAM

  /* ================================================= */
  /* 3. INITIALIZED DATA (.data)                       */
  /* ================================================= */
  .data : {
    . = ALIGN(4);
    __global_pointer$ = . + 0x800;
    *(.data)
    *(.data.*)
    *(.sdata)
  } > RAM

  /* ================================================= */
  /* 4. UNINITIALIZED DATA (.bss)                      */
  /* ================================================= */
  .bss : {
    . = ALIGN(4);
    _bss_start = .;
    *(.bss)
    *(.bss.*)
    *(COMMON)
    . = ALIGN(4);
    _bss_end = .;
  } > RAM

  /* ================================================= */
  /* 5. HEAP & STACK                                   */
  /* ================================================= */
  /* Heap starts right after BSS */
  . = ALIGN(16);
  _end = .;
  _heap_start = .;

  /* Stack Top is pinned to the very top of the 16MB RAM */
  /* New Address: 0x01000000 */
  . = ALIGN(16);
  _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}