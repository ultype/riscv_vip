`timescale 1ns / 100ps

`define PERIOD 10     
`define SIM_TIME 999   

module soc_tb();
    reg clk;
    reg core_nrst, sram_nrst;
    reg [31:0] idata [0:1024];
    reg [31:0] ddata [0:1024];
    reg [31:0] tdata;

    integer file;
    integer scan_result;
    integer count=0, i=0, j=0;
    // Clock generation: 100 MHz
    initial begin
        clk = 0;
    end
    always #(`PERIOD) clk = ~clk;
    
    soc_top#(
    .DATA_WIDTH(32),
    .ADDR_WIDTH(32),
    .ID_WIDTH(1)
    ) soc_top_dut
    (
        .clk(clk),
        .core_nrst(core_nrst),
        .sram_nrst(sram_nrst)
    );
    
    //simulation
    initial begin
        // 1. Specify the output file name
        $dumpfile("wave.vcd");

        // 2. Dump all variables
        // Format: $dumpvars(level, module_instance);
        // 0 = Recursive (everything below), soc_tb = your top module name
        $dumpvars(0, soc_top_dut);

        //read imem.hex and dmem.hex
        core_nrst = 1'd0;
        sram_nrst = 1'd0;
        #(`PERIOD * 20);
        sram_nrst = 1'd1;

        //load imem and dmem
        file = $fopen("./sw/imem.hex", "r");    
        if (file == 0) begin
            $display("Error: Could not open file.");
            $finish;
        end
        count = 0;
        // 2. Loop until End of File (EOF)
        while (!$feof(file)) begin
            // Read one hex value (%h) into temp_data
            scan_result = $fscanf(file, "%h", tdata);
            // scan_result returns the number of items matched (should be 1)
            if (scan_result == 1) begin
                soc_top_dut.iram.mem[count] = tdata;
                count = count + 1;
            end
        end
        // 3. Close file
        $fclose(file);

        $display("Loaded idata from imem.hex:%4d", count);

        file = $fopen("./sw/dmem.hex", "r");    
        if (file == 0) begin
            $display("Error: Could not open file.");
            $finish;
        end
        count = 0;
        // 2. Loop until End of File (EOF)
        while (!$feof(file)) begin
            // Read one hex value (%h) into temp_data
            scan_result = $fscanf(file, "%h", tdata);
            // scan_result returns the number of items matched (should be 1)
            if (scan_result == 1) begin
                 soc_top_dut.dram.mem[count] = tdata;
                count = count + 1;
            end
        end
        // 3. Close file
        $fclose(file);
        $display("Loaded idata from dmem.hex:%4d", count);
        
        // must clear cache ram
        for (i = 0; i < 16384; i = i + 1) begin
            soc_top_dut.soc0.u_tcm.u_ram.ram[i] = 32'd0;
        end

        $display("Start Riscv Simulation ...");
        #(`PERIOD * 20);
        core_nrst = 1'd1;
        #(`SIM_TIME);
        $display("Simulation finished at %0t ns", $time);
        $finish;
    end
endmodule
