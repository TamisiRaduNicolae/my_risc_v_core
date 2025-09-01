`timescale 1ns / 1ps


module instr_decoder_tb();

 logic [31:0] instr_tb;
 logic [6:0]  opcode_tb;
 logic [4:0]  rd_tb, rs1_tb, rs2_tb;
 logic [2:0]  funct3_tb;
 logic [6:0]  funct7_tb;
 logic [31:0] imm_i_tb, imm_s_tb, imm_b_tb, imm_u_tb, imm_j_tb;
 logic is_r_type_tb, is_i_type_tb, is_s_type_tb, is_b_type_tb, is_u_type_tb, is_j_type_tb;


instr_decoder dut (
        .instr(instr_tb),
        .opcode(opcode_tb),
        .rd(rd_tb),
        .funct3(funct3_tb),
        .rs1(rs1_tb),
        .rs2(rs2_tb),
        .funct7(funct7_tb),
        .imm_i(imm_i_tb),
        .imm_s(imm_s_tb),
        .imm_b(imm_b_tb),
        .imm_u(imm_u_tb),
        .imm_j(imm_j_tb),
        .is_r_type(is_r_type_tb),
        .is_i_type(is_i_type_tb),
        .is_s_type(is_s_type_tb),
        .is_b_type(is_b_type_tb),
        .is_u_type(is_u_type_tb),
        .is_j_type(is_j_type_tb)
    );
    
    
    
    // helper tasks
    task automatic check_eq32(input [31:0] got, input [31:0] exp, input string what);
        if (got !== exp) begin
            $display("[ERROR] %s mismatch: got=0x%08h exp=0x%08h", what, got, exp);
            $fatal(1);
        end
    endtask
    
    
    
    
     task automatic check_eqN(input bit got, input bit exp, input string what);
        if (got !== exp) begin
            $display("[ERROR] %s mismatch: got=%0d exp=%0d", what, got, exp);
            $fatal(1);
        end
    endtask
    
    
     initial begin
        $display("=== instr_decoder_tb ===");

        // 1) I-type: ADDI x1, x0, 1 -> 0x00100093
        instr_tb = 32'h00100093;
        #1;
        check_eqN(is_i_type_tb, 1'b1, "is_i_type");
        check_eq32(imm_i_tb, 32'd1, "imm_i");
        check_eq32({27'b0, rd_tb}, 32'd1, "rd");
        check_eq32({27'b0, rs1_tb}, 32'd0, "rs1");

        // 2) R-type: ADD x3, x1, x2 -> 0x002081B3
        instr_tb = 32'h002081B3;
        #1;
        check_eqN(is_r_type_tb, 1'b1, "is_r_type");
        check_eq32({27'b0, rd_tb}, 32'd3, "rd");
        check_eq32({27'b0, rs1_tb}, 32'd1, "rs1");
        check_eq32({27'b0, rs2_tb}, 32'd2, "rs2");

        // 3) U-type: LUI x5, 0x12345 -> 0x123452B7
        instr_tb = 32'h123452B7;
        #1;
        check_eqN(is_u_type_tb, 1'b1, "is_u_type");
        check_eq32({27'b0, rd_tb}, 32'd5, "rd");
        check_eq32(imm_u_tb, 32'h12345000, "imm_u");

        $display("✅ All checks passed.");
        $finish;
    end

endmodule
