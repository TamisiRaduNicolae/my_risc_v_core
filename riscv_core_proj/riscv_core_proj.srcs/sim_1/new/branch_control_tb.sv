`timescale 1ns / 1ps

module branch_control_tb();

 
    logic  [2:0] funct3_tb;
    logic       zero_tb;
    logic       less_than_tb;
    logic       greater_equal_tb;
    logic       less_than_u_tb;
    logic        greater_equal_u_tb;
    logic        branch_taken_tb;

    
    branch_control dut (
        .funct3(funct3_tb),
        .zero(zero_tb),
        .less_than(less_than_tb),
        .greater_equal(greater_equal_tb),
        .less_than_u(less_than_u_tb),
        .greater_equal_u(greater_equal_u_tb),
        .branch_taken(branch_taken_tb)
    );

    // Task to test branch cases
    task test_branch(input [2:0] funct3_val,
                     input zero_val,
                     input lt_val,
                     input ge_val,
                     input ltu_val,
                     input geu_val,
                     input expected);
    begin
        funct3_tb = funct3_val;
        zero_tb   = zero_val;
        less_than_tb = lt_val;
        greater_equal_tb = ge_val;
        less_than_u_tb = ltu_val;
        greater_equal_u_tb = geu_val;
        
        #5;
        
        if (branch_taken_tb !== expected) begin
        
            $display(" ERROR: funct3=%b expected=%b got=%b",
                      funct3_val, expected, branch_taken_tb);
                      
        end else begin
        
            $display(" PASS: funct3=%b result=%b",
                      funct3_val, branch_taken_tb);
                      
        end
    end
    endtask

    initial begin
        $display("=== Starting branch_control_tb ===");

        //  BEQ
         test_branch(3'b000, 1, 0, 0, 0, 0, 1);  // zero=1  ->  branch
         test_branch(3'b000, 0, 0, 0, 0, 0, 0);  // zero=0  ->  no branch

       // BNE
        test_branch(3'b001, 0, 0, 0, 0, 0, 1);  // zero=0  ->  branch
        test_branch(3'b001, 1, 0, 0, 0, 0, 0); // zero=1  ->  no branch

       // BLT signed
        test_branch(3'b100, 0, 1, 0, 0, 0, 1);
        test_branch(3'b100, 0, 0, 1, 0, 0, 0);

      // BGE signed
        test_branch(3'b101, 0, 0, 1, 0, 0, 1);
        test_branch(3'b101, 0, 1, 0, 0, 0, 0);

       // BLTU unsigned
        test_branch(3'b110, 0, 0, 0, 1, 0, 1);
        test_branch(3'b110, 0, 0, 0, 0, 1, 0);

      //   BGEU unsigned
       test_branch(3'b111, 0, 0, 0, 0, 1, 1);
       test_branch(3'b111, 0, 0, 0, 1, 0, 0);

        $display("=== Finished branch_control_tb ===");
        $finish;
        
    end


endmodule
