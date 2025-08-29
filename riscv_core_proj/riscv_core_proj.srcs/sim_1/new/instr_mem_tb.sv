`timescale 1ns/1ps

module instr_mem_tb;

  logic [31:0] addr_tb;
  logic [31:0] instr_tb;

  // Instantiate DUT
  instr_mem dut (
    .addr(addr_tb),
    .instr(instr_tb)
  );

  initial begin
    $display("=== Hardcoded Instruction Memory Test ===");

    for (int i = 0; i < 6; i++) begin
      addr_tb = i;
      #10;
      $display("Time=%0t ns | address=%0d | instruction=%h", $time, addr_tb, instr_tb);
    end

    $finish;
  end

endmodule
