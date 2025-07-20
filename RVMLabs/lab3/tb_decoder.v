`timescale 1ns / 1ps

module tb_decoder;
    // Define constants
    `define INST_WIDTH 32
    `define OPCODE 7
    `define NUM_REGISTER 32
    // Inputs to the Decoder
    reg [`INST_WIDTH-1:0] i_inst;
    // Outputs from the Decoder
    wire [`OPCODE-1:0] o_opcode;
    wire o_branch;
    wire [1:0] o_result_mux;
    wire [2:0] o_branch_op;
    wire o_mem_write;
    wire o_alu_src_a;
    wire o_alu_src_b;
    wire o_reg_write;
    wire [5:0] o_alu_op;
    wire [$clog2(`NUM_REGISTER) - 1:0] o_rs1_addr;
    wire [$clog2(`NUM_REGISTER) - 1:0] o_rs2_addr;
    wire [$clog2(`NUM_REGISTER) - 1:0] o_rd_addr;
    // Instantiate the Decoder module
    decoder uut (
        .i_inst(i_inst),
        .o_opcode(o_opcode),
        .o_branch(o_branch),
        .o_result_mux(o_result_mux),
        .o_branch_op(o_branch_op),
        .o_mem_write(o_mem_write),
        .o_alu_src_a(o_alu_src_a),
        .o_alu_src_b(o_alu_src_b),
        .o_reg_write(o_reg_write),
        .o_alu_op(o_alu_op),
        .o_rs1_addr(o_rs1_addr),
        .o_rs2_addr(o_rs2_addr),
        .o_rd_addr(o_rd_addr)
    );
    // Simulation Initialization
    initial begin
        // Set initial instruction
        i_inst = 32'b0;
        // Wait for 10ns
        #10;
        // Test R-Type Instruction (e.g., ADD x4, x1, x2)
        i_inst = 32'b0000000_00010_00001_000_00100_0110011;  // R-Type: ADD x4, x1, x2
        #10;
        $display("R-Type (ADD): opcode = %b, rs1 = %d, rs2 = %d, rd = %d, Branch = %b, RegWrite = %b, ALUOp = %b",
                 o_opcode, o_rs1_addr, o_rs2_addr, o_rd_addr, o_branch, o_reg_write, o_alu_op);
        // Test I-Type Instruction (e.g., ADDI x4, x1, 1)
        i_inst = 32'b000000000001_00001_000_00100_0010011;   // I-Type: ADDI x4, x1, 1
        #10;
        $display("I-Type (ADDI): opcode = %b, rs1 = %d, rd = %d, RegWrite = %b, ALUOp = %b, ALUSrcB = %b",
                 o_opcode, o_rs1_addr, o_rd_addr, o_reg_write, o_alu_op, o_alu_src_b);
        // Test Load Instruction (e.g., LW x4, 4(x1))
        i_inst = 32'b000000000100_00001_010_00100_0000011;   // I-Type: LW x4, 4(x1)
        #10;
        $display("Load (LW): opcode = %b, rs1 = %d, rd = %d, RegWrite = %b, MemWrite = %b, ALUSrcB = %b, ResultMux = %b",
                 o_opcode, o_rs1_addr, o_rd_addr, o_reg_write, o_mem_write, o_alu_src_b, o_result_mux);
        // Test Store Instruction (e.g., SW x2, 4(x1))
        i_inst = 32'b0000000_00100_00001_010_00010_0100011;  // S-Type: SW x2, 4(x1)
        #10;
        $display("Store (SW): opcode = %b, rs1 = %d, rs2 = %d, MemWrite = %b, ALUSrcB = %b",
                 o_opcode, o_rs1_addr, o_rs2_addr, o_mem_write, o_alu_src_b);
        // Test Branch Instruction (e.g., BEQ x1, x2, offset)
        i_inst = 32'b0000000_00001_00010_000_00001_1100011;  // B-Type: BEQ x1, x2, offset
        #10;
        $display("Branch (BEQ): opcode = %b, rs1 = %d, rs2 = %d, Branch = %b, BranchOp = %b",
                 o_opcode, o_rs1_addr, o_rs2_addr, o_branch, o_branch_op);
        // Test Jump and Link (e.g., JAL x1, offset)
        i_inst = 32'b000000000001_00000000_00001_1101111;    // J-Type: JAL x1, offset
        #10;
        $display("Jump (JAL): opcode = %b, rd = %d, RegWrite = %b, ResultMux = %b",
                 o_opcode, o_rd_addr, o_reg_write, o_result_mux);
        // Test Jump and Link Register (e.g., JALR x2, x1, offset)
        i_inst = 32'b000000000001_00001_000_00010_1100111;   // I-Type: JALR x2, x1, offset
        #10;
        $display("Jump Register (JALR): opcode = %b, rs1 = %d, rd = %d, RegWrite = %b, ResultMux = %b",
                 o_opcode, o_rs1_addr, o_rd_addr, o_reg_write, o_result_mux);
        // Finish simulation
        $finish;
    end
endmodule

