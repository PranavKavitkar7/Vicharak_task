`timescale 1ns / 1ps

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
    input write_enable,
    output reg [3:0] pc, // program counter
    output reg [3:0] return_address
);

    reg [3:0] sp;
    reg [3:0] stack [0:15];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
            sp <= 4'b1111;
        end else begin
            if (call) begin
                stack[sp] <= pc + 1;
                sp <= sp + 1;
                pc <= imm_address_jump+1;
            end else if (ret) begin
                sp <= sp + 1;
                pc <= stack[sp + 1];
            end else if (jump) begin
                pc <= imm_address_jump+1;
            end else if (beq_set || bne_set) begin
                pc <=  imm_address_branch+1;
            end else if (write_enable ) begin
                pc <= (pc == 4'b1111) ? 4'b0000 : pc + 1;
            end
        end
    end

endmodule
