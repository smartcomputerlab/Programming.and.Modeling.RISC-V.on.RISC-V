`timescale 1ns/1ps
`define DATA_WIDTH 32

module tb_data_memory;
    // Parameters
    parameter MEM_SIZE = 1024;
    // Inputs to the Data Memory
    reg i_clk;                                        // Clock signal
    reg i_we;                                         // Write enable signal
    reg [`DATA_WIDTH-1:0] i_data;                     // Data to be written
    reg [$clog2(MEM_SIZE)-1:0] i_addr;                // Address to write or read the data
    // Output from the Data Memory
    wire [`DATA_WIDTH-1:0] o_data;                    // Data read from memory
    // Instantiate the Data Memory module
    data_memory #(
        .MEM_SIZE(MEM_SIZE)
    ) uut (
        .i_clk(i_clk),
        .i_we(i_we),
        .i_data(i_data),
        .i_addr(i_addr),
        .o_data(o_data)
    );
    // Clock Generation
    always #5 i_clk = ~i_clk; // Generate clock signal with 10ns period
 // Simulation Initialization
    initial begin
        // Initialize signals
        i_clk = 0;
        i_we = 0;
        i_data = 0;
        i_addr = 0;
        // Wait for 10ns
        #10;
        // Test writing data to address 0
        i_we = 1;                // Enable write
        i_addr = 0;              // Address 0
        i_data = 32'hA5A5A5A5;   // Data to write
        #10;
        i_we = 0;                // Disable write
        // Test reading data from address 0
        #10;
        $display("Address: %d, Data Written: %h, Data Read: %h (Expected: %h)", i_addr, i_data, o_data, 32'hA5A5A5A5);
        // Test writing data to address 10
        i_we = 1;                // Enable write
        i_addr = 10;             // Address 10
        i_data = 32'hDEADBEEF;   // Data to write
        #10;
        i_we = 0;                // Disable write
        // Test reading data from address 10
        #10;
        $display("Address: %d, Data Written: %h, Data Read: %h (Expected: %h)", i_addr, i_data, o_data, 32'hDEADBEEF);
        // Test writing data to address 50
        i_we = 1;                // Enable write
        i_addr = 50;             // Address 50
        i_data = 32'h12345678;   // Data to write
        #10;
        i_we = 0;                // Disable write
        // Test reading data from address 50
        #10;
        $display("Address: %d, Data Written: %h, Data Read: %h (Expected: %h)", i_addr, i_data, o_data, 32'h12345678);
       // Test reading data from address that was not written (address 100)
        i_addr = 100;            // Address 100
        #10;
        $display("Address: %d, Data Read: %h (Expected: Uninitialized value or default)", i_addr, o_data);
        // Finish simulation
        #20;
        $finish;
    end
    initial begin
    $dumpfile("tb_data_memory.vcd");
    $dumpvars;
    end

endmodule

