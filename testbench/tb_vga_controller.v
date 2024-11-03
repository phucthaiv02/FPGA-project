`timescale 1ns / 1ps

module vga_controller_tb;

    reg clk_100MHz;
    reg reset;
    wire video_on;
    wire hsync;
    wire vsync;
    wire p_tick;
    wire refresh_tick;
    wire [9:0] x;
    wire [9:0] y;

    vga_controller uut (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .video_on(video_on),
        .hsync(hsync),
        .vsync(vsync),
        .p_tick(p_tick),
        .refresh_tick(refresh_tick),
        .x(x),
        .y(y)
    );

    initial begin
        clk_100MHz = 0;
        forever #5 clk_100MHz = ~clk_100MHz;
    end

    initial begin
        reset = 1;
        #20;
        reset = 0;

        #1000000;

        $stop;
    end

    initial begin
        $monitor("Time=%0dns | x=%d y=%d | hsync=%b vsync=%b | video_on=%b",
                 $time, x, y, hsync, vsync, video_on);
    end

endmodule
