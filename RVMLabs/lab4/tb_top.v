
`default_nettype none
`timescale 1ns/1ns

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED at %2d in %m: signal != value", $time); \
            $finish; \
        end

module  tb_top;
  reg rst;
  reg clk;
  wire [`DATA_WIDTH-1:0] debug = 32'h00000000;

  top dut (
    .rst(rst),
    .clk(clk),
    .debug(debug)
  );
  initial begin
    clk = 1'b0;
  end
  always #5 clk = ~clk;
  initial begin
        rst = 1'b1; #5;
        rst = 1'b0;
  end

  always @(posedge clk) begin
    $display("time %2t, clk = %b, rst = %b, pc = %8h, opcode = %b, inst = %8h", $time, clk, rst, dut.pc, dut.dec.opcode, dut.inst);
    $display("zero = %8h  ra = %8h  sp = %8h  gp = %8h", dut.reg_file.registers[0], dut.reg_file.registers[1], dut.reg_file.registers[2], dut.reg_file.registers[3]);
    $display("  tp = %8h  t0 = %8h  t1 = %8h  t2 = %8h", dut.reg_file.registers[4], dut.reg_file.registers[5], dut.reg_file.registers[6], dut.reg_file.registers[7]);
    $display("  s0 = %8h  s1 = %8h  a0 = %8h  a1 = %8h", dut.reg_file.registers[8], dut.reg_file.registers[9], dut.reg_file.registers[10], dut.reg_file.registers[11]);
    $display("  a2 = %8h  a3 = %8h  a4 = %8h  a5 = %8h", dut.reg_file.registers[12], dut.reg_file.registers[13], dut.reg_file.registers[14], dut.reg_file.registers[15]);
    $display("  a6 = %8h  a7 = %8h  s2 = %8h  s3 = %8h", dut.reg_file.registers[16], dut.reg_file.registers[17], dut.reg_file.registers[18], dut.reg_file.registers[19]);
    $display("  s4 = %8h  s5 = %8h  s6 = %8h  s7 = %8h", dut.reg_file.registers[20], dut.reg_file.registers[21], dut.reg_file.registers[22], dut.reg_file.registers[23]);
    $display("  s8 = %8h  s9 = %8h s10 = %8h s11 = %8h", dut.reg_file.registers[24], dut.reg_file.registers[25], dut.reg_file.registers[26], dut.reg_file.registers[27]);
    $display("  t3 = %8h  t4 = %8h  t5 = %8h  t6 = %8h", dut.reg_file.registers[28], dut.reg_file.registers[29], dut.reg_file.registers[30], dut.reg_file.registers[31]);
  end
  always @(posedge clk) begin
          case (dut.opcode)
            `OP_LUI: begin  // LUI
                `assert(dut.branch, 1'b0);
                `assert(dut.take, 1'b0);
                `assert(dut.mem_write, 1'b0);
                `assert(dut.result_mux, 2'b00);
                `assert(dut.alu_src_a, 1'b0);
                `assert(dut.alu_src_b, 1'b1);
            end
            `OP_AUIPC: begin  // AUIPC
                `assert(dut.branch, 1'b0);
                `assert(dut.take, 1'b0);
                `assert(dut.mem_write, 1'b0);
                `assert(dut.result_mux, 2'b00);
                `assert(dut.alu_src_a, 1'b1);
                `assert(dut.alu_src_b, 1'b1);
            end
            `OP_JAL: begin  // JAL
                `assert(dut.branch, 1'b1);
                `assert(dut.take, 1'b1);
                `assert(dut.mem_write, 1'b0);
                `assert(dut.result_mux, 2'b01);
                `assert(dut.alu_src_a, 1'b1);
                `assert(dut.alu_src_b, 1'b1);
            end
            `OP_JALR : begin  // JALR
                `assert(dut.branch, 1'b1);
                `assert(dut.take, 1'b1);
                `assert(dut.mem_write, 1'b0);
                `assert(dut.result_mux, 2'b01);
                `assert(dut.alu_src_a, 1'b0);
                `assert(dut.alu_src_b, 1'b1);
            end
            `OP_BRANCH: begin  // Branch Instructions
                if(dut.take) begin
                  `assert(dut.branch, 1'b1);
                end
                if(dut.branch == 1'b0) begin
                    `assert(dut.take, 1'b0);
                end
                `assert(dut.mem_write, 1'b0);
                `assert(dut.result_mux, 2'b00);
                `assert(dut.alu_src_a, 1'b1);
                `assert(dut.alu_src_b, 1'b1);
            end
            `OP_LOAD: begin  // Load Instructions
              `assert(dut.branch, 1'b0);
              `assert(dut.take, 1'b0);
              `assert(dut.mem_write, 1'b0);
              `assert(dut.result_mux, 2'b10);
              `assert(dut.alu_src_a, 1'b0);
              `assert(dut.alu_src_b, 1'b1);
            end
            `OP_STORE: begin  // Store Instructions
                `assert(dut.branch, 1'b0);
                `assert(dut.take, 1'b0);
                `assert(dut.mem_write, 1'b1);
                `assert(dut.result_mux, 2'b00);
                `assert(dut.alu_src_a, 1'b0);
                `assert(dut.alu_src_b, 1'b1);
            end
            `OP_ALU: begin  // ALU Instructions
              `assert(dut.branch, 1'b0);
              `assert(dut.take, 1'b0);
              `assert(dut.mem_write, 1'b0);
              `assert(dut.result_mux, 2'b00);
              `assert(dut.alu_src_a, 1'b0);
              `assert(dut.alu_src_b, 1'b0);
            end
            `OP_ALUI: begin // Implement ADDI, ANDI, ORI, XORI, etc.
               `assert(dut.branch, 1'b0);
               `assert(dut.take, 1'b0);
               `assert(dut.mem_write, 1'b0);
               `assert(dut.result_mux, 2'b00);
                `assert(dut.alu_src_a, 1'b0);
                `assert(dut.alu_src_b, 1'b1);
            end
            `OP_FENCE: begin  // Fence
                $fatal(1, "Fatal error occurred!");
                // Implement fence instruction
            end
            `OP_SYSTEM: begin  // System Instructions
                // ImplemeAnt ECALL, EBREAK, etc.
                $display("End of Simulation");
                $finish;
                //$fatal(1, "Fatal error occurred!");
            end
            default: begin
                // Handle unrecognized opcodes
                $display("End of Simulation");
                $fatal(1, "Unrecognized instruction!");
            end
        endcase
  end
  initial begin
    $dumpfile("tb_top.vcd");
    $dumpvars;
  end

endmodule

