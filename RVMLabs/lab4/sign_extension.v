`include "definitions.vh"
`default_nettype none
`timescale 1ns/1ns

module sign_extension (
    input wire [`INST_WIDTH-1:0]    i_inst,
    input wire [`OPCODE-1:0]        i_opcode,
    output reg [`INST_WIDTH-1:0]    immediate_extended
);
    always @* begin
        case (i_opcode)
            `OP_ALUI, `OP_LOAD, `OP_JALR: begin
                if (i_inst[31] == 1'b1) begin
                    immediate_extended = {20'hFFFFF, i_inst[31:20]};
                end else begin
                    immediate_extended = {20'h00000, i_inst[31:20]};
                end
            end
            `OP_STORE: begin
                if (i_inst[31] == 1'b1) begin
                    immediate_extended = {20'hFFFFF, i_inst[31:25], i_inst[11:7]};
                end else begin
                    immediate_extended = {20'h00000, i_inst[31:25], i_inst[11:7]};
                end
            end
            `OP_LUI, `OP_AUIPC: immediate_extended = {i_inst[31:12], 12'h000};
            `OP_JAL: begin
                if (i_inst[31] == 1'b1) begin
                    immediate_extended = {20'hFFF, i_inst[31], i_inst[19:12],  i_inst[20], i_inst[30:21], 1'b0};
                end else begin
                    immediate_extended = {20'h000, i_inst[31], i_inst[19:12],  i_inst[20], i_inst[30:21], 1'b0};
                end
            end
            `OP_BRANCH: begin
                if (i_inst[31] == 1'b1) begin
                    immediate_extended = {20'hFFFFF, i_inst[31], i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0};
                end else begin
                    immediate_extended = {20'h00000, i_inst[31], i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0};
                end
            end
            default: immediate_extended = 32'hFFFF_FFFF;
        endcase
    end

endmodule

