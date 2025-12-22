// In main.c
#include <stdint.h>
#define DEBUG_BASE 0x90000000
volatile int mcause_reg = 0;
static int32_t* DEBUG_FINISH_PTR = (int32_t*) DEBUG_BASE;
// This function is called by assembly when an interrupt occurs
void trap_handler(void) {
    // 1. Read mcause to see WHY we are here
    uint32_t mcause;
    asm volatile("csrr %0, mcause" : "=r"(mcause));

    // 2. Check if it's an interrupt (MSB is 1) or Exception (MSB is 0)
    if (mcause & 0x80000000) {
        // It's an Interrupt (e.g., Timer, External)
    } else {
        // It's an Exception (e.g., Illegal Instruction)
    }
}

int main() {
	
	volatile int count = 0;
	while(count<10){
		count++;
	}	
    // ... your code ...
    *DEBUG_FINISH_PTR = 1;
}
