module vpi_console (
    input aclk,
    input aresetn,
    
    // Interface to CPU (Memory-Mapped Registers)
    output reg rx_intr,                 
    output [$clog2(BUFFER_DEPTH):0] rx_fill_level, 
    
    // CPU Buffer Read Interface (Read/Dequeue operation)
    output wire [7:0] rx_buffer_data_out, 
    input wire rx_buffer_read_strobe,     
    
    // VPI Interface 
    input wire [7:0] tx_data_in,
    input wire tx_data_valid 
);

// --- VPI System Task/Function Declarations (Corrected) ---

// FIX: $vpi_getc is a FUNCTION and must be declared as such.

// --- Local Parameters and Constants ---
parameter BUFFER_DEPTH = 1024;
localparam ASCII_BACKSPACE = 8'h08;
localparam ASCII_ENTER     = 8'h0A;
localparam ASCII_CR        = 8'h0D;
localparam ASCII_MONEY     = 8'h24;
localparam ASCII_MOUSE     = 8'h40;

// --- Buffer Registers (Circular Buffer) ---
reg [7:0] line_buffer [0:BUFFER_DEPTH-1];
reg [9:0] head_ptr; 
reg [9:0] tail_ptr; 

// --- Internal Control Registers ---
reg rx_data_available; 
reg [7:0] rx_char;
reg [9:0] next_tail_ptr;

// --- AXI/CPU Interface Wires ---
wire [10:0] calculated_fill;
assign calculated_fill = (tail_ptr >= head_ptr) ? (tail_ptr - head_ptr) : (BUFFER_DEPTH - head_ptr + tail_ptr);

assign rx_fill_level = calculated_fill[10:0]; 

assign rx_buffer_data_out = line_buffer[head_ptr];

// --- VPI Polling Logic ---
reg [3:0] rx_poll_counter = 0;
localparam POLL_RATE = 0;
reg [31:0] char_code_reg; // Receives output from $vpi_getc

always @(posedge aclk) begin
    if (!aresetn) begin
        rx_poll_counter <= 0;
        rx_data_available <= 1'b0;
    end else begin
        rx_poll_counter <= rx_poll_counter + 1;
        
        if (rx_poll_counter == POLL_RATE) begin
            rx_poll_counter <= 0;
            
            // FIX: Call the VPI Function and assign its return value
            char_code_reg = $vpi_getc(1); 
            
            if (char_code_reg != 0) begin
                rx_char <= char_code_reg[7:0];
                rx_data_available <= 1'b1;
            end
        end else if (rx_data_available) begin
            rx_data_available <= 1'b0;
        end
    end
end

// --- RX Buffer and Line-Editing Logic ---
always @(posedge aclk) begin
    if (!aresetn) begin
        head_ptr <= 0;
        tail_ptr <= 0;
        rx_intr <= 1'b0;
    end else begin
        
        // --- Dequeue Logic (CPU Read) ---
        if (rx_buffer_read_strobe && (head_ptr != tail_ptr)) begin
            head_ptr <= head_ptr + 1;
            if (head_ptr == BUFFER_DEPTH - 1) head_ptr <= 0;

            if (rx_fill_level == 1) rx_intr <= 1'b0;
        end

        // --- Enqueue/Edit Logic (VPI Write) ---
        if (rx_data_available) begin
            
            next_tail_ptr = tail_ptr + 1;
            if (tail_ptr == BUFFER_DEPTH - 1) next_tail_ptr = 0;

            if (rx_char == ASCII_ENTER) begin
                if (calculated_fill > 0) begin
                    line_buffer[tail_ptr] <= rx_char;
                    tail_ptr <= next_tail_ptr;
                    rx_intr <= 1'b1;
                end
                $vpi_putc(ASCII_ENTER);// Space
                $display("Receive Enter!\n");
            end else if (rx_char == ASCII_BACKSPACE) begin
                if (calculated_fill > 0) begin
                    tail_ptr <= (tail_ptr == 0) ? (BUFFER_DEPTH - 1) : tail_ptr - 1;
                    
                    $vpi_putc(ASCII_BACKSPACE);
                    $vpi_putc(8'h20); // Space
                    $vpi_putc(ASCII_BACKSPACE);
                end
                rx_intr <= 0;
            end else if (next_tail_ptr != head_ptr) begin 
                line_buffer[tail_ptr] <= rx_char;
                tail_ptr <= next_tail_ptr;
                $vpi_putc(rx_char);
                rx_intr <= 0;
            end  else begin
                $vpi_putc(8'h07); // ASCII Bell
                rx_intr <= 0;
            end
        end else begin
            rx_intr <= 0;
        end
    end
end

// --- TX Logic (Simple Pass-through for Bi-directionality) ---
always @(posedge aclk) begin
    if (tx_data_valid) begin
        $vpi_putc(tx_data_in); 
    end
end

endmodule
