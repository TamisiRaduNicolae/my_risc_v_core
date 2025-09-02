`timescale 1ns / 1ps


module alu_tb();


  logic [31:0] operand_a_tb;
  logic [31:0] operand_b_tb;
  logic [3:0]  alu_ctrl_tb;
  logic [31:0] alu_result_tb;
  logic        zero_tb;

  alu dut (
    .operand_a(operand_a_tb),
    .operand_b(operand_b_tb),
    .alu_ctrl(alu_ctrl_tb),
    .alu_result(alu_result_tb),
    .zero(zero_tb)
  );

  task automatic check(input [31:0] a, input [31:0] b, input [3:0] ctrl, input [31:0] expected);
    begin
    
      operand_a_tb = a;
      operand_b_tb = b;
      alu_ctrl_tb  = ctrl;
      
      #1;
      
      assert (alu_result_tb === expected)
      
        else $error("FAIL: a=0x%08h b=0x%08h ctrl=%0d expected=0x%08h got=0x%08h",
                      a, b, ctrl, expected, alu_result_tb);
                     
      $display("PASS: a=0x%08h b=0x%08h ctrl=%0d result=0x%08h",
                 a, b, ctrl, alu_result_tb);
                
    end
  endtask

  initial begin
  
  
    // ADD
    check(32'd10, 32'd5, 4'b0000, 32'd15);
    
    // SUB
    check(32'd10, 32'd5, 4'b0001, 32'd5);
    
    // AND
    check(32'hFF00FF00, 32'h0F0F0F0F, 4'b0010, 32'h0F000F00);
    
    // OR
    check(32'hF0F0F0F0, 32'h0F0F0F0F, 4'b0011, 32'hFFFFFFFF);
    
    // XOR
    check(32'hAAAA5555, 32'h5555AAAA, 4'b0100, 32'hFFFFFFFF);
    
    // Shift left
    check(32'd1, 32'd3, 4'b0101, 32'd8);
    
    // SRL
    check(32'h80000000, 32'd1, 4'b0110, 32'h40000000);
    
    // SRA
    check(32'h80000000, 32'd1, 4'b0111, 32'hC0000000);
    
    // SLT signed
    check(-32'sd5, 32'sd10, 4'b1000, 32'd1);
    
    // SLTU unsigned
    check(32'd5, 32'd10, 4'b1001, 32'd1);
    

    $display("All ALU tests completed");
    $finish;
    
    
  end

endmodule
