#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <termios.h>

// --- VPI Headers ---
#include <vpi_user.h> 

// Global storage for original terminal settings
static struct termios original_settings;
static int is_raw_mode_set = 0;

// --- Terminal Setup/Teardown ---

static void set_raw_mode() {
    struct termios new_settings;
    
    if (tcgetattr(STDIN_FILENO, &original_settings) == -1) return;
    new_settings = original_settings;

    // Clear ICANON (line buffering) and ECHO (echoing characters)
    new_settings.c_lflag &= ~(ICANON | ECHO);
    
    // Set minimal read time and bytes (VMIN=1, VTIME=0 for immediate, non-blocking read)
    new_settings.c_cc[VMIN] = 1; 
    new_settings.c_cc[VTIME] = 0;

    if (tcsetattr(STDIN_FILENO, TCSANOW, &new_settings) == -1) return;

    is_raw_mode_set = 1;
    vpi_printf("\n[VPI Bridge] Terminal set to raw mode (RX active). Ready for simulation...\n");
}

static void restore_terminal_settings() {
    if (is_raw_mode_set) {
        tcsetattr(STDIN_FILENO, TCSANOW, &original_settings);
        is_raw_mode_set = 0;
        vpi_printf("\n[VPI Bridge] Restored terminal settings.\n");
    }
}

// --- VPI System Functions (RX and TX) ---

// VPI System Function: $vpi_getc (RX)
// Returns the ASCII value of the character pressed, or 0 if nothing is pressed.
static int vpi_getc_call(char *user_data) {
    char c = 0;
    
    // Ensure raw mode is set before reading
    if (!is_raw_mode_set) {
        set_raw_mode();
    }

    // Attempt to read one character without blocking
    if (read(STDIN_FILENO, &c, 1) == 1) {
        
        // --- CTRL+D CHECK (ASCII 0x04) ---
        if (c == 0x04) {
            vpi_printf("\n[VPI Bridge] Received Ctrl+D (EOT). Terminating simulation...\n");
            // Initiate simulation finish
            vpi_control(vpiFinish); 
            // Return 0 for the character value, though $finish will execute immediately
            c = 0; 
        }

        // Return the ASCII value (or 0 if Ctrl+D was pressed)
        vpi_put_value(vpi_handle(vpiSysTfCall, NULL), 
                      &(s_vpi_value){.format = vpiIntVal, .value.integer = (int)c}, 
                      NULL, vpiNoDelay);
    } else {
        // Return 0 if no data is available
        vpi_put_value(vpi_handle(vpiSysTfCall, NULL), 
                      &(s_vpi_value){.format = vpiIntVal, .value.integer = 0}, 
                      NULL, vpiNoDelay);
    }
    
    return 0; // VPI function return is ignored for system functions
}

// VPI System Task: $vpi_putc (TX)
// Takes an ASCII character from Verilog and prints it to the host console.
static int vpi_putc_call(char *user_data) {
    vpiHandle systf_handle;
    vpiHandle arg_iterator;
    vpiHandle arg_handle;
    s_vpi_value arg_value;

    systf_handle = vpi_handle(vpiSysTfCall, NULL);
    arg_iterator = vpi_iterate(vpiArgument, systf_handle);
    
    if (!arg_iterator) {
        vpi_printf("VPI Error: $vpi_putc requires an argument.\n");
        return 0;
    }

    // Get the first (and only) argument value from Verilog
    arg_handle = vpi_scan(arg_iterator);
    arg_value.format = vpiIntVal;
    vpi_get_value(arg_handle, &arg_value);
    vpi_free_object(arg_iterator);

    // Print the character to the host console (STDOUT)
    char c = (char)arg_value.value.integer;
    write(STDOUT_FILENO, &c, 1);
    fflush(stdout); 

    return 0;
}


// --- VPI Registration and Cleanup ---

void vpi_register_getc_putc() {
    // Register $vpi_getc as a System Function
    s_vpi_systf_data getc_data = {
        .type        = vpiSysFunc,
        .sysfunctype = vpiSysFuncInt,
        .tfname      = "$vpi_getc",
        .calltf      = vpi_getc_call,
        .compiletf   = NULL,
    };
    vpi_register_systf(&getc_data);
    
    // Register $vpi_putc as a System Task
    s_vpi_systf_data putc_data = {
        .type        = vpiSysTask,
        .tfname      = "$vpi_putc",
        .calltf      = vpi_putc_call,
        .compiletf   = NULL,
    };
    vpi_register_systf(&putc_data);
}

// Function to clean up when the simulation finishes
void vpi_final_callback() {
    restore_terminal_settings();
}

// Boilerplate VPI entry point structure
void (*vlog_startup_routines[])(void) = {
    vpi_register_getc_putc,
    NULL
};

// Register the cleanup function to ensure terminal settings are restored
void vlog_shutdown_routines_register() __attribute__((constructor));
void vlog_shutdown_routines_register() {
    vpi_register_cb(&(s_cb_data){.reason = cbEndOfSimulation, .cb_rtn = vpi_final_callback});
}
