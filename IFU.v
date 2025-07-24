`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2025 19:38:58
// Design Name: 
// Module Name: IFU
// Project Name: Vicharak Intern Application Task
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instruction_fetch_unit(
    input clk,
    input reset, // active high 
    input [3:0] imm_address,
    input [3:0] imm_address_jump,
    input [3:0] imm_address_branch,
    input jump,
    input beq_set,
    input bne_set,
    input call,
    input ret,
    output reg [3:0] pc, //program counter
    output reg [3:0] return_address
    
    );
    reg [3:0] sp;
    reg [3:0] stack [0:15];
    
    always@(posedge clk or posedge reset)begin
    
    if (reset)begin
    pc<=0;
    sp<=4'b1111;
    
    end 
    
    else begin
     if(call)begin
        stack[sp]<=pc+1;
        sp<=sp+1;
        pc<=imm_address_jump;
      end
      
      else if (ret) begin
      sp<=sp+1;
      pc<= stack[sp+1];
      end
      else if (jump)begin
      pc<=imm_address_jump;
      end
      else if ( beq_set || bne_set) begin
      pc<=pc+imm_address_branch;
      end
    
    
      else begin
      
      pc<= (pc==4'b1111)? 4'b0000: pc+1;
      end
      
      end
      
      end
      
      
      
      
      
      
      
      
      
      
    
    
    
    
    
    
    
    
    
    
endmodule
