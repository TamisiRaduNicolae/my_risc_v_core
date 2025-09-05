`timescale 1ns / 1ps

module control_unit_tb;

    logic [6:0] opcode_tb;
    logic    RegWrite_tb, MemRead_tb, MemWrite_tb, ALUSrc_tb;
    logic    Branch_tb, Jump_tb;
    logic [2:0] ALUOp_tb;
    logic  MemToReg_tb;

    control_unit dut(
      .opcode(opcode_tb),
        .RegWrite(RegWrite_tb),
        .MemRead(MemRead_tb),
        .MemWrite(MemWrite_tb),
        .ALUSrc(ALUSrc_tb),
         .Branch(Branch_tb),
         .Jump(Jump_tb),
         .ALUOp(ALUOp_tb),
         .MemToReg(MemToReg_tb)
    );

    initial begin
        $display("=== Control Unit Tests ===");

        // R-type
        opcode_tb = 7'b0110011; #1;
        $display("R-type: RegWrite=%b ALUSrc=%b ALUOp=%b MemToReg=%b", RegWrite_tb, ALUSrc_tb, ALUOp_tb, MemToReg_tb);

        // I-type ALU
        opcode_tb = 7'b0010011; #1;
        $display("I-type: RegWrite=%b ALUSrc=%b ALUOp=%b MemToReg=%b", RegWrite_tb, ALUSrc_tb, ALUOp_tb, MemToReg_tb);

        // Load
        opcode_tb = 7'b0000011; #1;
        $display("Load: RegWrite=%b ALUSrc=%b MemRead=%b ALUOp=%b MemToReg=%b", RegWrite_tb, ALUSrc_tb, MemRead_tb, ALUOp_tb, MemToReg_tb);

        // Store
        opcode_tb = 7'b0100011; #1;
        $display("Store: ALUSrc=%b MemWrite=%b ALUOp=%b", ALUSrc_tb, MemWrite_tb, ALUOp_tb);

        // Branch
        opcode_tb = 7'b1100011; #1;
        $display("Branch: Branch=%b ALUSrc=%b ALUOp=%b", Branch_tb, ALUSrc_tb, ALUOp_tb);

        // JAL
        opcode_tb = 7'b1101111; #1;
        $display("JAL: RegWrite=%b Jump=%b ALUSrc=%b", RegWrite_tb, Jump_tb, ALUSrc_tb);

        // JALR
        opcode_tb = 7'b1100111; #1;
        $display("JALR: RegWrite=%b Jump=%b ALUSrc=%b", RegWrite_tb, Jump_tb, ALUSrc_tb);

        $finish;
    end

endmodule

