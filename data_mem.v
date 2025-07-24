`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: PRANAV KAVITKAR
// Module: data_memory
// Description: Small 16-word Data Memory (32-bit words)
//              Supports store (write) and load (read) operations
//////////////////////////////////////////////////////////////////////////////////

module data_memory (
    input         clk,            // Clock for sync write
    input         st,             // Write enable for ST
    input         reset,          // Active-high reset
    input  [3:0]  addr_mem,       // 4-bit address (supports 16 locations)
    input  [31:0] write_data_mem, // Data from r1 to be stored
    output [31:0] read_data       // Read output (for testing or LD support)
);

    // 16 x 32-bit memory
    reg [31:0] mem [15:0];

    // Read data combinationally
    assign read_data = mem[addr_mem];

    // Sync write with active-high reset
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                mem[i] <= 32'd0;
            end
        end else if (st) begin
            mem[addr_mem] <= write_data_mem;
        end
    end

endmodule
