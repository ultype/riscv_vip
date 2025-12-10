`timescale 1ns / 100ps

module testbench_console;

    // --- Clock and Reset Signals ---
    reg aclk;
    reg aresetn;
    reg start;

    // --- Signals for CPU Interface (RX/Input from Host) ---
    wire rx_intr;
    wire [10:0] rx_fill_level; 
    wire [7:0] rx_buffer_data_out;
    reg rx_buffer_read_strobe;

    // --- Signals for CPU Interface (TX/Output to Host) ---
    reg tx_data_valid;
    reg [7:0] tx_data_in; // Signal driven by the task to the DUT's input port

    // Instantiate the DUT (vpi_console)
    vpi_console #(
        .BUFFER_DEPTH(1024)
    ) DUT (
        .aclk(aclk),
        .aresetn(aresetn),

        .rx_intr(rx_intr),
        .rx_fill_level(rx_fill_level),
        .rx_buffer_data_out(rx_buffer_data_out),
        .rx_buffer_read_strobe(rx_buffer_read_strobe),
        
        .tx_data_valid(tx_data_valid),
        .tx_data_in(tx_data_in) // Connects to the DUT's tx_data_in port
    );
    
    // --- Clock Generation ---
    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk; // 10ns period (100 MHz)
    end

    // --- TX Task: Sends an ASCII string to the VPI Console ---
    task tx_string;
        input [8*256-1:0] message; 
        input integer message_length;
        integer i;
        reg [7:0] char_code;
        begin
            for (i = 0; i < message_length; i = i + 1) begin
                char_code = message[8*i +: 8]; 
                
                tx_data_in = char_code; 
                tx_data_valid = 1;
                @(posedge aclk);
                tx_data_valid = 0;
                #50; // Delay to simulate CPU clock cycles
            end
        end
    endtask

    // --- RX Task: Reads the complete buffered command ---
    task read_buffer;
        input [9:0] length; 
        integer i;
        reg [7:0] data;
        begin
            for (i = 0; i < length; i = i + 1) begin
                @(posedge aclk);
                
                rx_buffer_read_strobe = 1;
                data = rx_buffer_data_out; 
                
                @(posedge aclk);
                rx_buffer_read_strobe = 0;
                
                if (data != 8'h00)
                    $display("    Byte %0d: ENTER (0x%h)", i, data);
                else
                    $display("    Byte %0d: '%c' (0x%h)", i, data, data);

                #50;
            end
        end
    endtask
    
    // --- Infinite Test Scenario ---
    initial begin
        $dumpfile("./my_simulation.vcd");
        $dumpvars(0, DUT);
        // 1. Reset and Initialization
        aresetn = 0;
        rx_buffer_read_strobe = 0;
        tx_data_valid = 0;
        #100 aresetn = 1;

        // 2. Transmit Initialization Message
        $display("-------------------------------------------------------");
        $display("   [Testbench] Console Interactive Mode Initialized.");
        $display("   Type 'Ctrl+D' to quit the simulation.");
        $display("-------------------------------------------------------");
        
        #50;
        tx_string("Welcome to the CPU Console VIP!\n", 30);
        tx_string("Enter command:\n> ", 18);
        
        // 3. Main Operational Loop (Runs until $finish is called by C code)
        forever begin
            
            // Wait for the CPU to be interrupted (User presses Enter)
            @(posedge aclk);
            if(rx_intr)begin
            	$display("\n-------------------------------------------------------");
            	$display("   [Testbench] RX INTERRUPT RECEIVED! Command Ready.");
            	$display("   Fill Level: %0d bytes", rx_fill_level);
            	$display("-------------------------------------------------------");
            
            	// 4. Simulate CPU reading the buffer
            	read_buffer(rx_fill_level);
            
            	// 5. Provide a response and prompt for the next command
            	tx_string("Command processed. Ready for next command:\n> ", 44);
            end
        end
        
        // Execution will terminate only when vpi_control(vpiFinish) is called by C code
    end
    
    
    
endmodule
