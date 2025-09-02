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



initial begin
    rst_tb = 1;
#10 rst_tb = 0;

    rd_tb   = 5 ; 
    reg_write_tb  = 1;
    rs1_tb  = 5;       
    rs2_tb  = 1;       
    write_data_tb = 32'hadcd1234; // write to x5 = 0xABCD1234 and verify readback from rs1=5
 
 
#20 rd_tb   = 0 ;                
    reg_write_tb  = 1;           
    rs1_tb  = 0;                 
    rs2_tb  = 1;                 
    write_data_tb = 32'ha02329bc; // Try to write to x0 and check it remains 0
end


endmodule
