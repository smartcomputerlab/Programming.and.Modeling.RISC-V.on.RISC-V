`include "definitions.vh"
`default_nettype none
`timescale 1ns/1ns

module register_file (
    input wire i_clk,
    input wire i_rst,
    input wire i_we,
    input wire [$clog2(`NUM_REGISTER)-1:0] i_rd_addr,
    input wire [`DATA_WIDTH-1:0] i_rd,
    input wire [$clog2(`NUM_REGISTER)-1:0] i_rs1_addr,
    input wire [$clog2(`NUM_REGISTER)-1:0] i_rs2_addr,
    output wire [`DATA_WIDTH-1:0] o_rs1,
    output wire [`DATA_WIDTH-1:0] o_rs2
);
    reg [`NUM_REGISTER-1:0] registers [`DATA_WIDTH-1:0];
    integer i;
    initial begin
        for (i = 0; i < `NUM_REGISTER; i = i + 1) begin
            registers[i] = 0;  // Initialize each memory location to 0
        end
    end
    always @(posedge i_clk or posedge i_rst) begin
        if(i_rst) begin
            for (i = 0; i < `NUM_REGISTER; i = i + 1) begin
                registers[i] <= 0;
        end
        end else begin
            if(i_we && i_rd_addr != 0) begin
                registers[i_rd_addr] <= i_rd;
            end
        end
    end
    // We read every cycle
    assign o_rs1 = registers[i_rs1_addr];
    assign o_rs2 = registers[i_rs2_addr];

endmodule

