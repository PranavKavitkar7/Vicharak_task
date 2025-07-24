`timescale 1ns / 1ps

module top_tb;

    reg clk;
    reg reset;

   
    top uut (
        .clk(clk),
        .reset(reset)
    );

    //  (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //  reset
    initial begin
        reset = 1;
        #10
        reset=0;
        #100 $finish;
    end

endmodule
