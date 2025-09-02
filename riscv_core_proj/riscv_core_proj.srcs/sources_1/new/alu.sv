`timescale 1ns / 1ps


module alu(
 input  logic [31:0] operand_a,
    input  logic [31:0] operand_b,
    input  logic [3:0]  alu_ctrl,     // ALU operation select
    output logic [31:0] alu_result,
    output logic        zero          // used for branch decisions
    );
    
    
    always_comb begin
    case (alu_ctrl)
      4'b0000: alu_result = operand_a + operand_b;            // ADD
      4'b0001: alu_result = operand_a - operand_b;            // SUB
      4'b0010: alu_result = operand_a & operand_b;            // AND
      4'b0011: alu_result = operand_a | operand_b;            // OR
      4'b0100: alu_result = operand_a ^ operand_b;            // XOR
      4'b0101: alu_result = operand_a << operand_b[4:0];      // SLL
      4'b0110: alu_result = operand_a >> operand_b[4:0];      // SRL
      4'b0111: alu_result = $signed(operand_a) >>> operand_b[4:0]; // SRA
      4'b1000: alu_result = ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0; // SLT
      4'b1001: alu_result = (operand_a < operand_b) ? 32'd1 : 32'd0;                   // SLTU
      default: alu_result = 32'd0;
    endcase
  end

  assign zero = (alu_result == 0);
    
    
    
    
endmodule
