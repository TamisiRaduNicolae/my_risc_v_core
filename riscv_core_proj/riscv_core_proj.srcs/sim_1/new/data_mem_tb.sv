`timescale 1ns / 1ps

module data_mem_tb();

    logic clk_tb;
    logic MemWrite_tb;
    logic MemRead_tb;
    logic [31:0] addr_tb;
    logic [31:0] write_data_tb;
    logic [31:0] read_data_tb;

    data_mem dut (
        .clk(clk_tb),
        .MemWrite(MemWrite_tb),
        .MemRead(MemRead_tb),
        .addr(addr_tb),
        .write_data(write_data_tb),
        .read_data(read_data_tb)
    );

    // clock gen
    initial begin
        clk_tb = 0 ;
        forever #5 clk_tb = ~clk_tb ;
    end

    task write_and_check(input [31:0] addr, input [31:0] data);
    begin
        // write
        MemWrite_tb = 1;
         
        MemRead_tb  = 0;
        
         addr_tb = addr;
        write_data_tb  = data; 
        
         #5 ;
        @(posedge clk_tb);
       //  #10 ;
        MemWrite_tb = 0;

        // read
        MemRead_tb = 1;
       
        @(posedge clk_tb);  // wait 1 cycle
        
        if (read_data_tb !== data)
        
            $display("Memory check failed at addr=%0d, got=%h expected=%h", addr, read_data_tb, data);
        else $display("Memory write/read OK at addr=%0d, data=%h", addr, data);
       
        MemRead_tb = 0;
    end
    endtask

    initial begin
     
         MemWrite_tb = 0;
     MemRead_tb  = 0;
    addr_tb = 0;
    write_data_tb = 0;

        $display("=== DATA MEMORY TEST ===");
       // #10 ;
        
        write_and_check(0,    32'hDEADBEEF);
        
        write_and_check(4,    32'h12345678);
        write_and_check(8,    32'hCAFEBABE);
         write_and_check(1020, 32'h0BADF00D);    // last memory word

        $display("=== DATA MEMORY TEST COMPLETE ===");
        $finish; 
        
        
        
    end

endmodule
