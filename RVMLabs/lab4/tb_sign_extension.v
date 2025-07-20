`timescale 1ns/1ps
`include "definitions.vh"

module tb_sign_extension;
    // Parameters
    parameter INST_WIDTH = `INST_WIDTH;
    parameter OPCODE = `OPCODE;
    // Inputs to the Sign Extension module
    reg [INST_WIDTH-1:0] i_inst;
    reg [OPCODE-1:0] i_opcode;
    // Output from the Sign Extension module
    wire [INST_WIDTH-1:0] immediate_extended;
    // Instantiate the Sign Extension Module (Unit Under Test)
    sign_extension uut (
        .i_inst(i_inst),
        .i_opcode(i_opcode),
        .immediate_extended(immediate_extended)
    );
    // Task to display test results
    task display_test;
        input [INST_WIDTH-1:0] inst;
        input [OPCODE-1:0] opcode;
        input [INST_WIDTH-1:0] expected_imm;
        begin
            if (immediate_extended === expected_imm)
                $display("Test Passed: i_inst = %h, i_opcode = %b, immediate_extended = %h", inst, opcode, immediate_extended);
            else
                $display("Test Failed: i_inst = %h, i_opcode = %b, immediate_extended = %h (Expected: %h)", inst, opcode, immediate_extended, expected_imm);
        end
    endtask
    // Testbench procedure
    initial begin
        // Test 1: I-Type Immediate (e.g., ADDI)
        i_inst = 32'b000000000001_00010_001_00011_0010011; // I-Type with imm = 1
        i_opcode = 7'b0010011;  // Opcode for I-Type (ADDI)
        #10;
        display_test(i_inst, i_opcode, 32'h00000001); // Expected: 1 (sign-extended)
        // Test 2: I-Type Immediate (Negative value)
        i_inst = 32'b111111111111_00010_001_00011_0010011; // I-Type with imm = -1
        i_opcode = 7'b0010011;  // Opcode for I-Type (ADDI)
        #10;
        display_test(i_inst, i_opcode, 32'hFFFFFFFF); // Expected: -1 (sign-extended)
        // Test 3: S-Type Immediate (e.g., SW)
        i_inst = 32'b1111111_00011_00010_010_00011_0100011; // S-Type with imm = -1
        i_opcode = 7'b0100011;  // Opcode for S-Type (SW)
        #10;
        display_test(i_inst, i_opcode, 32'hFFFFFFFF); // Expected: -1 (sign-extended)
        // Test 4: B-Type Immediate (e.g., BEQ)
        i_inst = 32'b111111_00011_00010_000_1111111_1100011; // B-Type with imm = -2
        i_opcode = 7'b1100011;  // Opcode for B-Type (BEQ)
        #10;
        display_test(i_inst, i_opcode, 32'hFFFFFFFE); // Expected: -2 (sign-extended)
        // Test 5: U-Type Immediate (e.g., LUI)
        i_inst = 32'b00000000000000000001_00010_0110111; // U-Type with imm = 0x00010000
        i_opcode = 7'b0110111;  // Opcode for U-Type (LUI)
        #10;
        display_test(i_inst, i_opcode, 32'h00010000); // Expected: 0x00010000
        // Test 6: J-Type Immediate (e.g., JAL)
        i_inst = 32'b00000000000111111111_00000_1101111; // J-Type with imm = 0x001FF
        i_opcode = 7'b1101111;  // Opcode for J-Type (JAL)
        #10;
        display_test(i_inst, i_opcode, 32'h000001FF); // Expected: 0x001FF (sign-extended)
        // Finish simulation
        #10;
        $finish;
    end

endmodule

