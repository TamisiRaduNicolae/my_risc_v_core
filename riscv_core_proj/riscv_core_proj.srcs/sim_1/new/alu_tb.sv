`timescale 1ns / 1ps

module alu_tb;

    
    logic [31:0] a_tb, b_tb;
    logic [3:0]  alu_ctrl_tb;
    logic [31:0] alu_result_tb;
    logic        zero_tb;
    logic        lt_signed_tb, lt_unsigned_tb, ge_signed_tb, ge_unsigned_tb;

  
    alu dut (
        .operand_a(a_tb),
        .operand_b(b_tb),
        .alu_ctrl(alu_ctrl_tb),
        .alu_result(alu_result_tb),
        .zero(zero_tb),
        .lt_signed(lt_signed_tb),
        .lt_unsigned(lt_unsigned_tb),
        .ge_signed(ge_signed_tb),
        .ge_unsigned(ge_unsigned_tb)
    );

    // match the ALU encodings !!!
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

    // task to check ALU behavior
    task check_op(
        input [31:0] a,
        input [31:0] b,
        input [3:0]  ctrl,
        input [31:0] exp_result,
        input string op_name
    );
    begin
        a_tb = a;
        b_tb = b;
        alu_ctrl_tb = ctrl;
        #1; 
        if (alu_result_tb !== exp_result)
            $display(" %s failed: a=%0d b=%0d got=%h expected=%h ",
                      op_name, a, b, alu_result_tb, exp_result);
        else
            $display(" %s passed: a=%0d b=%0d result=%h ",
                      op_name, a, b, alu_result_tb);
    end
    endtask

    // task to check comparison flags
    task check_flags(
        input [31:0] a,
        input [31:0] b);
    begin
        a_tb = a;
        b_tb = b;
        alu_ctrl_tb = ALU_ADD;  // ctrl doesn't matter for flags
        #1;
        
        $display("Flags for a=%0d, b=%0d -> lt_signed=%0b lt_unsigned=%0b ge_signed=%0b ge_unsigned=%0b",
                  a, b, lt_signed_tb, lt_unsigned_tb, ge_signed_tb, ge_unsigned_tb);
    end
    endtask

    // === Test sequence ===
    initial begin
        $display("=== ALU Operation Tests ===");

        check_op(10, 5, ALU_ADD , 15, "ADD");    
        check_op(10, 5, ALU_SUB , 5,  "SUB");    
        check_op(8,  2, ALU_AND , 0,  "AND");    
        check_op(8,  2, ALU_OR  , 10, "OR");     
        check_op(8,  2, ALU_XOR , 10, "XOR");    
        check_op(8,  1, ALU_SLL , 16, "SLL");    
        check_op(8,  1, ALU_SRL , 4,  "SRL");    
        check_op(-8, 2, ALU_SRA , -2, "SRA");    
        check_op(3,  5, ALU_SLT , 1,  "SLT");    
        check_op(3,  5, ALU_SLTU, 1,  "SLTU");   

        $display("\n=== ALU Flag Tests ===");
        check_flags(5, 10);               
        check_flags(10, 5);               
        check_flags(-5, 3);               
        check_flags(32'hffff_ffff, 0);    

        $finish;
    end

endmodule
