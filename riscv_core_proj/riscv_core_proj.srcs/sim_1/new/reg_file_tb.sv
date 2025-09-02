`timescale 1ns / 1ps


module reg_file_tb();

 logic        clk_tb;       
 logic        rst_tb;       
 logic        reg_write_tb; 
 logic [4:0]  rs1_tb;       
 logic [4:0]  rs2_tb;       
 logic [4:0]  rd_tb;       
 logic [31:0] write_data_tb;
 logic [31:0] read_data1_tb;
 logic [31:0] read_data2_tb;

reg_file dut(
.clk(clk_tb),       
.rst(rst_tb),       
.reg_write(reg_write_tb), 
.rs1(rs1_tb),       
.rs2(rs2_tb),       
.rd(rd_tb),        
.write_data(write_data_tb),
.read_data1(read_data1_tb),
.read_data2(read_data2_tb) );

initial begin 
clk_tb=0;
forever #5 clk_tb=~clk_tb;
end

// task that automatically sets the values of rd_tb and write_data_tb
  task automatic write_reg(input [4:0] rd, input [31:0] data);
      begin
        @(negedge clk_tb); // apply before rising edge
        rd_tb = rd;
        write_data_tb = data;
        reg_write_tb = 1;
        @(posedge clk_tb); // latch on rising edge
        #1 reg_write_tb = 0; // stop writing after one cycle
      end
    endtask
  
// task that automatically checks if the actual output values
//       are the same as the expected output values
  task automatic check_reg(input [4:0] rs1, input [4:0] rs2, input [31:0] exp1, input [31:0] exp2);
    begin
      rs1_tb = rs1;
      rs2_tb = rs2;
      #1; // small delay for outputs to settle
      assert (read_data1_tb === exp1)
        else $error("FAIL: rs1=%0d expected=0x%08h got=0x%08h", rs1, exp1, read_data1_tb);
      assert (read_data2_tb === exp2)
        else $error("FAIL: rs2=%0d expected=0x%08h got=0x%08h", rs2, exp2, read_data2_tb);
      $display("PASS: rs1=%0d=0x%08h, rs2=%0d=0x%08h", rs1, read_data1_tb, rs2, read_data2_tb);
    end
  endtask

  // === TEST SEQUENCE ===
  initial begin
    // Reset
    rst_tb = 1;
    reg_write_tb = 0;
    rs1_tb = 0;
    rs2_tb = 0;
    rd_tb = 0;
    write_data_tb = 0;
    #12 rst_tb = 0;

    // test 1 : write x5 = 0xADCD1234 and  check
    write_reg(5, 32'hADCD1234);
    check_reg(5, 0, 32'hADCD1234, 32'h0);

    // test 2 :  try to write x0 = 0xA02329BC, ( must stay 0 )
    write_reg(0, 32'hA02329BC);
    check_reg(0, 5, 32'h0, 32'hADCD1234);

    // test 3 : write x10 = 0x5555AAAA and check dual read ( x5 , x10 )
    write_reg(10, 32'h5555AAAA);
    check_reg(5, 10, 32'hADCD1234, 32'h5555AAAA);

    // test 4  : overwrite x5  with 0x12345678
    write_reg(5, 32'h12345678);
    check_reg(5, 10, 32'h12345678, 32'h5555AAAA);

    $display("All reg_file tests completed.");
    $finish;
  end

endmodule
