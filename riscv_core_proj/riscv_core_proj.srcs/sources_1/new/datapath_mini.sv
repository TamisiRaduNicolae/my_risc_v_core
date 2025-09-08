`timescale 1ns / 1ps



    module datapath_mini(
        input  logic [31:0] instr,
        input  logic [31:0] reg_rs1,
        input  logic [31:0] reg_rs2,
        output logic [31:0] alu_result,
        output logic        zero
    );
    
    // Decoder outputs
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;


    // Control signals
    logic RegWrite, MemRead, MemWrite, ALUSrc, Branch, Jump, MemToReg;
    
    logic [2:0] ALUOp;


    // ALU control
    logic [3:0] alu_ctrl;
    
    

    // Immediate (optional, just to drive ALUSrc=1 case)
    
    logic [31:0] imm_i;
    imm_gen immgen (
        .instr(instr),
        .imm_i(imm_i),
        .imm_s(), .imm_b(), .imm_u(), .imm_j() );
    

    // Instruction decoder
   
    instr_decoder decoder (
        .instr(instr),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7)
    );



    // Control Unit
    control_unit cu (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp),
        .MemToReg(MemToReg)
    );



    // ALU Control
   alu_control alu_ctrl_unit (
    .alu_op(ALUOp[1:0]),     //  control_unit outputs 3 bits, alu_control expects 2 bits
    .funct3(funct3),
    .funct7_5(funct7[5]),       // pass only instr[30] , which is bit 5 of funct7
    .alu_ctrl(alu_ctrl)
);


  
    // ALU input selection
 
    logic [31:0] alu_b;
    assign alu_b = (ALUSrc) ? imm_i : reg_rs2;



    // ALU
    
    alu alu_core (
        .operand_a(reg_rs1),
        .operand_b(alu_b),
        .alu_ctrl(alu_ctrl),
        .alu_result(alu_result),
        .zero(zero),
        .lt_signed(), .lt_unsigned(), .ge_signed(), .ge_unsigned()
    );

    endmodule

