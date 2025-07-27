`timescale 1ns / 1ps



// Cheaks for hazards
// Data forwarding
// Instruction flushing logic for branch and jump


module hazard_unit(
    input  wire        clk,
    input  wire        reset,
    input  wire        jump,
    output wire        flush_jump,
    output wire        branch_flush,
    input  wire        branched,

    input  wire [3:0]  ma_dest,
    input  wire [3:0]  wb_dest,
    input  wire [3:0]  r1_dec,
    input  wire [3:0]  r2_dec,

    input  wire        write_reg,

    output wire        fwd_r1,
    output wire fwd_r2,
    output wire [31:0] alu_fwd,

    input  wire [31:0] alu_result_ma,
    input  wire [31:0] alu_result_wb
);

    // Flushing  logic
    assign flush_jump   = jump;
    assign branch_flush = branched;


    
    wire match_r1_ma = write_reg && (r1_dec == ma_dest) && (ma_dest != 0);
    wire match_r2_ma = write_reg && (r2_dec == ma_dest) && (ma_dest != 0);
    wire match_r1_wb = write_reg && (r1_dec == wb_dest) && (wb_dest != 0);
    wire match_r2_wb = write_reg && (r2_dec == wb_dest) && (wb_dest != 0);

      assign fwd_r1 = write_reg && (match_r1_ma || match_r1_wb);
    assign fwd_r2 = write_reg && (match_r2_ma || match_r2_wb);

    // Forward the most recent valid ALU result
    assign alu_fwd = (match_r1_ma || match_r2_ma) ? alu_result_ma :
                     (match_r1_wb || match_r2_wb) ? alu_result_wb :
                     32'd0;

endmodule
