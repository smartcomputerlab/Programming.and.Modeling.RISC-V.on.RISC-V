`include "definitions.vh"
`default_nettype none
`timescale 1ns/1ns

module decoder (
    input wire [`INST_WIDTH-1:0] i_inst,
    output wire [`OPCODE-1:0] o_opcode,
    output reg o_branch,
    output reg [1:0] o_result_mux,
    output reg [2:0] o_branch_op,
    output reg o_mem_write,
    output reg o_alu_src_a,
    output reg o_alu_src_b,
    output reg o_reg_write,
    output reg [5:0] o_alu_op,
    output wire [$clog2(`NUM_REGISTER) - 1: 0] o_rs1_addr,
    output wire [$clog2(`NUM_REGISTER) - 1: 0] o_rs2_addr,
    output wire [$clog2(`NUM_REGISTER) - 1: 0] o_rd_addr
);

    wire [`OPCODE-1:0] opcode = i_inst[`OPCODE-1:0];
    wire [`FUNCT_7-1:0] funct_7 = i_inst[`INST_WIDTH-1:`INST_WIDTH-`FUNCT_7];
    wire [2:0] funct_3 = i_inst[14:12];

      always @* begin
        o_branch = 0;
        o_result_mux = 2'b00;
        o_alu_op = `OP_ALU_ADD;
        o_branch_op = `BRANCH_BEQ;
        o_mem_write = 0;
        o_alu_src_a = 0;
        o_alu_src_b = 0;
        o_reg_write = 0;
        case (opcode)
            `OP_LUI: begin  // LUI
                o_alu_src_b = 1;
                o_reg_write = 1;
            end
            `OP_AUIPC: begin  // AUIPC
                o_alu_src_a = 1;
                o_alu_src_b = 1;
                o_reg_write = 1;
            end
            `OP_JAL: begin  // JAL
                o_reg_write = 1;
                o_branch = 1;
                o_result_mux = 2'b01;
                o_alu_src_a = 1;
                o_alu_src_b = 1;
                o_branch_op = `BRANCH_JAL_JALR;
            end
	                `OP_JALR : begin  // JALR
                o_reg_write = 1;
                o_branch = 1;
                o_result_mux = 2'b01;
                o_alu_src_b = 1;
                o_branch_op = `BRANCH_JAL_JALR;
            end
        `OP_BRANCH: begin  // Branch Instructions
                o_branch = 1;
                o_alu_src_a = 1;
                o_alu_src_b = 1;
                case (funct_3)
                    `BRANCH_BEQ:    o_branch_op = `BRANCH_BEQ;
                    `BRANCH_BNE:    o_branch_op = `BRANCH_BNE;
                    `BRANCH_BLT:    o_branch_op = `BRANCH_BLT;
                    `BRANCH_BGE:    o_branch_op = `BRANCH_BGE;
                    `BRANCH_BLTU:   o_branch_op = `BRANCH_BLTU;
                    `BRANCH_BGEU:   o_branch_op = `BRANCH_BGEU;
                    default:        o_branch_op = `BRANCH_BEQ;
                endcase
            end
            `OP_LOAD: begin  // Load Instructions
                o_reg_write = 1;
                o_result_mux = 2'b10;
                o_alu_src_b = 1;
            end
            `OP_STORE: begin  // Store Instructions
                o_mem_write = 1;
                o_alu_src_b = 1;
            end
            `OP_ALU: begin  // ALU Instructions
                // Implement ADD, SUB, AND, OR, XOR, etc.
                o_reg_write = 1;
                case (funct_3)
                    3'b000: begin
                        if (i_inst[30])
                            o_alu_op = `OP_ALU_SUB;
                        else
                            o_alu_op = `OP_ALU_ADD;
                    end
                    3'b111:    o_alu_op = `OP_ALU_AND;
                    3'b110:     o_alu_op = `OP_ALU_OR;
                    3'b100:    o_alu_op = `OP_ALU_XOR;
                    3'b010:    o_alu_op = `OP_ALU_SLT;
                    3'b011:   o_alu_op = `OP_ALU_SLTU;
                    3'b001:    o_alu_op = `OP_ALU_SLL;
                    3'b101:  begin
                        if(i_inst[30])
                            o_alu_op = `OP_ALU_SRA;
                        else
                            o_alu_op = `OP_ALU_SRL;
                    end
                    default:        o_alu_op = `OP_ALU_NOP;
                endcase
            end
          `OP_ALUI: begin // Implement ADDI, ANDI, ORI, XORI, etc.
                //Take IMME. as a source
                o_alu_src_b = 1;
                o_reg_write = 1;
                case (funct_3)
                    3'b000: o_alu_op = `OP_ALU_ADD;     // ADDI operation
                    3'b110: o_alu_op = `OP_ALU_OR;      // ORI operation
                    3'b111: o_alu_op = `OP_ALU_AND;     // ANDI operation
                    3'b100: o_alu_op = `OP_ALU_XOR;     // XORI operation
                    3'b001: o_alu_op = `OP_ALU_SLL;     // SLLI operation
                    3'b010: o_alu_op = `OP_ALU_SLT;     // SLTI operation
                    3'b011: o_alu_op = `OP_ALU_SLTU;    // SLTIU operation
                    3'b101: begin
                        if (i_inst[30])
                            o_alu_op = `OP_ALU_SRA;     // SRAI
                        else
                            o_alu_op = `OP_ALU_SRL;     // SRLI
                    end
                    default: o_alu_op = `OP_ALU_NOP;
                endcase
            end
            `OP_FENCE: begin  // Fence
                // Implement fence instruction
            end
            `OP_SYSTEM: begin  // System Instructions
                // Implement ECALL, EBREAK, etc.
            end
            default: begin
                // Handle unrecognized opcodes
            end
        endcase
    end
    assign o_opcode = opcode;
    assign o_rd_addr = i_inst[11:7];
    assign o_rs1_addr = `OP_LUI == opcode ? 5'b00000 : i_inst[19:15];
    assign o_rs2_addr = i_inst[24:20];

endmodule

