`include "definitions.vh"
`default_nettype none
`timescale 1ns/1ns

module branch_unit (
    input wire i_branch,
    input wire [2:0] i_branch_op,
    input wire [`DATA_WIDTH-1:0] i_a,
    input wire [`DATA_WIDTH-1:0] i_b,
    output reg o_take
);
    always @* begin
        o_take = 0;
        if(i_branch) begin
            case (i_branch_op)
                `BRANCH_BEQ: begin //BEQ
                    if(i_a == i_b) begin
                        o_take = 1;
                    end
                end
                `BRANCH_BNE : begin //BNE
                    if(i_a != i_b) begin
                        o_take = 1;
                    end
                end
                `BRANCH_BLT: begin //BLT
                    if($signed(i_a) < $signed(i_b)) begin
                        o_take = 1;
                    end
                end
                `BRANCH_BGE: begin //BGE
                    if($signed(i_a) >= $signed(i_b)) begin
                        o_take = 1;
                    end
                end
                `BRANCH_BLTU: begin //BLTU
                    if(i_a < i_b) begin
                        o_take = 1;
                    end
                end
                `BRANCH_BGEU: begin //BGEU
                    if(i_a >= i_b) begin
                        o_take = 1;
                    end
		                    end
                `BRANCH_JAL_JALR: begin
                    o_take = 1;
                end
                default: o_take = 0;
            endcase
        end
    end
endmodule

