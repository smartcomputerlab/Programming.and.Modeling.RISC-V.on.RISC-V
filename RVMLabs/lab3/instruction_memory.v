`include "definitions.vh"
`default_nettype none
`timescale 1ns/1ns

module instruction_memory #(
    // MEM_SIZE in Words
    parameter MEM_SIZE = 1024
)  (
    input wire [$clog2(MEM_SIZE)-1:0] addr,
    output reg [`INST_WIDTH-1:0] inst
);
    reg [`INST_WIDTH-1:0] memory [0:MEM_SIZE-1];
        initial begin
                $readmemh("instructions.hex",memory);
        end
    always @(addr) begin
        inst = memory[addr >> 2];
    end

endmodule

