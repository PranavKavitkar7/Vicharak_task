module data_memory (
    input         clk,            
    input         st,   
    input         reset,    
    input  [3:0]  addr_mem,          
    input  [31:0] write_data_mem,     
    output [31:0] read_data       
);

    reg [31:0] mem [15:0];
    assign read_data = mem[addr_mem];
  integer i;
   always @(posedge clk or posedge reset) begin
    if (reset) begin
        mem[2] <= 32'hDEADBAEF;  // TEMP
        for (i = 0; i < 16; i = i + 1) begin
            if (i != 2)
                mem[i] <= 32'd0;
        end
    end else if (st) begin
        mem[addr_mem] <= write_data_mem;
    end
end

endmodule
