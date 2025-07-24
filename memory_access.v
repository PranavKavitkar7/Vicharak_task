`timescale 1ns / 1ps
//Memory access stage 
// Cheaks for Branch results or hazard condtions













module mem_stage (
    input             clk,
    input             reset,  
    input write_reg_,        // Async active-high reset
    input      [31:0] alu_result_in,    
    output reg [31:0] alu_result_out,
    output reg     write_reg,
    input wire [3:0] rd_in,
    output reg [3:0] rd_final ,
    input wire beq, 
    input wire bne,
    output reg beq_set=0,
    output reg bne_set=0,
    input wire [3:0] imm_address_branch,
    output reg  [3:0] imm_address_branch_   ,
    input wire st,
    input wire ld,
    output reg ld_,
    output reg en_  ,
    output reg [31:0] write_data_mem,
    input wire [3:0] imm_addr1,
    output reg [3:0]imm_addr1_,
    input wire [31:0]read_data_mem,
    input wire fft,
    output  reg branch_flush
    //output reg fft_
    
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_result_out <= 32'd0;
            write_reg<=0;
            rd_final<=0;
            en_<=0;
            ld_<=0;
             imm_address_branch_ <=0;
             write_data_mem<=0;
        end else begin
        if(beq==1 && alu_result_in==32'd1)begin
        beq_set<=1;
        bne_set<=0;
        end
        
        
        
        
        else if(bne==1 && alu_result_in==32'd1)begin
        bne_set<=1;
          beq_set<=0;
        end
        
        else if (!beq || !bne)begin
         beq_set<=0;
          bne_set<=0;
        end
        
        
        if (st)begin
        write_data_mem<=alu_result_in;
        end
        
        if(beq || bne)
        begin
        branch_flush<=1;
        end
        else begin
        branch_flush<=0;
        end
        
        
        imm_addr1_<=imm_addr1;
            if(ld)begin
            alu_result_out <= read_data_mem;
            end
            else begin
            alu_result_out <= alu_result_in;
            end
          //  write_reg     <= write_reg_;
            rd_final<=rd_in;
             imm_address_branch_<= imm_address_branch;
            // ld_<=ld;
             if(st)begin
             en_<=st;
             end
             else if (fft) begin
             en_<=fft;
               write_data_mem<=alu_result_in;
             
             end
            if (ld)begin
            write_reg<=ld;
        end
        else begin
        write_reg<=write_reg_;
    end
end
end
endmodule
