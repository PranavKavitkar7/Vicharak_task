`timescale 1ns / 1ps

module top_tb;

    reg clk;
    reg reset;

    // Instantiate the top module
    top uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation: 10ns period (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Initial reset (inactive)
    initial begin
        reset = 1;
        #10
        reset=0;
        #100 $finish;
    end

endmodule
