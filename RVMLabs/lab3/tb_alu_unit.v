`timescale 1ns / 1ps

// Include the ALU operation definitions
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
    // Task to display the test case
    task display_test;
        input [DATA_WIDTH-1:0] expected_result;
        begin
            if (o_c === expected_result)
                $display("Test Passed: i_a = %h, i_b = %h, i_alu_op = %b, o_c = %h", i_a, i_b, i_alu_op, o_c);
            else
                $display("Test Failed: i_a = %h, i_b = %h, i_alu_op = %b, o_c = %h (Expected: %h)", i_a, i_b, i_alu_op, o_c, expected_result);
        end
    endtask
    // Testbench procedure
    initial begin
        // Initialize inputs
        i_a = 0;
        i_b = 0;
        i_alu_op = `OP_ALU_NOP;
        // Wait a bit before starting
        #10;
        // Test ADD operation
        i_a = 32'h00000005;
        i_b = 32'h00000003;
        i_alu_op = `OP_ALU_ADD;
        #10;
        display_test(32'h00000008); // Expected: 5 + 3 = 8
        // Test SUB operation
        i_a = 32'h0000000A;
        i_b = 32'h00000003;
        i_alu_op = `OP_ALU_SUB;
        #10;
        display_test(32'h00000007); // Expected: 10 - 3 = 7
        // Test AND operation
        i_a = 32'h0F0F0F0F;
        i_b = 32'h00FF00FF;
        i_alu_op = `OP_ALU_AND;
        #10;
        display_test(32'h000F000F); // Expected: AND operation
        // Test OR operation
        i_a = 32'h0F0F0F0F;
        i_b = 32'h00FF00FF;
        i_alu_op = `OP_ALU_OR;
        #10;
        display_test(32'h0FFF0FFF); // Expected: OR operation
        // Test XOR operation
        i_a = 32'h0F0F0F0F;
        i_b = 32'h00FF00FF;
        i_alu_op = `OP_ALU_XOR;
        #10;
        display_test(32'h0FF00FF0); // Expected: XOR operation
        // Test SLT (Set Less Than signed)
        i_a = 32'hFFFFFFFE;  // -2 in two's complement
        i_b = 32'h00000001;  // 1
        i_alu_op = `OP_ALU_SLT;
        #10;
        display_test(32'h00000001); // Expected: -2 < 1 = 1
        // Test SLTU (Set Less Than unsigned)
        i_a = 32'h00000001;
        i_b = 32'hFFFFFFFF;
        i_alu_op = `OP_ALU_SLTU;
        #10;
        display_test(32'h00000001); // Expected: 1 < 0xFFFFFFFF = 1
        // Test SLL (Shift Left Logical)
        i_a = 32'h00000001;
        i_b = 32'h00000004; // Shift by 4
        i_alu_op = `OP_ALU_SLL;
        #10;
        display_test(32'h00000010); // Expected: 1 << 4 = 16
        // Test SRL (Shift Right Logical)
        i_a = 32'h00000010;
        i_b = 32'h00000002; // Shift by 2
        i_alu_op = `OP_ALU_SRL;
        #10;
        display_test(32'h00000004); // Expected: 16 >> 2 = 4
        // Test SRA (Shift Right Arithmetic)
        i_a = 32'hFFFFFFF0;  // -16 in two's complement
        i_b = 32'h00000002;  // Shift by 2
        i_alu_op = `OP_ALU_SRA;
        #10;
        display_test(32'hFFFFFFFC); // Expected: -16 >> 2 = -4 (arithmetic)
        // Finish simulation
        #10;
        $finish;
    end
      initial begin
        $dumpfile("tb_alu_unit.vcd");
        $dumpvars;
      end
endmodule

