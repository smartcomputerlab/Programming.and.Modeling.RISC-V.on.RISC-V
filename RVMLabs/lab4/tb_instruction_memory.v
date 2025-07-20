`timescale 1ns / 1ps

module tb_instruction_memory;
    // Define constants
    `define INST_WIDTH 32
    // Parameters
    parameter MEM_SIZE = 1024;
    // Inputs to the Instruction Memory                                  
    reg [$clog2(MEM_SIZE)-1:0] addr;              // Address to fetch the instruction
    // Output from the Instruction Memory
    wire [`INST_WIDTH-1:0] inst;                  // Fetched instruction
    // Instantiate the Instruction Memory module
    instruction_memory #(
        .MEM_SIZE(MEM_SIZE)
    ) uut (
        .addr(addr),
        .inst(inst)
    );

    initial begin
            #10;
            addr = 32'h00000004;
            #10;
            addr = 32'h00000008;
            #10;
            addr = 32'h0000000c;
            #10;
            addr = 32'h00000010;
            #10;
            addr = 32'h00000014;
            #10;
            addr = 32'h00000018;
            #10;
            addr = 32'h0000001c;
            #10;
            addr = 32'h00000020;
    // Other instructions can be initialized as needed
    end
    // Simulation Initialization
    always @* begin
    $display("time %2t, addr = %3h, inst = %8h", $time, addr, inst);
    end

  initial begin
    $dumpfile("instruction_memory.vcd");
    $dumpvars;
  end

endmodule

