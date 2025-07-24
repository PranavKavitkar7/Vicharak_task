`timescale 1ns / 1ps

module control_unit (
    input  [2:0] opcode,
    input  [3:0] func,
    output reg [3:0] alu_con
);

    always @(*) begin
        case (opcode)
            3'b001: begin
                case (func)
                    4'b0000: alu_con = 4'b0000; // ADD
                    4'b0001: alu_con = 4'b0001; // SUB
                    4'b0010: alu_con = 4'b0010; // MUL
                    4'b0011: alu_con = 4'b0011; // DIV
                    4'b0100: alu_con = 4'b0110; // AND
                    4'b0101: alu_con = 4'b0111; // OR
                    4'b0110: alu_con = 4'b1000; // XOR
                    4'b0111: alu_con = 4'b1001; // NOT
                    default: alu_con = 4'b0000;
                endcase
            end

            3'b010: begin
                case (func)
                    4'b0000: alu_con = 4'b0100; // INC
                    4'b0001: alu_con = 4'b0101; // DEC
                    default: alu_con = 4'b0000;
                endcase
            end

            3'b100: begin
                case (func)
                    4'b0000: alu_con = 4'b1010; // BEQ
                    4'b0001: alu_con = 4'b1011; // BNE
                    default: alu_con = 4'b0000;
                endcase
            end
            3'b110:begin
            case(func)
             4'b0000: alu_con = 4'b1100; 
             4'b0001: alu_con = 4'b1101; 
             4'b0010: alu_con =4'b1110;
            default: alu_con = 4'b0000;
            endcase
            end
            default: alu_con = 4'b1111;
        endcase
    end

endmodule
