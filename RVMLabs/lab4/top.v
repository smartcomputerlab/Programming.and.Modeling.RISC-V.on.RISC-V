`include "definitions.vh"
`default_nettype none
`timescale 1ns/1ns

module top (
    input wire clk,
    input wire rst,
    output wire [`DATA_WIDTH-1:0] debug
);

    reg [`DATA_WIDTH-1:0] pc;

    always@(posedge clk or posedge rst) begin
        if(rst) begin
            pc <= 0;
        end else begin
            if(take) begin
                pc <= rd;
            end else begin
                pc <= pc + 4;
            end
        end
    end

    wire [`INST_WIDTH-1:0] inst;

    instruction_memory imem (
        .addr(pc),
        .inst(inst)
    );

    wire [`DATA_WIDTH-1:0] data;

    data_memory dmem (
        .i_clk(clk),
        .i_we(mem_write),
        .i_addr(rd),
        .i_data(rs2),
        .o_data(data)
    );

    reg [`DATA_WIDTH-1:0] result;

    always @* begin
        case (result_mux)
            2'b00: result = rd;
            2'b01: result = pc + 4;
            2'b10: result = data;
        default: result = 32'b0;
        endcase
    end

    assign debug = result;

    wire [`INST_WIDTH-1:0] immediate;

    sign_extension sign_ext (
        .i_inst(inst),
        .i_opcode(opcode),
        .immediate_extended(immediate)
    );

    wire branch;
    wire [1:0] result_mux;
    wire [5:0] alu_op;
    wire [2:0] branch_op;
    wire mem_write;
    wire alu_src_a;
    wire alu_src_b;
    wire reg_write;
    wire [`OPCODE-1:0] opcode;
    wire [$clog2(`NUM_REGISTER) - 1: 0] rs1_addr;
    wire [$clog2(`NUM_REGISTER) - 1: 0] rs2_addr;
    wire [$clog2(`NUM_REGISTER) - 1: 0] rd_addr;

    decoder dec (
        .i_inst(inst),
        .o_branch(branch),
        .o_result_mux(result_mux),
        .o_alu_op(alu_op),
        .o_branch_op(branch_op),
        .o_mem_write(mem_write),
        .o_alu_src_a(alu_src_a),
        .o_alu_src_b(alu_src_b),
        .o_reg_write(reg_write),
        .o_opcode(opcode),
        .o_rs1_addr(rs1_addr),
        .o_rs2_addr(rs2_addr),
        .o_rd_addr(rd_addr)
    );

    wire [`DATA_WIDTH-1:0] rs1;
    wire [`DATA_WIDTH-1:0] rs2;
    wire [`DATA_WIDTH-1:0] rd;

    register_file reg_file (
        .i_clk(clk),
        .i_rst(rst),
        .i_we(reg_write),
        .i_rd_addr(rd_addr),
        .i_rd(result),
        .i_rs1_addr(rs1_addr),
        .i_rs2_addr(rs2_addr),
        .o_rs1(rs1),
        .o_rs2(rs2)
    );
    wire [`DATA_WIDTH-1:0] sel_alu_src_a;
    wire [`DATA_WIDTH-1:0] sel_alu_src_b;
    assign sel_alu_src_a = (alu_src_a == 0) ? rs1 : pc;
    assign sel_alu_src_b = (alu_src_b == 0) ? rs2 : immediate;

    alu_unit alu (
        .i_alu_op(alu_op),
        .i_a(sel_alu_src_a),
        .i_b(sel_alu_src_b),
        .o_c(rd)
    );

    wire take;

    branch_unit b (
        .i_branch(branch),
        .i_branch_op(branch_op),
        .i_a(rs1),
        .i_b(rs2),
        .o_take(take)
    );

endmodule

