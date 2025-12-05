module uart_tx_only (
    input clk,
    input rst,
    output uart_tx 
);
    // Dummy RTL for VPI demonstration
    assign uart_tx = 1'b1; 
endmodule


module uart_vpi_tb;

    reg clk = 1'b0;
    reg rst = 1'b1;
    wire uart_tx;
    reg [7:0] rx_data_buffer = 8'h00; // Register to hold received data

    uart_tx_only UUT (
        .clk(clk),
        .rst(rst),
        .uart_tx(uart_tx)
    );

    // Clock generation
    always #5 clk = ~clk; 

    initial begin
        // 1. Initialize the VPI connection
        $uart_init("/dev/pts/0", 115200); 

        #10 rst = 1'b0;
        #100; 
        
        $uart_tx_string("UART VPI Initialized. TX and RX active.\n\r");
        
        // Loop forever to continuously poll for incoming data
        forever begin
            #100; // Check for new data every 100ns (simulation time)
            
            // Call the VPI RX function
            $uart_rx_byte(rx_data_buffer);
        end
    end

    // Monitor the RX buffer and echo the received character
    always @(rx_data_buffer) begin
        if (rx_data_buffer != 8'h00) begin
            $display("TB Rx: Received 0x%02h ('%c'). Echoing back...", rx_data_buffer, rx_data_buffer);
            
            // Echo the received character back out via TX VPI function
            // $uart_tx(rx_data_buffer);
            // $uart_tx(8'h0a); // Line feed for clarity
            
            // Reset the buffer value so the monitor doesn't trigger again 
            // until a *new* unique value is written by the VPI.
            rx_data_buffer = 8'h00; 
        end
    end

endmodule
