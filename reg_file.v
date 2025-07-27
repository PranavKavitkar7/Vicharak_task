`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2025 22:13:42
// Design Name: General Purpose registers 16 32 Bit wide 
// Module Name: reg_file

//////////////////////////////////////////////////////////////////////////////////


module register_file(
input clk,
input reset,
input [3:0] rs1,
input [3:0] rs2,
input [3:0] rd,
input [31:0] write_imm,
input [31:0] write_reg_data,
input write_en_imm,
input write_reg,
output [31:0] out_rs1,
output [31:0] out_rs2




    );
    
    reg[31:0] regs[15:0];
    integer i;
    assign out_rs1=regs[rs1];
    assign out_rs2=regs[rs2];
    
    
    always@(posedge clk or posedge reset)begin
    if (reset) begin
    
    for (i=0;i<16;i=i+1)
    regs[i]<=32'b0;
    
    end
    else begin
    if (write_en_imm)begin
    regs[rd]<=write_imm;
    end
    else if (write_reg) begin
    regs[rd]<=write_reg_data;
    
    end
    end
    end
    endmodule
    
    
    
    
    
    
    
    
    
    
    
    
    
    

