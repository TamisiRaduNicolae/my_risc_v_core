

module instruction_memory#(parameter MEM_DEPTH_WORDS// number of 32bit instructions
)(
input logic [31:0] addr, // byte address from pc
output logic [31:0] instr // fetched instruction
    );
    
    logic [31:0] mem [0:MEM_DEPTH_WORDS-1];// 32bit wide mem, depth in words
    
   //  guard index
    logic [$clog2(MEM_DEPTH_WORDS)-1:0] word_index;
    
    //  map byte address --> word index (drop lowest 2 bits)
    assign word_index = addr[2 +: $clog2(MEM_DEPTH_WORDS)];
    
    
    // Load program into memory (simulation-time)
    initial begin
        // If the file isn't found, most simulators warn you. Keep the name stable.
        $display("[instr_mem] Loading program.hex ...");
        $readmemh("program.hex", mem);
    end

    // Combinational read (single-cycle fetch in our simple model)
    always_comb begin
        if (addr[31:2] < MEM_DEPTH_WORDS) begin
            instr = mem[addr[31:2]];
        end else begin
            // Out-of-range -> return NOP (ADDI x0, x0, 0 = 0x00000013)
            instr = 32'h0000_0013;
        end
    end
    
    
    
endmodule
