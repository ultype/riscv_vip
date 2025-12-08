.section .text.init
.global _start
.global trap_entry

_start:
    /* ------------------------------------------------ */
    /* 1. Basic init                                    */
    /* ------------------------------------------------ */
    csrw mstatus, zero      /* Disable Interrupts */
    csrw mie, zero          /* Disable Interrupt Enables */
    
    la sp, _stack_top       /* Set Stack Pointer (Required for C) */

    /* Set Global Pointer (Required for linker relaxation) */
.option push
.option norelax
    la gp, __global_pointer$
.option pop

    /* Setup Interrupt Vector */
    la t0, trap_entry
    csrw mtvec, t0

    /* ------------------------------------------------ */
    /* 2. C Runtime Init: Clear BSS (Zero out vars)     */
    /* ------------------------------------------------ */
    la t0, _bss_start
    la t1, _bss_end
    bge t0, t1, bss_done    /* If BSS is empty, skip */

clear_bss_loop:
    sw zero, 0(t0)          /* Write 0 to memory */
    addi t0, t0, 4          /* Go to next word */
    blt t0, t1, clear_bss_loop

bss_done:
    /* ------------------------------------------------ */
    /* 3. Jump to C                                     */
    /* ------------------------------------------------ */
    call main

    /* If main returns, hang here */
hang:
    j hang


/* ==================================================== */
/* Interrupt Handler Wrapper                            */
/* ==================================================== */
.align 4
trap_entry:
    /* 1. Save Context (Caller-saved registers) */
    addi sp, sp, -128       /* Adjust stack size as needed */
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw a0, 16(sp)
    sw a1, 20(sp)
    /* ... save other registers if your C code is complex ... */

    /* 2. Call C Handler */
    csrr a0, mcause         /* Argument 1 */
    csrr a1, mepc           /* Argument 2 */
    call handle_trap

    /* 3. Update Return Address (mepc) */
    /* handle_trap returns the address we should go back to */
    csrw mepc, a0

    /* 4. Restore Context */
    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    lw a0, 16(sp)
    lw a1, 20(sp)
    addi sp, sp, 128

    mret
