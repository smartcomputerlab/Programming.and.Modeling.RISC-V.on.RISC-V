`include "definitions.vh"
`default_nettype none
`timescale 1ns/1ns


module tb_branch_unit;
    // Define constants
    `define DATA_WIDTH 32
    // Inputs to the Branch Unit
    reg i_branch;                                // Branch enable signal
    reg [2:0] i_branch_op;                        // Branch operation selector
    reg [`DATA_WIDTH-1:0] i_a;                    // First operand
    reg [`DATA_WIDTH-1:0] i_b;                    // Second operand
    // Output from the Branch Unit
    wire o_take;                                  // Branch decision output
    // Instantiate the Branch Unit module
    branch_unit uut (
        .i_branch(i_branch),
        .i_branch_op(i_branch_op),
        .i_a(i_a),
        .i_b(i_b),
        .o_take(o_take)
    );
    // Simulation Initialization
    initial begin
        // Set initial values
        i_branch = 0;
        i_branch_op = 3'b000;
        i_a = 32'b0;
        i_b = 32'b0;
        // Wait for 10ns
        #10;
        // Test BEQ - Branch if Equal (opcode = 000)
        i_branch = 1;
        i_branch_op = 3'b000;  // BEQ
        i_a = 32'd10;
        i_b = 32'd10;  // Equal values
        #10;
        $display("BEQ Test 1: A = %d, B = %d, Branch = %b, Take = %b (expected 1)", i_a, i_b, i_branch, o_take);
        // Test BEQ - Branch if Equal, unequal values
        i_a = 32'd10;
        i_b = 32'd15;  // Not equal values
        #10;
        $display("BEQ Test 2: A = %d, B = %d, Branch = %b, Take = %b (expected 0)", i_a, i_b, i_branch, o_take);
        // Test BNE - Branch if Not Equal (opcode = 001)
        i_branch_op = 3'b001;  // BNE
        i_a = 32'd20;
        i_b = 32'd15;  // Not equal values
        #10;
        $display("BNE Test 1: A = %d, B = %d, Branch = %b, Take = %b (expected 1)", i_a, i_b, i_branch, o_take);
        // Test BNE - Branch if Not Equal, equal values
        i_a = 32'd25;
        i_b = 32'd25;  // Equal values
        #10;
        $display("BNE Test 2: A = %d, B = %d, Branch = %b, Take = %b (expected 0)", i_a, i_b, i_branch, o_take);
        // Test BLT - Branch if Less Than (signed, opcode = 100)
        i_branch_op = 3'b100;  // BLT
        i_a = 32'd10;
        i_b = 32'd20;  // A < B
        #10;
        $display("BLT Test 1: A = %d, B = %d, Branch = %b, Take = %b (expected 1)", i_a, i_b, i_branch, o_take);
        // Test BLT - Branch if Less Than, false condition
        i_a = 32'd30;
        i_b = 32'd20;  // A > B
        #10;
        $display("BLT Test 2: A = %d, B = %d, Branch = %b, Take = %b (expected 0)", i_a, i_b, i_branch, o_take);
        // Test BGE - Branch if Greater or Equal (signed, opcode = 101)
        i_branch_op = 3'b101;  // BGE
        i_a = 32'd30;
        i_b = 32'd20;  // A >= B
        #10;
        $display("BGE Test 1: A = %d, B = %d, Branch = %b, Take = %b (expected 1)", i_a, i_b, i_branch, o_take);
        // Test BGE - Branch if Greater or Equal, false condition
        i_a = 32'd10;
        i_b = 32'd20;  // A < B
        #10;
        $display("BGE Test 2: A = %d, B = %d, Branch = %b, Take = %b (expected 0)", i_a, i_b, i_branch, o_take);
        // Test BLTU - Branch if Less Than Unsigned (opcode = 110)
        i_branch_op = 3'b110;  // BLTU
        i_a = 32'h00000005;
        i_b = 32'h0000000F;  // A < B (unsigned)
        #10;
        $display("BLTU Test 1: A = %d, B = %d, Branch = %b, Take = %b (expected 1)", i_a, i_b, i_branch, o_take);
 // Test BGEU - Branch if Greater or Equal Unsigned (opcode = 111)
        i_branch_op = 3'b111;  // BGEU
        i_a = 32'hFFFFFFFF;
        i_b = 32'h0000000F;  // A > B (unsigned)
        #10;
        $display("BGEU Test 1: A = %d, B = %d, Branch = %b, Take = %b (expected 1)", i_a, i_b, i_branch, o_take);
        // Test BGEU - Branch if Greater or Equal Unsigned, false condition
        i_a = 32'h0000000A;
        i_b = 32'h0000000F;  // A < B (unsigned)
        #10;
        $display("BGEU Test 2: A = %d, B = %d, Branch = %b, Take = %b (expected 0)", i_a, i_b, i_branch, o_take);
        // Finish simulation
        $finish;
    end
    initial
    begin
    $dumpfile("tb_branch_unit.vcd");
    $dumpvars;
    end
endmodule

