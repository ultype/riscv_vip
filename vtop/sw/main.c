#include <stdint.h>

// Global variable (Lives in .data)
volatile int counter = 0; 

// Uninitialized variable (Lives in .bss, must be 0 at start)
volatile int flag;        

// The Trap Handler
uintptr_t handle_trap(uintptr_t mcause, uintptr_t mepc) {
    if (mcause & (1UL << 31)) { // For RV32 (use 1UL<<63 for RV64)
        // It's an interrupt
        counter++; 
        return mepc; // Return to same instruction
    } else {
        // It's an exception (error), skip instruction
        return mepc + 4; 
    }
}

int main() {
    // Local variable (Lives on Stack)
    int local_var = 10;
    
    // Test BSS (If this fails, start.s didn't clear BSS correctly)
    if (flag != 0) {
        // Error state
        while(1); 
    }

    // Main loop
    while (1) {
        counter++;
        local_var++;
    }
    
    return 0;
}
