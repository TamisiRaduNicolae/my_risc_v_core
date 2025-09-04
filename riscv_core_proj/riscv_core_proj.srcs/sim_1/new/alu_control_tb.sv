
`timescale 1ns/1ps

module alu_control_tb;

    logic [1:0] alu_op_tb;
    logic [2:0] funct3_tb;
    logic       funct7_5_tb;
    logic [3:0] alu_ctrl_tb;

   
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLT  = 4'b0101;
    localparam ALU_SLTU = 4'b0110;
    localparam ALU_SLL  = 4'b0111;
    localparam ALU_SRL  = 4'b1000;
    localparam ALU_SRA  = 4'b1001;

    alu_control dut (
        .alu_op (alu_op_tb),
        .funct3 (funct3_tb),
        .funct7_5(funct7_5_tb),
        .alu_ctrl(alu_ctrl_tb)
    );

    task automatic expected(input [1:0] ao, input [2:0] f3, input bit f7_5, input [3:0] exp, input string name);
        begin
            alu_op_tb   = ao;
            funct3_tb   = f3;
            funct7_5_tb = f7_5;
            #1;
            if (alu_ctrl_tb !== exp) begin
                $error("FAIL %-14s : alu_op=%b funct3=%03b funct7_5=%0d -> got %b exp %b",
                       name, ao, f3, f7_5, alu_ctrl_tb, exp);
                $fatal(1);
            end else begin
                $display("PASS %-14s : alu_op=%b funct3=%03b funct7_5=%0d -> %b",
                         name, ao, f3, f7_5, alu_ctrl_tb);
            end
        end
    endtask

    initial begin
        $display("=== alu_control_tb start ===");

        // loads / stores ->  ADD regardless of funct
        expected(2'b00, 3'b000, 1'b0, ALU_ADD,  "LD/ST ADD");

        // branches -> SUB
        expected(2'b01, 3'b000, 1'b0, ALU_SUB,  "BR SUB");

        // R/I type decoded via funct3 / bit30
        expected(2'b10, 3'b000, 1'b0, ALU_ADD,  "ADD / ADDI");
        expected(2'b10, 3'b000, 1'b1, ALU_SUB,  "SUB");

        expected(2'b10, 3'b111, 1'b0, ALU_AND,  "AND / ANDI");
        expected(2'b10, 3'b110, 1'b0, ALU_OR,   "OR  / ORI");
        expected(2'b10, 3'b100, 1'b0, ALU_XOR,  "XOR / XORI");

        expected(2'b10, 3'b010, 1'b0, ALU_SLT,  "SLT / SLTI");
        expected(2'b10, 3'b011, 1'b0, ALU_SLTU, "SLTU/ SLTIU");

        expected(2'b10, 3'b001, 1'b0, ALU_SLL,  "SLL / SLLI");

        expected(2'b10, 3'b101, 1'b0, ALU_SRL,  "SRL / SRLI");
        expected(2'b10, 3'b101, 1'b1, ALU_SRA,  "SRA / SRAI");

        $display("=== alu_control_tb done: all checks passed ===");
        $finish;
        
    end
    

endmodule
