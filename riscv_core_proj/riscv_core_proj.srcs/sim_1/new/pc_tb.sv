`timescale 1ns / 1ps


module pc_tb();

localparam WIDTH_tb = 32;



logic clk_tb;
logic rst_tb;
logic [WIDTH_tb-1:0] pc_next_tb;
logic [WIDTH_tb-1:0] pc_current_tb;

pc #(.WIDTH(WIDTH_tb)) programcounter(
.clk(clk_tb),
.rst(rst_tb),
.pc_next(pc_next_tb),
.pc_current(pc_current_tb)
);



initial begin
clk_tb=0;
forever #5 clk_tb = ~clk_tb;
end


initial begin
    rst_tb =1;
    pc_next_tb = '0;
    
#20 rst_tb =0;

    pc_next_tb = 32'h0000_0004; //expected pc_current = 4

#10 pc_next_tb = 32'h0000_0008;

#10 pc_next_tb = 32'h0000_000C;

// reset again
#10 rst_tb =1;
#10 rst_tb =0;
    pc_next_tb = 32'h0000_0010;//expected pc_current = 10

    $display("test completed");
    $finish;

end

    // monitor outputs
    initial begin
        $monitor("Time=%0t | rst=%0b | pc_next=0x%h | pc_current=0x%h",
                  $time, rst_tb, pc_next_tb, pc_current_tb);
    end

endmodule
