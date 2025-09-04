

module alu_control(
    input  logic [1:0] alu_op,       //  from control unit
    input  logic [2:0] funct3,       //   instr[14:12]
    input  logic       funct7_5,    //  instr[30] ( bit 5  of  funct7 )
    output logic [3:0] alu_ctrl      // to ALU
    );
    
    
    //    same encodings as alu 
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLT  = 4'b0101;
    localparam ALU_SLTU = 4'b0110;
    localparam ALU_SLL  = 4'b0111;
    localparam ALU_SRL  = 4'b1000;
    localparam ALU_SRA  = 4'b1001;
    
    always_comb begin
        unique case (alu_op)
            2'b00: alu_ctrl = ALU_ADD; // loads / stores address calc
            2'b01: alu_ctrl = ALU_SUB; // branches / equality
            2'b10: begin               // R-type or I-type ALU op 
                unique case (funct3)
                    3'b000: alu_ctrl = funct7_5 ? ALU_SUB : ALU_ADD;   // ADD/SUB, ADDI uses funct7_5=0
                    3'b111: alu_ctrl = ALU_AND;                       // AND/ANDI
                    3'b110: alu_ctrl = ALU_OR;                       // OR/ORI
                    3'b100: alu_ctrl = ALU_XOR;                      // XOR/XORI
                    3'b010: alu_ctrl = ALU_SLT;                       // SLT/SLTI (signed)
                    3'b011: alu_ctrl = ALU_SLTU;                       //  SLTU/SLTIU (unsigned)
                    3'b001: alu_ctrl = ALU_SLL;                      // SLL/SLLI
                    3'b101: alu_ctrl = funct7_5 ? ALU_SRA : ALU_SRL;  // SRL/SRA, SRLI/SRAI
                    default: alu_ctrl = ALU_ADD;
                endcase
            end
            default: alu_ctrl = ALU_ADD; // safe default
        endcase
    end
    
    
    
    
    
endmodule
