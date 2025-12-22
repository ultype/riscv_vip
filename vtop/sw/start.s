/* Filename: start.s */
.section .text.init
.global _start
.global _trap_vector_entry  /* Make accessible for debugging */

_start:
    /* ------------------------------------------------ */
    /* 1. Initialize Global Pointer (gp)                */
    /* ------------------------------------------------ */
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop

    /* ------------------------------------------------ */
    /* 2. Initialize Stack Pointer (sp)                 */
    /* ------------------------------------------------ */
    la sp, _stack_top

    /* ------------------------------------------------ */
    /* 3. Setup Interrupt Vector (mtvec)                */
    /* ------------------------------------------------ */
    /* Load address of our trap handler wrapper */
    la t0, _trap_vector_entry
    
    /* Clear the mode bits (last 2 bits) to 0 for DIRECT mode.
       Direct Mode = All traps jump to the same address. */
    andi t0, t0, -4 
    
    /* Write to mtvec CSR (requires Zicsr extension) */
    csrw mtvec, t0

    /* ------------------------------------------------ */
    /* 4. Clear BSS Section                             */
    /* ------------------------------------------------ */
    la t0, _bss_start
    la t1, _bss_end
    bge t0, t1, bss_done

bss_loop:
    sw zero, 0(t0)
    addi t0, t0, 4
    blt t0, t1, bss_loop

bss_done:

    /* ------------------------------------------------ */
    /* 5. Enable Global Interrupts (Optional)           */
    /* ------------------------------------------------ */
    /* Uncomment next line to enable interrupts immediately before main */
    /* csrs mstatus, 8 */  /* Set MIE bit (Bit 3) */

    /* ------------------------------------------------ */
    /* 6. Jump to C Code                                */
    /* ------------------------------------------------ */
    call main

loop_forever:
    j loop_forever


/* ==================================================== */
/* INTERRUPT / TRAP HANDLER WRAPPER                   */
/* ==================================================== */
/* This code runs whenever an interrupt fires.          */
/* We must save registers before calling C code.        */
/* ==================================================== */
.align 4
_trap_vector_entry:
    /* 1. Decrease Stack Pointer to make room for context */
    addi sp, sp, -128      /* Save space for 32 registers (32*4 bytes) */

    /* 2. Save Context (Caller-Saved Registers + RA + EPC) */
    sw ra,  0(sp)
    sw t0,  4(sp)
    sw t1,  8(sp)
    sw t2, 12(sp)
    sw a0, 16(sp)
    sw a1, 20(sp)
    sw a2, 24(sp)
    sw a3, 28(sp)
    sw a4, 32(sp)
    sw a5, 36(sp)
    sw a6, 40(sp)
    sw a7, 44(sp)
    sw t3, 48(sp)
    sw t4, 52(sp)
    sw t5, 56(sp)
    sw t6, 60(sp)
    /* Note: In a full OS, you would save s0-s11 too. 
       For bare metal, saving 't' and 'a' regs is usually enough 
       unless your C handler is very complex. */

    /* 3. Call the C Interrupt Handler */
    /* You must define 'void trap_handler(void)' in your C code! */
    call trap_handler

    /* 4. Restore Context */
    lw ra,  0(sp)
    lw t0,  4(sp)
    lw t1,  8(sp)
    lw t2, 12(sp)
    lw a0, 16(sp)
    lw a1, 20(sp)
    lw a2, 24(sp)
    lw a3, 28(sp)
    lw a4, 32(sp)
    lw a5, 36(sp)
    lw a6, 40(sp)
    lw a7, 44(sp)
    lw t3, 48(sp)
    lw t4, 52(sp)
    lw t5, 56(sp)
    lw t6, 60(sp)

    /* 5. Restore Stack Pointer */
    addi sp, sp, 128

    /* 6. Return from Trap (mret) */
    mret
