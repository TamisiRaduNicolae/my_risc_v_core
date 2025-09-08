`timescale 1ns / 1ps

module data_mem #(
    parameter MEM_SIZE = 1024 // number of 32-bit words
)(
    input  logic        clk,
    input  logic        MemWrite,
    input  logic        MemRead,     
    input  logic [31:0] addr,
    input  logic [31:0] write_data,
    output logic [31:0] read_data
);

    logic [31:0] mem [0:MEM_SIZE-1];

    // initialize memory to 0 
    initial begin
        for (int i = 0; i < MEM_SIZE; i++) begin
            mem[i] = 32'h00000000;
        end
    end

 
    always_ff @(posedge clk) begin
        if (MemWrite) begin
            mem[addr[11:2]] <= write_data;  
        end
    end

    // combinational read 
    always_comb begin
        if (MemRead)
            read_data = mem[addr[11:2]];
        else
            read_data = 32'h00000000;
    end

endmodule
