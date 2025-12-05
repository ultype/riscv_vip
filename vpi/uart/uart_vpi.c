#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <errno.h>
#include <vpi_user.h>

// File descriptor for the serial port
static int serial_fd = -1; 

// --- VPI Helper Functions: Serial Port Configuration ---
int set_interface_attribs (int fd, int speed)
{
    struct termios tty;
    if (tcgetattr (fd, &tty) != 0) {
        vpi_printf("Error %d from tcgetattr\n", errno);
        return -1;
    }

    cfsetospeed (&tty, speed);
    cfsetispeed (&tty, speed);

    // 8N1 Configuration
    tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8;
    tty.c_iflag &= ~IGNBRK;
    tty.c_lflag = 0;                // non-canonical processing
    tty.c_oflag = 0;
    tty.c_cc[VMIN]  = 0;            // non-blocking read due to VTIME
    tty.c_cc[VTIME] = 5;            // 0.5 seconds read timeout

    tty.c_iflag &= ~(IXON | IXOFF | IXANY); // disable software flow control

    tty.c_cflag |= (CLOCAL | CREAD); // enable reading, ignore modem controls
    tty.c_cflag &= ~(PARENB | PARODD); // disable parity
    tty.c_cflag &= ~CSTOPB;
    tty.c_cflag &= ~CRTSCTS; // disable hardware flow control

    if (tcsetattr (fd, TCSANOW, &tty) != 0) {
        vpi_printf("Error %d from tcsetattr\n", errno);
        return -1;
    }
    return 0;
}

// --- $uart_init VPI Task (TX/RX Initialization) ---
PLI_INT32 uart_init_compiletf(PLI_BYTE8 *user_data) 
{
    return 0;
}

PLI_INT32 uart_init_calltf(PLI_BYTE8 *user_data)
{
    vpiHandle arg_iterator = vpi_iterate(vpiArgument, vpi_handle(vpiSysTfCall, NULL));
    s_vpi_value val;
    PLI_BYTE8 *port_name;
    int baud_rate;
    int speed_const = B115200; 

    vpiHandle arg_handle = vpi_scan(arg_iterator);
    val.format = vpiStringVal;
    vpi_get_value(arg_handle, &val);
    port_name = val.value.str;

    arg_handle = vpi_scan(arg_iterator);
    val.format = vpiIntVal;
    vpi_get_value(arg_handle, &val);
    baud_rate = val.value.integer;

    vpi_free_object(arg_iterator);

    // Baud Rate Mapping
    if (baud_rate == 9600) speed_const = B9600;
    else if (baud_rate == 115200) speed_const = B115200;

    serial_fd = open(port_name, O_RDWR | O_NOCTTY | O_SYNC);
    if (serial_fd < 0) {
        vpi_printf("VPI Error: Failed to open serial port %s. Check permissions.\n", port_name);
        vpi_control(vpiFinish, 1);
        return 0;
    }

    if (set_interface_attribs (serial_fd, speed_const) < 0) { 
        vpi_printf("VPI Error: Failed to configure serial port %s.\n", port_name);
        close(serial_fd);
        serial_fd = -1;
        vpi_control(vpiFinish, 1);
        return 0;
    }
    
    vpi_printf("VPI Info: UART connection initialized (TX/RX) on %s at %d baud.\n", port_name, baud_rate);
    return 0;
}

// --- $uart_tx VPI Task (Single Byte TX) ---
PLI_INT32 uart_tx_compiletf(PLI_BYTE8 *user_data) 
{
    return 0;
}

PLI_INT32 uart_tx_calltf(PLI_BYTE8 *user_data)
{
    if (serial_fd < 0) {
        vpi_printf("VPI Error: $uart_tx called before $uart_init.\n");
        return 0;
    }

    vpiHandle arg_iterator = vpi_iterate(vpiArgument, vpi_handle(vpiSysTfCall, NULL));
    s_vpi_value val;
    char tx_byte;

    vpiHandle arg_handle = vpi_scan(arg_iterator);
    val.format = vpiIntVal;
    vpi_get_value(arg_handle, &val);
    tx_byte = (char)(val.value.integer & 0xFF); 
    vpi_free_object(arg_iterator);

    // TX 輸出邏輯
    if (write(serial_fd, &tx_byte, 1) != 1) {
        vpi_printf("VPI Error: Failed to write byte to serial port.\n");
    } else {
        tcdrain(serial_fd); 
    }
    return 0;
}

// --- $uart_tx_string VPI Task (String TX) --- 
PLI_INT32 uart_tx_string_compiletf(PLI_BYTE8 *user_data) 
{
    return 0;
}

PLI_INT32 uart_tx_string_calltf(PLI_BYTE8 *user_data)
{
    if (serial_fd < 0) {
        vpi_printf("VPI Error: $uart_tx_string called before $uart_init.\n");
        return 0;
    }

    vpiHandle arg_iterator = vpi_iterate(vpiArgument, vpi_handle(vpiSysTfCall, NULL));
    s_vpi_value val;
    PLI_BYTE8 *tx_string;

    vpiHandle arg_handle = vpi_scan(arg_iterator);
    val.format = vpiStringVal;
    vpi_get_value(arg_handle, &val);
    tx_string = val.value.str;
    int len = strlen(tx_string);
    vpi_free_object(arg_iterator);

    // TX 輸出邏輯
    if (write(serial_fd, tx_string, len) != len) {
        vpi_printf("VPI Error: Failed to write the full string to serial port.\n");
    } else {
        tcdrain(serial_fd); 
    }
    
    return 0;
}

// --- $uart_rx_byte VPI Task (Single Byte RX) --- (Reads, Prints, and Echoes reliably)
PLI_INT32 uart_rx_byte_compiletf(PLI_BYTE8 *user_data) 
{
    return 0;
}

PLI_INT32 uart_rx_byte_calltf(PLI_BYTE8 *user_data)
{
    if (serial_fd < 0) {
        vpi_printf("VPI Error: $uart_rx_byte called before $uart_init.\n");
        return 0;
    }

    vpiHandle arg_iterator = vpi_iterate(vpiArgument, vpi_handle(vpiSysTfCall, NULL));
    vpiHandle arg_handle = vpi_scan(arg_iterator);
    vpi_free_object(arg_iterator);

    char rx_byte;
    int n = read(serial_fd, &rx_byte, 1); 

    if (n == 1) {
        int received_int = (int)(rx_byte & 0xFF);

        // --- Ctrl+D (0x04) Finish Check ---
        if (received_int == 0x04) {
            vpi_printf("\n--- VPI Control: Received Ctrl+D (0x04). Terminating simulation with $finish. ---\n");
            vpi_control(vpiFinish, 0); 
            return 0;
        }

        // 1. PLI UART 在 Terminal 顯示接到的 char (顯示)
        vpi_printf("VPI Rx Info: Received 0x%02X ('%c'). Echoing back...\n", received_int, rx_byte);

        // 2. 透過 PLI UART TX 傳送 char 給 picocom UART RX (迴傳)
        int write_status = write(serial_fd, &rx_byte, 1); // 寫入到連接 picocom 的 serial_fd

        if (write_status != 1) {
             vpi_printf("VPI ECHO CRITICAL FAILURE: Failed to write echo byte (TX) - Status: %d, Errno: %d\n", write_status, errno);
        } else {
             // 關鍵步驟: 確保資料在返回前被完全發送到串列埠
             tcdrain(serial_fd); 
        }

        // 3. 將資料注入 Verilog 暫存器
        s_vpi_value val;
        val.format = vpiIntVal;
        val.value.integer = received_int;
        
        vpi_put_value(arg_handle, &val, NULL, vpiNoDelay);
    } else if (n < 0) {
        vpi_printf("VPI Rx Error: Read failed with error code %d.\n", errno);
    } 
    return 0;
}

// --- PLI/VPI Registration ---
typedef struct t_vpi_systf_data s_tf_data;

void uart_vpi_register()
{
    s_tf_data tf_data[4]; 

    // $uart_init
    tf_data[0].type      = vpiSysTask;
    tf_data[0].tfname    = "$uart_init"; 
    tf_data[0].calltf    = uart_init_calltf;
    tf_data[0].compiletf = uart_init_compiletf;
    vpi_register_systf(&tf_data[0]);
    
    // $uart_tx (byte)
    tf_data[1].type      = vpiSysTask;
    tf_data[1].tfname    = "$uart_tx"; 
    tf_data[1].calltf    = uart_tx_calltf;
    tf_data[1].compiletf = uart_tx_compiletf;
    vpi_register_systf(&tf_data[1]);

    // $uart_tx_string (string)
    tf_data[2].type      = vpiSysTask;
    tf_data[2].tfname    = "$uart_tx_string"; 
    tf_data[2].calltf    = uart_tx_string_calltf;
    tf_data[2].compiletf = uart_tx_string_compiletf;
    vpi_register_systf(&tf_data[2]);

    // $uart_rx_byte (byte)
    tf_data[3].type      = vpiSysTask;
    tf_data[3].tfname    = "$uart_rx_byte"; 
    tf_data[3].calltf    = uart_rx_byte_calltf;
    tf_data[3].compiletf = uart_rx_byte_compiletf;
    vpi_register_systf(&tf_data[3]);
}

// Icarus Verilog PLI/VPI entry point
void (*vlog_startup_routines[])() = {
    (void (*)())uart_vpi_register,
    NULL
};
