`timescale 1ns / 1ps

module datapath_mini_tb;

    logic [31:0] instr_tb;
    logic [31:0] reg_rs1_tb, reg_rs2_tb;
    logic [31:0] alu_result_tb;
    logic        zero_tb;
    

    datapath_mini dut (
        .instr(instr_tb),
        .reg_rs1(reg_rs1_tb),
        .reg_rs2(reg_rs2_tb),
        .alu_result(alu_result_tb),
        .zero(zero_tb)
    );
    

    // helper task
    task run_instr(input [31:0] instr, input [31:0] rs1, input [31:0] rs2, input string name);
    begin
        instr_tb   = instr;
        reg_rs1_tb = rs1;
        reg_rs2_tb = rs2;
        #2;
        $display("%s: rs1=%0d rs2=%0d result=%0d (hex=%h)", name, rs1, rs2, alu_result_tb, alu_result_tb);
    end
    endtask

    initial begin
        $display("=== Datapath Mini Integration Test ===");


        //  ADD x3, x1, x2  (R-type, funct7=0000000, funct3=000, opcode=0110011)
        run_instr(32'b0000000_00010_00001_000_00011_0110011, 10, 5, "ADD");


        // SUB x3, x1, x2  (R-type, funct7=0100000, funct3=000, opcode=0110011)
        run_instr(32'b0100000_00010_00001_000_00011_0110011, 10, 5, "SUB");


        //  ORI x3, x1, 5   (I-type, funct3=110, opcode=0010011, imm=5)
        run_instr(32'b000000000101_00001_110_00011_0010011, 12, 0, "ORI imm=5");


        //  BEQ x1, x2, offset=8  (opcode=1100011, funct3=000)
        run_instr(32'b0000000_00010_00001_000_00010_1100011, 7, 7, "BEQ equal");

        $finish;
        
    end

endmodule
