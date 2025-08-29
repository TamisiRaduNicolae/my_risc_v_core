module instr_mem (
    input  logic [31:0] addr,      // PC gives word address
    output logic [31:0] instr  // instruction at that address
);

  always_comb begin
    case (addr)
      32'd0: instr = 32'h00000013; // NOP   (ADDI x0, x0, 0)
      32'd1: instr = 32'h00100093; // ADDI  x1, x0, 1
      32'd2: instr = 32'h00200113; // ADDI  x2, x0, 2
      32'd3: instr = 32'h003081B3; // ADD   x3, x1, x3
      32'd4: instr = 32'h00000073; // ECALL (end simulation marker)
      default: instr = 32'h00000013; // NOP
    endcase
  end

endmodule
