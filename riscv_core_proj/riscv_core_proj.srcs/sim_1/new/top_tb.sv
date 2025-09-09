`timescale 1ns/1ps

module top_tb;

    logic clk;
    logic rst;

  
    top #(.MEM_SIZE(256)) dut (
        .clk(clk),
        .rst(rst)
    );

    
    initial clk = 0;
    always #5 clk = ~clk;

   
    initial begin
        rst = 1;
        #20;
        rst = 0;

        // run program for 100 cycles
        repeat (100) @(posedge clk);

        // print some registers
        $display("x3 = %0d", dut.regfile_inst.regs[3]);
        $display("x4 = %0d", dut.regfile_inst.regs[4]);
        $display("x5 = %0d", dut.regfile_inst.regs[5]);

        $finish;
    end

endmodule
