`timescale 1ns / 1ps
// Include ALU operation definitions
`include "definitions.vh"

module tb_alu;
    // Parameters
    parameter DATA_WIDTH = 32;
    // Inputs to the ALU
    reg [5:0] i_alu_op;
    reg [DATA_WIDTH-1:0] i_a;
    reg [DATA_WIDTH-1:0] i_b;

    // Output from the ALU
    wire [DATA_WIDTH-1:0] o_c;
    // Instantiate the ALU Unit (Unit Under Test)
    alu_unit uut (
        .i_alu_op(i_alu_op),
        .i_a(i_a),
        .i_b(i_b),
        .o_c(o_c)
    );
    // Task to display the test case results
    task display_test;
        input [5:0] op;
        input [DATA_WIDTH-1:0] a;
        input [DATA_WIDTH-1:0] b;
        input [DATA_WIDTH-1:0] expected;
        begin
            if (o_c === expected)
                $display("Test Passed: ALU_OP = %b, i_a = %h, i_b = %h, o_c = %h", op, a, b, o_c);
            else
                $display("Test Failed: ALU_OP = %b, i_a = %h, i_b = %h, o_c = %h (Expected: %h)", op, a, b, o_c, expected);
        end
    endtask
   // Testbench procedure
    initial begin
        // Test Addition (ALU_ADD)
        i_a = 32'h00000005; i_b = 32'h00000003; i_alu_op = `OP_ALU_ADD;
        #10;
        display_test(i_alu_op, i_a, i_b, 32'h00000008);  // 5 + 3 = 8
        // Test Subtraction (ALU_SUB)
        i_a = 32'h0000000A; i_b = 32'h00000003; i_alu_op = `OP_ALU_SUB;
        #10;
        display_test(i_alu_op, i_a, i_b, 32'h00000007);  // 10 - 3 = 7
        // Test Bitwise AND (ALU_AND)
        i_a = 32'h0F0F0F0F; i_b = 32'h00FF00FF; i_alu_op = `OP_ALU_AND;
        #10;
        display_test(i_alu_op, i_a, i_b, 32'h000F000F);  // 0F0F0F0F & 00FF00FF = 000F000F
        // Test Bitwise OR (ALU_OR)
        i_a = 32'h0F0F0F0F; i_b = 32'h00FF00FF; i_alu_op = `OP_ALU_OR;
        #10;
        display_test(i_alu_op, i_a, i_b, 32'h0FFF0FFF);  // OR operation
	        // Test Bitwise XOR (ALU_XOR)
        i_a = 32'h0F0F0F0F; i_b = 32'h00FF00FF; i_alu_op = `OP_ALU_XOR;
        #10;
        display_test(i_alu_op, i_a, i_b, 32'h0FF00FF0);  // XOR operation
        // Test Shift Left Logical (ALU_SLL)
        i_a = 32'h00000001; i_b = 32'h00000004; i_alu_op = `OP_ALU_SLL;
        #10;
        display_test(i_alu_op, i_a, i_b, 32'h00000010);  // 1 << 4 = 16
        // Test Shift Right Logical (ALU_SRL)
        i_a = 32'h00000010; i_b = 32'h00000002; i_alu_op = `OP_ALU_SRL;
        #10;
        display_test(i_alu_op, i_a, i_b, 32'h00000004);  // 16 >> 2 = 4
        // Test Shift Right Arithmetic (ALU_SRA)
        i_a = 32'hFFFFFFF0; i_b = 32'h00000002; i_alu_op = `OP_ALU_SRA;
        #10;
        display_test(i_alu_op, i_a, i_b, 32'hFFFFFFFC);  // -16 >> 2 = -4 (signed shift)
        // Test Set Less Than (ALU_SLT)
        i_a = 32'hFFFFFFFE; i_b = 32'h00000001; i_alu_op = `OP_ALU_SLT;
        #10;
        display_test(i_alu_op, i_a, i_b, 32'h00000001);  // -2 < 1 = 1
        // Test Set Less Than Unsigned (ALU_SLTU)
        i_a = 32'h00000001; i_b = 32'hFFFFFFFF; i_alu_op = `OP_ALU_SLTU;
        #10;
        display_test(i_alu_op, i_a, i_b, 32'h00000001);  // 1 < 0xFFFFFFFF = 1
        // Test Multiplication (ALU_MUL)
        i_a = 32'h00000003; i_b = 32'h00000004; i_alu_op = `OP_ALU_MUL;
        #10;
        display_test(i_alu_op, i_a, i_b, 32'h0000000C);  // 3 * 4 = 12
        // Test Division (ALU_DIV)
        i_a = 32'h00000008; i_b = 32'h00000002; i_alu_op = `OP_ALU_DIV;
        #10;
        display_test(i_alu_op, i_a, i_b, 32'h00000004);  // 8 / 2 = 4
        // Test Division by Zero (ALU_DIV)
        i_a = 32'h00000008; i_b = 32'h00000000; i_alu_op = `OP_ALU_DIV;
        #10;
        display_test(i_alu_op, i_a, i_b, 32'h00000000);  // 8 / 0 = 0 (safe division)
        // Test Remainder (ALU_REM)
        i_a = 32'h00000009; i_b = 32'h00000004; i_alu_op = `OP_ALU_REM;
        #10;
        display_test(i_alu_op, i_a, i_b, 32'h00000001);  // 9 % 4 = 1
        // Test Remainder Unsigned (ALU_REMU)
        i_a = 32'h00000009; i_b = 32'h00000004; i_alu_op = `OP_ALU_REMU;
        #10;
        display_test(i_alu_op, i_a, i_b, 32'h00000001);  // 9 % 4 = 1
        // Finish simulation
        #10;
        $finish;
    end

endmodule

