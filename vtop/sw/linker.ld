/* Filename: link.ld */
OUTPUT_ARCH( "riscv" )
ENTRY( _start )

MEMORY
{
  /* Instruction Memory: 64MB starting at 0x80000000 */
  IMEM (rx) : ORIGIN = 0x80000000, LENGTH = 64M

  /* Data Memory: 64MB starting at 0x00000000 */
  DMEM (rw) : ORIGIN = 0x00000000, LENGTH = 64M
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
  
  /* 1. Read-Only Data */
  .rodata : {
    . = ALIGN(4);
    *(.rodata)
    *(.rodata.*)
  } > DMEM

  /* 2. Initialized Data */
  .data : {
    . = ALIGN(4);
    __global_pointer$ = . + 0x800;
    *(.data)
    *(.data.*)
    *(.sdata)
  } > DMEM

  /* 3. BSS Section */
  .bss : {
    . = ALIGN(4);
    _bss_start = .;
    *(.bss)
    *(.bss.*)
    *(COMMON)
    . = ALIGN(4);
    _bss_end = .;
  } > DMEM

  /* ------------------------------------------------------------------ */
  /* 4. HEAP SECTION (Fixed 32KB)                                       */
  /* ------------------------------------------------------------------ */
  .heap : {
    . = ALIGN(16);
    _heap_start = .;    /* Start of Heap (used by malloc/sbrk) */
    _end = .;           /* Standard symbol for libc */
    
    . = . + 32K;        /* RESERVE 32KB SPACE HERE */
    
    _heap_end = .;      /* Hard limit for Heap */
  } > DMEM

  /* ------------------------------------------------------------------ */
  /* 5. STACK SECTION (Fixed 32KB)                                      */
  /* ------------------------------------------------------------------ */
  .stack : {
    . = ALIGN(16);
    _stack_bottom = .;  /* Bottom of stack (Stack Overflow triggers here) */
    
    . = . + 32K;        /* RESERVE 32KB SPACE HERE */
    
    _stack_top = .;     /* Initial Stack Pointer (SP) value */
  } > DMEM
}
