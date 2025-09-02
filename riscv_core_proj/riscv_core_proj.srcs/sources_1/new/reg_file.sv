

module reg_file(
    input  logic        clk,
    input  logic        rst,
    input  logic        reg_write,
    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  rd,
    input  logic [31:0] write_data,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2
    );
    
    
    logic [31:0] regs [31:0]; // 32 registers of 32 bits 
    
    assign regs[0] = 32'b0; // hardwiring x0 to 0
    
    assign read_data1= regs[rs1]; // read ports
    assign read_data2= regs[rs2];

    //write port 
    
    always_ff@( posedge clk or posedge rst ) begin
    
    if(rst)begin
    for(int i=0; i<32; i=i+1) //reset all registers, (this was not required by ISA)
    regs[i] <= 32'b0;
    end
    
    else if( reg_write && rd!=0 ) begin
        regs[rd] <= write_data;
    
         end
    end

    
endmodule
