`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: PRANAV KAVITKAR
// Design Name: Instruction Decode Unit
// Module Name: instruction_decode
// Description: Decodes a 19-bit instruction into fields based on format type.
// Formats supported: R, I, S, B, J, X (based on opcode)
// IMM is sign-extended to 32 bits not used though
//////////////////////////////////////////////////////////////////////////////////

module instruction_decode (
    input  wire        clk,
    input  wire        reset,             // Active-high reset
    input  wire [18:0] instruction_code,  
    output reg  [3:0]  func,
    output reg  [3:0]  rs2,
    output reg  [3:0]  rs1,
    output reg  [3:0]  rd,
    output reg  [2:0]  opcode,
    output reg  [31:0] imm_extended,
    output reg [3:0] imm_addr1,
    output reg [3:0] imm_address,
    output reg write_reg,
    output reg jump=0 ,
    //output reg branch=0
    output reg bne=0,
    output reg beq=0,
    output reg [3:0]imm_branch,
    output reg st ,
    output reg ld,
    output reg fft,
    input wire flush_jump,
    input wire branch_flush
    //ff
  
);

    wire [2:0] opcode_w;
    wire [3:0] func_w, rs2_w, rs1_w, rd_w, imm_raw;

    // Field extraction
    assign opcode_w = instruction_code[2:0];
    assign rd_w     = instruction_code[6:3];
    assign rs1_w    = instruction_code[10:7];
    assign rs2_w    = instruction_code[14:11];
    assign func_w   = instruction_code[18:15];
    assign imm_raw  = instruction_code[14:11];

    // Decode logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            func          <= 4'b0;
            rs2           <= 4'b0;
            rs1           <= 4'b0;
            rd            <= 4'b0;
            opcode        <= 3'b0;
            imm_extended  <= 0;
             beq<=0;
             bne<=0;
             st<=0;
             ld<=0;
            write_reg<=0;
            fft<=0;
            jump<=0;
           end
            
            else if ( branch_flush)begin
            opcode<=0000;
            end // cheak here 
            
            
            
         else begin
            func   <= func_w;
            opcode <= opcode_w;

            case (opcode_w)
                3'b001: begin // R-type
                    rs2          <= rs2_w;
                    rs1          <= rs1_w;
                    rd           <= rd_w;
                    write_reg<=1; 
                    imm_extended <= 0;
                    jump<=0;
                   beq<=0;
                   st<=0;
                   ld<=0;
                   fft<=0;
             bne<=0;
                end
               3'b010: begin // I-type
    rs1          <= rs1_w;
    imm_extended <= rs2_w; // Sign-extend
jump<=0;
st<=0;
 beq<=0;
 ld<=0;
 fft<=0;
             bne<=0;
  
    if (func_w == 4'b0000 || func_w == 4'b1111) 
        rd <= rs1_w;
    else
        rd <= rd_w;

    write_reg <= 1;
end
                3'b011: begin // S-type
                   // rs1          <= rs1_w;
                    rs2          <= 0;
                    imm_addr1 <=  rd_w;
                   
                    jump<=0;
                     beq<=0;
             bne<=0;
              fft<=0;
             if (func_w==4'b0000)begin
             st<=1;
             ld<=0;
             rs1          <= rs1_w;
              rd           <= 4'b0;
             end
             else if(func_w==4'b0001)begin
             ld<=1;
             st<=0;
             rd<=rs1_w;
             rs1<=0;
             end
             
             
                end
                3'b100: begin // B-type
                    rs1          <= rs1_w;
                    rs2          <= rs2_w;
                    imm_branch <=  rd_w;
                    rd           <= 4'b0;
                    jump<=0;
                    write_reg<=0;
                    st<=0;
                    ld<=0;
                     fft<=0;
                   if(func_w==4'b0000)begin
                    beq<=1;
                    bne<=0;
                    
                    end
                    else if (func_w==4'b0001)begin
                    bne<=1;
                    beq<=0;
                    end
                   
                   
                   
                end
                3'b101: begin // J-type
                    rd           <= 4'b0;
                    imm_address<=  rs2_w;
                    rs1          <= 4'b0;
                    rs2          <= 4'b0;
                    jump<=1;
                    write_reg<=0;
                    st<=0;
                    ld<=0;
                   
                     fft<=0;
                end
                3'b110: begin // X-type
                    rs1          <= rs1_w;
                    rs2          <= 0;
                    rd<=0;
                    imm_addr1           <= rd_w;
                    imm_extended <= 0;
                    jump<=0;
                   // st<=1;
                   // write_reg<=1;
                    ld<=0;
                    if (func_w==4'b0010)
                    begin
                     fft<=1'd1;
                       write_reg<=0;
                     end
                     else begin
                     fft<=0;
                     write_reg<=1;
                     end
             st<=0;
                end
                default: begin
                    func         <= 4'b0;
                    rs2          <= 4'b0;
                    rs1          <= 4'b0;
                    rd           <= 4'b0;
                    imm_extended <= 0;
                    jump<=0;
                    ld<=0;
                
                end
            endcase
        end
    end

endmodule
