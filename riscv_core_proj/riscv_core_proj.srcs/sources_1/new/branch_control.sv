
module branch_control(
     input  logic [2:0] funct3,         // branch type
     input  logic       zero,           // ALU says result==0
     input  logic       less_than,      // signed comparison
     input  logic       greater_equal,   // signed comparison
     input  logic       less_than_u,     // unsigned comparison
     input  logic       greater_equal_u, // unsigned comparison
     output logic       branch_taken     // 1 = branch, 0 = no branch
    ); 
    
    
    always_comb begin
    branch_taken = 1'b0; // default : don't take branch

    case (funct3)
        3'b000: branch_taken = zero;                  // BEQ
        3'b001: branch_taken = ~zero;                 // BNE
        3'b100: branch_taken = less_than;             // BLT ( signed )
        3'b101: branch_taken = greater_equal;         // BGE ( signed )
        3'b110: branch_taken = less_than_u;           // BLTU ( unsigned )
        3'b111: branch_taken = greater_equal_u;       // BGEU ( unsigned )
        default: branch_taken = 1'b0;                 // not a branch instr
    endcase
end

    
    
endmodule
 