`timescale 1ns / 1ps

module instruction_memory (
    input             clk,
    input             reset,
    input             write_enable,
    input      [18:0] instruction_in,
    input      [3:0]  pc,
    input             flush_jump,
    output reg [18:0] instruction_code
);

    reg [18:0] memory [0:15];
    reg [3:0]  write_ptr;

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            write_ptr <= 0;
            instruction_code <= 0;
       
            for (i = 0; i < 16; i = i + 1) begin
              
                    memory[i] <= 19'd0;
            end
        end 
        else if (flush_jump) begin
            memory[pc] <= 19'd0;  
        end
        else if (write_enable) begin
            memory[write_ptr] <= instruction_in;
            write_ptr <= (write_ptr == 4'd15) ? 4'd0 : write_ptr + 4'd1;
        end
    end

    always @(*) begin
        instruction_code = memory[pc - 1]; 
    end

endmodule
