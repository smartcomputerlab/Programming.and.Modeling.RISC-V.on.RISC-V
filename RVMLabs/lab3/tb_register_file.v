module tb_register_file;

    // Define constants
    `define NUM_REGISTER 32
    `define DATA_WIDTH 32
    // Inputs to the Register File
    reg i_clk;                                        // Clock signal
    reg i_rst;                                        // Reset signal
    reg i_we;                                         // Write enable signal
    reg [$clog2(`NUM_REGISTER)-1:0] i_rd_addr;        // Address of destination register
    reg [`DATA_WIDTH-1:0] i_rd;                       // Data to be written to the register
    reg [$clog2(`NUM_REGISTER)-1:0] i_rs1_addr;       // Address of the first source register
    reg [$clog2(`NUM_REGISTER)-1:0] i_rs2_addr;       // Address of the second source register
    // Outputs from the Register File
    wire [`DATA_WIDTH-1:0] o_rs1;                     // Data from the first source register
    wire [`DATA_WIDTH-1:0] o_rs2;                     // Data from the second source register
    // Instantiate the Register File module
    register_file uut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_we(i_we),
        .i_rd_addr(i_rd_addr),
        .i_rd(i_rd),
        .i_rs1_addr(i_rs1_addr),
        .i_rs2_addr(i_rs2_addr),
        .o_rs1(o_rs1),
        .o_rs2(o_rs2)
    );
    // Clock Generation
    always #5 i_clk = ~i_clk; // Generate clock signal with 10ns period
    // Simulation Initialization
    initial begin
        // Initialize signals
        i_clk = 0;
        i_rst = 1;            // Assert reset initially
        i_we = 0;
        i_rd_addr = 0;
        i_rd = 0;
        i_rs1_addr = 0;
        i_rs2_addr = 0;
        // Apply reset for a few cycles
        #10;
        i_rst = 0;            // Deassert reset after 10ns
        // Test Writing to Register and Reading Back
        // Write value 32'hDEADBEEF to register x1
        #10;
        i_we = 1;              // Enable write
        i_rd_addr = 5'd1;      // Write to register 1
        i_rd = 32'hDEADBEEF;   // Data to write
        #10;
        i_we = 0;              // Disable write
        // Read value back from register x1 to verify
        i_rs1_addr = 5'd1;     // Set address of register x1 for reading
        #10;
        $display("Read Register x1: Expected = %h, Got = %h", 32'hDEADBEEF, o_rs1);
        // Write value 32'h12345678 to register x2
        #10;
        i_we = 1;              // Enable write
        i_rd_addr = 5'd2;      // Write to register 2
        i_rd = 32'h12345678;   // Data to write
        #10;
        i_we = 0;              // Disable write
        // Read value back from register x2 to verify
        i_rs2_addr = 5'd2;     // Set address of register x2 for reading
        #10;
        $display("Read Register x2: Expected = %h, Got = %h", 32'h12345678, o_rs2);
        // Test reading both registers simultaneously
        i_rs1_addr = 5'd1;     // Set address of register x1 for reading
        i_rs2_addr = 5'd2;     // Set address of register x2 for reading
        #10;
        $display("Read Registers x1 and x2: Expected x1 = %h, Got x1 = %h, Expected x2 = %h, Got x2 = %h",
                 32'hDEADBEEF, o_rs1, 32'h12345678, o_rs2);
  // Test writing to register x0 (should not write, x0 is always zero)
        #10;
        i_we = 1;              // Enable write
        i_rd_addr = 5'd0;      // Write to register 0
        i_rd = 32'hFFFFFFFF;   // Data to write
        #10;
        i_we = 0;              // Disable write
        // Read value from register x0 (should always be zero)
        i_rs1_addr = 5'd0;     // Set address of register x0 for reading
        #10;
        $display("Read Register x0: Expected = %h, Got = %h", 32'h00000000, o_rs1);
        // Finish simulation
        #20;
        $finish;
    end
    initial begin
    $dumpfile("tb_register_file.vcd");
    $dumpvars;
    end
endmodule

