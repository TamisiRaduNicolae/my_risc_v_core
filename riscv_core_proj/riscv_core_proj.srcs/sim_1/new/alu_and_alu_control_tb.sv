`timescale 1ns / 1ps


module alu_and_alu_control_tb();

  // ALU Control inputs
    logic [1:0] alu_op_tb;
    logic [2:0] funct3_tb;
    logic       funct7_5_tb;

    // ALU datapath
    logic [31:0] a_tb, b_tb, y_tb;
    logic        z_tb;

    // Wires
    logic [3:0]  alu_ctrl_w;

    alu_control u_ctrl (
        .alu_op  (alu_op_tb),
        .funct3  (funct3_tb),
        .funct7_5(funct7_5_tb),
        .alu_ctrl(alu_ctrl_w)
    );

    alu u_alu (
        .operand_a(a_tb),
        .operand_b(b_tb),
        .alu_ctrl (alu_ctrl_w),
        .alu_result(y_tb),
        .zero     (z_tb)
    );

    task automatic check(input [1:0] ao, input [2:0] f3, input bit f7_5,
                         input [31:0] a, input [31:0] b, input [31:0] exp, input string name);
        begin
            alu_op_tb   = ao;
            funct3_tb   = f3;
            funct7_5_tb = f7_5;
            a_tb = a; b_tb = b;
            #1;
            if (y_tb !== exp) begin
                $error("FAIL %-10s : a=0x%08h b=0x%08h -> got=0x%08h exp=0x%08h (alu_op=%b f3=%03b f7_5=%0d)",
                        name, a, b, y_tb, exp, ao, f3, f7_5);
                $fatal(1);
            end else
                $display("PASS %-10s : a=0x%08h b=0x%08h -> 0x%08h", name, a, b, y_tb);
        end
    endtask

    initial begin
        // Load/Store ADD
        check(2'b00, 3'b000, 1'b0, 32'd10, 32'd5, 32'd15, "LD/ST ADD");
        // Branch SUB
        check(2'b01, 3'b000, 1'b0, 32'd10, 32'd5, 32'd5,  "BR SUB");
        // R-type ADD
        check(2'b10, 3'b000, 1'b0, 32'd7,  32'd9, 32'd16, "R ADD");
        // R-type SUB
        check(2'b10, 3'b000, 1'b1, 32'd9,  32'd7, 32'd2,  "R SUB");
        // I-type XORI (funct7_5=0)
        check(2'b10, 3'b100, 1'b0, 32'hAA55AA55, 32'h0F0F0F0F, 32'hA05AA05A, "I XORI");
        // R-type SRA vs SRL
        check(2'b10, 3'b101, 1'b1, 32'h8000_0000, 32'd1, 32'hC000_0000, "R SRA");
        check(2'b10, 3'b101, 1'b0, 32'h8000_0000, 32'd1, 32'h4000_0000, "R SRL");

        $display("=== alu_with_control_tb done: all checks passed ===");
        $finish;
    end


endmodule
