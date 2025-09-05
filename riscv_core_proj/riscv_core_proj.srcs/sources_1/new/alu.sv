`timescale 1ns / 1ps


module alu(
 input  logic [31:0] operand_a,
    input  logic [31:0] operand_b,
    input  logic [3:0]  alu_ctrl,     // ALU operation select
    output logic [31:0] alu_result,
    output logic        zero   ,       // used for branch decisions
     output logic        lt_signed,
    output logic        lt_unsigned,
    output logic        ge_signed,
    output logic        ge_unsigned
    );
    
    // ALU control codes
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLT  = 4'b0101; // signed
    localparam ALU_SLTU = 4'b0110; // unsigned
    localparam ALU_SLL  = 4'b0111;
    localparam ALU_SRL  = 4'b1000;
    localparam ALU_SRA  = 4'b1001;

    always_comb begin
        unique case (alu_ctrl)
            ALU_ADD : alu_result = operand_a + operand_b;
            
            ALU_SUB : alu_result = operand_a - operand_b;
            
            ALU_AND : alu_result = operand_a & operand_b;
            
            ALU_OR  : alu_result = operand_a | operand_b;
            
            ALU_XOR : alu_result = operand_a ^ operand_b;
            
            ALU_SLT : alu_result = ($signed(operand_a) <  $signed(operand_b)) ? 32'd1 : 32'd0 ;
            
            ALU_SLTU: alu_result = (operand_a   <  operand_b) ? 32'd1 : 32'd0 ;
            
            ALU_SLL : alu_result = operand_a << operand_b[4:0];
            
            ALU_SRL : alu_result = operand_a >> operand_b[4:0];
            
            ALU_SRA : alu_result = $signed(operand_a) >>> operand_b[4:0];
            
            default : alu_result = 32'd0;
        endcase
    end

    assign zero = (alu_result == 32'd0);
     assign lt_signed   = ($signed(operand_a) < $signed(operand_b));
    assign lt_unsigned = (operand_a < operand_b);
    assign ge_signed   = ($signed(operand_a) >= $signed(operand_b));
    assign ge_unsigned = (operand_a >= operand_b);
    
endmodule
