`timescale 1ns / 1ps

module clock_generator_tb;

    reg clk;
    reg reset;
    wire clk_1Hz;

    clock_generator uut (
        .clk(clk),
        .reset(reset),
        .clk_1Hz(clk_1Hz)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #20;
        reset = 0; 

        #2000000000;

        $stop;
    end

    initial begin
        $monitor("Time = %0t ns | clk_1Hz = %b", $time, clk_1Hz);
    end

endmodule
