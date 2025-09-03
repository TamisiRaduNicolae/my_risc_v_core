`timescale 1ns / 1ps


module imm_gen_tb();
    
    
 logic [31:0] instr_tb;
 logic [31:0] imm_i_tb;
 logic [31:0] imm_s_tb;
 logic [31:0] imm_b_tb;
 logic [31:0] imm_u_tb;
 logic [31:0] imm_j_tb;

 
 imm_gen dut (
     .instr(instr_tb),
     .imm_i(imm_i_tb),
     .imm_s(imm_s_tb),
     .imm_b(imm_b_tb),
     .imm_u(imm_u_tb),
     .imm_j(imm_j_tb) );
     
     
     

    task automatic check32(input [31:0] got, input [31:0] exp, input string name);
        if (got !== exp) begin
            $display("[ERROR] %s mismatch: got=0x%08h expected=0x%08h", name, got, exp);
            $fatal(1);
        end else begin
            $display("[OK]    %s = 0x%08h", name, got);
        end
    endtask



    initial begin
        $display("=== imm_gen_tb starting ===");

        // ---------- 1) I-type example: ADDI x1, x0, 1 ----------
        // encoding: 0x00100093  (we used this earlier: imm_i = 1)
        
        instr_tb = 32'h00100093;
 
          #1 check32(imm_i_tb, 32'd1, "I-type imm_i");
        
        

        // ---------- 2) S-type example: SW x5, 12(x1) ----------
        // earlier computed encoding: 0x0050A623
        // This instruction encodes imm = 12 → imm_s should be 12 (0x0000000C)
        instr_tb = 32'h0050A623;
     

         #1 check32(imm_s_tb, 32'd12, "S-type imm_s");
        

        // ---------- 3) B-type example: BEQ x1, x2, 16 ----------
        // earlier computed encoding: 0x00208863
        // imm_b should be 16 (0x00000010)
        instr_tb = 32'h00208863;
        
         #1 check32(imm_b_tb, 32'd16, "B-type imm_b");


        // ---------- 4) U-type example: LUI x5, 0x12345 ----------
        // encoding used earlier: 0x123452B7
        // imm_u should be 0x12345000
        instr_tb = 32'h123452B7;
         
        #1 check32(imm_u_tb, 32'h12345000, "U-type imm_u");


      $display("=== imm_gen_tb completed: all checks passed ===");
        $finish;
    end   
    
    
endmodule
