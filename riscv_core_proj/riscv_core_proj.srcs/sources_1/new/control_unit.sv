`timescale 1ns / 1ps

module control_unit(
    input  logic [6:0] opcode,
    output logic       RegWrite,
    output logic       MemRead,
    output logic       MemWrite,
    output logic       ALUSrc,
    output logic       Branch,
    output logic       Jump,
    output logic [2:0] ALUOp,
    output logic       MemToReg
);

    always_comb begin
        // default values
        RegWrite = 0;
        MemRead  = 0;
        MemWrite = 0;
        ALUSrc   = 0;
        Branch   = 0;
        Jump     = 0;
        ALUOp    = 3'b000;
        MemToReg = 0;

        case(opcode)
            7'b0110011: begin   // R-type
                RegWrite = 1;
                ALUSrc   = 0;
                ALUOp    = 3'b010; //  R-type operation
                MemToReg = 0;
            end
            7'b0010011: begin    // I-type ALU
                RegWrite = 1;
                ALUSrc   = 1;
                ALUOp    = 3'b011; // I-type operation
                MemToReg = 0;
            end
            7'b0000011: begin // Load (LW)
                RegWrite = 1;
                ALUSrc   = 1;
                MemRead  = 1;
                ALUOp    = 3'b000; // ADD for address calculation
                MemToReg = 1;
            end
            7'b0100011: begin // Store (SW)
                ALUSrc   = 1;
                MemWrite = 1;
                ALUOp    = 3'b000; // ADD for address calculation
            end
            7'b1100011: begin // Branch (BEQ, BNE)
                Branch   = 1;
                ALUSrc   = 0;
                ALUOp    = 3'b001; // SUB for comparison
            end
            7'b1101111: begin // JAL
                RegWrite = 1;
                Jump     = 1;
                ALUSrc   = 0;
                MemToReg = 0;
            end
            7'b1100111: begin // JALR
                RegWrite = 1;
                Jump     = 1;
                ALUSrc   = 1;
                MemToReg = 0;
            end
            default: begin
                // keep defaults
            end
        endcase
    end

endmodule
