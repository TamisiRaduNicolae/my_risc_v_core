
module instr_decoder(
input  logic [31:0] instr,

    // raw fields
    output logic [6:0]  opcode,
    output logic [4:0]  rd,
    output logic [2:0]  funct3,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [6:0]  funct7,

    // immediates , sign-extended to 32  bits 
    output logic [31:0] imm_i,
    output logic [31:0] imm_s,
    output logic [31:0] imm_b,
    output logic [31:0] imm_u,
    output logic [31:0] imm_j,

    // quick format flags
    output logic is_r_type,
    output logic is_i_type,
    output logic is_s_type,
    output logic is_b_type,
    output logic is_u_type,
    output logic is_j_type
    );
    
    
    // basic fields, common to all formats  
    assign opcode = instr[6:0];
    assign rd     = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1    = instr[19:15];
    assign rs2    = instr[24:20];
    assign funct7 = instr[31:25];
    
    
    
    // immediates ( RV32I encodings )
    // I-type: imm[31:20]
    // Sign-extend bit 31 (instr[31])
    assign imm_i = {{20{instr[31]}},
                     instr[31:20]};
    
    
    // S-type: imm[31:25] (hi) & imm[11:7] (lo)
    assign imm_s = {{20{instr[31]}},
                     instr[31:25],
                      instr[11:7]};

    // B-type: imm[12|10:5|4:1|11] << 1  (assembled as: [31], [7], [30:25], [11:8], 0)
    // Bits layout: imm[12] = instr[31], imm[11] = instr[7], imm[10:5] = instr[30:25], imm[4:1] = instr[11:8], imm[0]=0
    assign imm_b = {{19{instr[31]}}, instr[31], instr[7],   
                        instr[30:25], instr[11:8], 1'b0};

    // U-type: imm[31:12] << 12
    assign imm_u = {instr[31:12], 12'b0};

    // J-type: imm[20|10:1|11|19:12] << 1 (assembled as: [31], [19:12], [20], [30:21], 0)
    // imm[20] = instr[31], imm[19:12]=instr[19:12], imm[11]=instr[20], imm[10:1]=instr[30:21], imm[0]=0
    assign imm_j = {{11{instr[31]}}, instr[31], instr[19:12],
                         instr[20], instr[30:21], 1'b0};

    // format flags by opcode (RV32I base)
    // we only flag the canonical opcodes - good enough for control & debugging
    always_comb 
    begin
               is_r_type = 1'b0;
               is_i_type = 1'b0;
               is_s_type = 1'b0;
               is_b_type = 1'b0;
               is_u_type = 1'b0;
               is_j_type = 1'b0;

        unique case (opcode)
               7'b0110011:                              is_r_type = 1'b1; // op ( R-type : add , sub , and , or , ...)
               
               7'b0010011, 7'b0000011, 7'b1100111:      is_i_type = 1'b1; // op-imm, load, jalr
                
               7'b0100011:                              is_s_type = 1'b1; // store
               
               7'b1100011:                              is_b_type = 1'b1; // branch
               
               7'b0110111, 7'b0010111:                  is_u_type = 1'b1; // lui, auipc
               
               7'b1101111:                              is_j_type = 1'b1; // jal
               
               default: ;                   // unknown or unsupported
        endcase
    end
    
    
endmodule
