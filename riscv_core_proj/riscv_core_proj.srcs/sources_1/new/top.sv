

module top#( parameter MEM_SIZE= 1024 )(
 input logic clk,
 input logic rst
    );
    
    
    
    // program counter
     logic [31:0] pc_current, pc_next, pc_plus4;

    pc pc_inst (
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc_current(pc_current)
    );
    
    assign pc_plus4= pc_current+ 32'd4;
    
    
    //instruction memory 
    logic [31:0] instr;

    instr_mem #(.MEM_SIZE(MEM_SIZE)) instr_mem_inst (
        .addr(pc_current),
        .instr(instr)
    );
    
    //instruction decoder 
    logic [6:0]  opcode;
    logic [4:0]  rd, rs1, rs2;
    logic [2:0]  funct3;
    logic [6:0]  funct7;
    logic [31:0] imm_i, imm_s, imm_b, imm_u, imm_j;
    logic is_r_type, is_i_type, is_s_type, is_b_type, is_u_type, is_j_type;

    instr_decoder decoder_inst (
        .instr(instr),
        .opcode(opcode),
        .rd(rd ),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .imm_i(imm_i),
        .imm_s (imm_s),
        .imm_b(imm_b),
        .imm_u(imm_u),
        .imm_j(imm_j),
        .is_r_type(is_r_type),
        .is_i_type(is_i_type),
        .is_s_type(is_s_type),
        .is_b_type(is_b_type),
        .is_u_type(is_u_type),
        .is_j_type(is_j_type)
    );
    
    
    // control unit 
    logic RegWrite, MemRead, MemWrite , ALUSrc, Branch, Jump, MemToReg;
    logic [2:0] ALUOp ;

    control_unit ctrl_inst (
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
    
    //register file 
     logic [31:0] reg_data1, reg_data2, write_back_data;

    reg_file regfile_inst (
        .clk(clk),
        .rst(rst),
        .reg_write(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_back_data),
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );
    
    
    // alu control 
    logic [3:0] alu_ctrl;

    alu_control alu_ctrl_inst (
        .alu_op(ALUOp[1:0]),     //  only 2 bits used
        .funct3(funct3),
        .funct7_5(funct7[5]),     // bit  30 of instr
        .alu_ctrl(alu_ctrl)
    );
    
    // ALU  
    logic [31:0] alu_operand_b, alu_result;
    logic zero, lt_signed, lt_unsigned, ge_signed, ge_unsigned;

    assign alu_operand_b = (ALUSrc) ? imm_i : reg_data2;

    alu alu_inst (
        .operand_a(reg_data1),
        .operand_b(alu_operand_b),
        .alu_ctrl(alu_ctrl),
        .alu_result(alu_result),
        .zero(zero),
        .lt_signed(lt_signed),
        .lt_unsigned(lt_unsigned),
        .ge_signed(ge_signed),
        .ge_unsigned(ge_unsigned)
    );
    
    
    //  branch control 
     logic take_branch;

    branch_control branch_ctrl_inst (
//        .branch(Branch),
//        .jump(Jump),
//        .funct3(funct3),
//        .zero(zero),
//        .lt_signed(lt_signed),
//        .lt_unsigned(lt_unsigned),
//        .ge_signed(ge_signed),
//        .ge_unsigned(ge_unsigned),
//        .take_branch(take_branch)
            .funct3(funct3),         
            .zero(zero),           
            .less_than(lt_signed),      
            .greater_equal(ge_signed),  
            .less_than_u(lt_unsigned),    
            .greater_equal_u(ge_unsigned),
            .branch_taken(take_branch)    
                );
    
    
    //data memory
    logic [31:0] read_data_mem;

    data_mem #(.MEM_SIZE(MEM_SIZE)) dmem_inst (
        .clk(clk),
        .MemWrite(MemWrite),
        .addr(alu_result),
        .write_data(reg_data2),
        .read_data(read_data_mem)
    );
    
    
    // write-back  mux
        
        assign write_back_data = (MemToReg) ? read_data_mem : alu_result;   
    
    // next pc logic 
      assign pc_next = (take_branch) ? (pc_current + imm_b) :
                            ( Jump)  ? (pc_current + imm_j) :
                                     pc_plus4;
    
    
endmodule
