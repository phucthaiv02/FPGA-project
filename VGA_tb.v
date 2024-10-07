`timescale 1ns / 1ps

module tb_top;

    // Declare inputs as regs and outputs as wires
    reg clk_100MHz;                         // 100 MHz clock signal
    reg reset;                              // Reset signal
    wire hsync;                             // Horizontal sync output
    wire vsync;                             // Vertical sync output
    wire [11:0] rgb;                        // RGB output to DAC/VGA controller

    // Instantiate the top module
    top uut (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb)
    );

    // Clock generation
    initial begin
        clk_100MHz = 0;
        forever #5 clk_100MHz = ~clk_100MHz; // 100MHz clock (10ns period)
    end

    // Stimulus process
    initial begin
        // Initialize inputs
        reset = 1; // Assert reset
        #10 reset = 0; // Release reset

        // Run the simulation for a certain amount of time
        // You can adjust the duration as needed
        #200000000000; // Run for 200 us (20 cycles at 100 MHz)

        // Stop the simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("At time %t: hsync = %b, vsync = %b, rgb = %h", $time, hsync, vsync, rgb);
    end

endmodule
