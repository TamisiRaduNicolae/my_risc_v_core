`timescale 1ns/1ps

module instruction_memory_tb;

    logic [31:0] addr;
    logic [31:0] instr;

    // Keep depth small for the test
    instruction_memory #(.MEM_DEPTH_WORDS(16)) dut (
        .addr(addr),
        .instr(instr)
    );

    // Simple self-check task
    task expect(input [31:0] a, input [31:0] exp);
        begin
            addr = a; #1; // small delta to evaluate
            if (instr !== exp) begin
                $error("addr=%0d expected=%h got=%h", a, exp, instr);
            end else begin
                $display("OK  addr=%0d instr=%h", a, instr);
            end
        end
    endtask

    initial begin
        // (Re)load explicitly to be sure the path is right for the simulator
        $readmemh("program.hex", dut.mem);

        // Test the first four words
        expect(32'd0,  32'h00000013);
        expect(32'd4,  32'h00100093);
        expect(32'd8,  32'h00200113);
        expect(32'd12, 32'h00308193);

        // Out-of-bounds check (returns NOP)
        expect(32'd4000, 32'h00000013);

        $display("✅ instr_mem_tb done.");
        $finish;
    end

endmodule
