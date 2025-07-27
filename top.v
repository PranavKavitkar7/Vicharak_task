`timescale 1ns / 1ps

module top (
    input clk,
    input reset,
    input [18:0] instruction_input,
    input write_enable
);

    // Wires/regs for instruction fetch
    wire [18:0] instruction_code;
    wire [3:0] pc;
    wire [3:0] return_address;

    wire [3:0] imm_address;
    wire [3:0] imm_address_jump;
    wire jump;
    wire bne_set;
    wire beq_set;

    // Instruction Decode outputs
    wire [3:0] func;
    wire [3:0] rs2;
    wire [3:0] rs1;
    wire [3:0] rd;
    wire [2:0] opcode;
    wire [31:0] imm_extended;
    wire write_reg_deframe_ex;
    wire write_reg_mem_acc;
    wire write_reg_final;
    wire bne_intrr;
    wire beq_intrr;
    wire [3:0] imm_branch;

    // Register File I/O
    wire [31:0] out_rs1;
    wire [31:0] out_rs2;
    wire [31:0] result;
    wire [3:0] alu_control;
    wire [3:0] rd_send;
    wire [3:0] rd_final_1;
    wire [31:0] write_reg_data;
    wire [3:0] imm_address_branch;

    wire beq_intrr2;
    wire bne_intrr2;
    wire [3:0] imm_add_final;

    wire st;
    wire ld;
    wire st_;
    wire ld_;
    wire st1;
    wire ld1;
    wire [3:0] imm_add1;
    wire [3:0] imm_addr1_;
    wire [31:0] write_data_mem;
    wire [3:0] imm_addr1;
    wire [31:0] read_data_mem;
    wire fft;
    wire fft_;

    wire jump_hazard;
    wire flush_jump_h;
    wire branch_flush;
    wire branched_h;

    wire fwd_r1;
    wire fwd_r2;
    wire [31:0] alu_fwd;

    // Forwarded ALU inputs
    wire [31:0] src1_final = fwd_r1 ? alu_fwd : out_rs1;
    wire [31:0] src2_final = fwd_r2 ? alu_fwd : out_rs2;
    
   

    // Instruction Fetch Unit
    instruction_fetch_unit IFU (
        .clk(clk),
        .reset(reset),
        .imm_address(imm_address),
        .imm_address_jump(imm_address_jump),
        .beq_set(beq_set),
        .bne_set(bne_set),
        .jump(jump),
        .pc(pc),
        .return_address(return_address),
        .imm_address_branch(imm_add_final),
        .write_enable(write_enable)
        
    );

    // Instruction Memory
    instruction_memory IMEM (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction_code(instruction_code),
        .write_enable(write_enable),
        .instruction_in(instruction_input)
       
      
    );

    // Instruction Decode Unit
    instruction_decode IDEC (
        .clk(clk),
        .reset(reset),
        .instruction_code(instruction_code),
        .func(func),
        .rs2(rs2),
        .rs1(rs1),
        .rd(rd),
        .opcode(opcode),
        .imm_extended(imm_extended),
        .imm_address(imm_address_jump),
        .write_reg(write_reg_deframe_ex),
        .jump(jump),
        .bne(bne_intrr),
        .beq(beq_intrr),
        .imm_branch(imm_branch),
        .imm_addr1(imm_addr1),
        .st(st),
        .ld(ld),
        .fft(fft),
        .flush_jump(flush_jump_h)
    );

    // Register File
    register_file REGFILE (
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd_final_1),
        .write_imm(imm_extended),
        .out_rs1(out_rs1),
        .out_rs2(out_rs2),
        .write_reg_data(write_reg_data),
        .write_reg(write_reg_final)
    );

    // Control Unit
    control_unit control_unit1 (
        .opcode(opcode),
        .func(func),
        .alu_con(alu_control)
    );

    // ALU Unit (with forwarding inputs)
    alu alu (
        .clk(clk),
        .reset(reset),
        .src1(src1_final),
        .src2(src2_final),
        .imm(imm_extended),
        .alu_control(alu_control),
        .result(result),
        .rd_in(rd),
        .rd_wr(rd_send),
        .write_reg(write_reg_deframe_ex),
        .write_reg_(write_reg_mem_acc),
        .bne(bne_intrr),
        .beq(beq_intrr),
        .bne_(bne_intrr2),
        .beq_(beq_intrr2),
        .imm_address_branch(imm_branch),
        .imm_address_branch_(imm_address_branch),
        .st_(st_),
        .ld_(ld_),
        .st(st),
        .ld(ld),
        .imm_addr1(imm_addr1),
        .imm_add1(imm_add1),
        .fft(fft),
        .fft_(fft_),
        .branch_flush(branch_flush),
        .alu_fwd(alu_fwd),
        .fwd_r1(fwd_r1),
        .fwd_r2(fwd_r2)
    );

    // Memory Access Stage
    mem_stage mem_acc (
        .clk(clk),
        .reset(reset),
        .alu_result_in(result),
        .alu_result_out(write_reg_data),
        .write_reg_(write_reg_mem_acc),
        .write_reg(write_reg_final),
        .rd_in(rd_send),
        .rd_final(rd_final_1),
        .beq(beq_intrr2),
        .bne(bne_intrr2),
        .bne_set(bne_set),
        .beq_set(beq_set),
        .imm_address_branch(imm_address_branch),
        .imm_address_branch_(imm_add_final),
        .st(st_),
        .ld(ld_),
        .en_(st1),
        .ld_(ld1),
        .write_data_mem(write_data_mem),
        .imm_addr1(imm_add1),
        .imm_addr1_(imm_addr1_),
        .read_data_mem(read_data_mem),
        .fft(fft_),
        .branch_flush(branched_h)
    );

    // Data Memory
    data_memory mem (
        .clk(clk),
        .st(st1),
        .addr_mem(imm_add1),
        .write_data_mem(write_data_mem),
        .read_data(read_data_mem),
        .reset(reset)
    );

    // Hazard Detection and Forwarding
    hazard_unit hazard_unit (
        .clk(clk),
        .reset(reset),
        .jump(jump),
        .flush_jump(flush_jump_h),
        .branch_flush(branch_flush),
        .branched(branched_h),
        .ma_dest(rd_send),
        .wb_dest(rd_final_1),
        .r1_dec(rs1),
        .r2_dec(rs2),
        .write_reg(write_reg_deframe_ex),
        .fwd_r1(fwd_r1),
        .fwd_r2(fwd_r2),
        .alu_fwd(alu_fwd),
        .alu_result_ma(result),
        .alu_result_wb(write_reg_data)
    );

endmodule
