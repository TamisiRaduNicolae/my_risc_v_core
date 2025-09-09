module instr_mem #(
    parameter MEM_SIZE = 256
) (
    input  logic [31:0] addr,   // PC address
    output logic [31:0] instr   // fetched instruction
);

    logic [31:0] mem [0:MEM_SIZE-1];

    // preload demo program
    initial begin
    
        // Program:
        // ADDI x1, x0, 1    ; x1 = 1
        // ADDI x2, x0, 2    ; x2 = 2
        // ADD  x3, x1, x2   ; x3 = 1+2 = 3
        // ADDI x4, x3, 5    ; x4 = 3+5 = 8
        // ADDI x5, x4, 10   ; x5 = 8+10 = 18
        // ECALL             ; stop marker
        
        
        mem[0] = 32'h00100093; // ADDI x1, x0, 1
        mem[1] = 32'h00200113; // ADDI x2, x0, 2
        mem[2] = 32'h002081B3; // ADD  x3, x1, x2
        mem[3] = 32'h00518213; // ADDI x4, x3, 5
        mem[4] = 32'h00a20293; // ADDI x5, x4, 10
        mem[5] = 32'h00000073; // ECALL
        
    end

    // word aligned fetch
    assign instr = mem[addr[31:2]];

endmodule
