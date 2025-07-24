`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2025 22:03:51
// Design Name: 
// Module Name: instruction_mem
//Instruction memory 16 size each 19 bit wide
// 
//////////////////////////////////////////////////////////////////////////////////


module instruction_memory (
input clk,
input reset,
input [3:0] pc,
output reg [18:0] instruction_code
    );
    
   reg [18:0] memory [0:15]; 
    always@(posedge clk or posedge reset)
    begin
    if(reset) begin
    memory[0]  <= 19'b0000000000000000000;
    memory[1]  <= 19'b0000_0010_0001_0011_001; // ADD
    memory[2]  <= 19'b0000_0001_0011_0100_001; // SUB
    memory[3]  <= 19'b0010_0010_0001_0011_001; // MUL
    memory[4]  <= 19'b0011_0010_0001_0011_001; // DIV
    memory[5]  <= 19'b0000_0001_0001_0010_010; // INC
    memory[6]  <= 19'b0001_1111_0001_0010_010; // DEC
    memory[7]  <= 19'b0100_0010_0001_0011_001; // AND
    memory[8]  <= 19'b0101_0010_0001_0011_001; // OR
    memory[9]  <= 19'b0110_0010_0001_0011_001; // XOR
    memory[10] <= 19'b0111_0000_0001_0010_001; // NOT
    memory[11] <= 19'b0000_0100_0000_0000_101; // JMP
    memory[12] <= 19'b0000_0010_0001_0010_100; // BEQ
    memory[13] <= 19'b0001_0010_0001_0011_100; // BNE
    memory[14] <= 19'b0000_1010_0000_0000_101; // CALL
    memory[15] <= 19'b0001_0000_0000_0000_101; // RET
    
    
    end
    
    end
    
    always@(*)begin
    instruction_code=memory[pc];
    end
    
    
    
    
    
    
    
    
    
    
endmodule
