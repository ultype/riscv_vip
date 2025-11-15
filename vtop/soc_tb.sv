`timescale 1ns / 100ps

`define PERIOD 10     
`define SIM_TIME 999   

module soc_tb();
    reg clk;
    reg nrst;
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
        .nrst(nrst)
    );

    //simulation
    initial begin
        nrst = 1'd0;
        #(`PERIOD * 20);
        nrst = 1'd1;
        #(`SIM_TIME);
        $display("Simulation finished at %0t ns", $time);
        $finish;
    end
endmodule
