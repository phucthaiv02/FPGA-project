`timescale 1ns / 1ps

module pixel_generation_tb;

    reg clk;
    reg reset;
    reg video_on;
    reg [9:0] x;
    reg [9:0] y;
    reg [659:0] position;
    wire [11:0] rgb;

    integer i;

    pixel_generation uut (
        .clk(clk),
        .reset(reset),
        .video_on(video_on),
        .x(x),
        .y(y),
        .position(position),
        .rgb(rgb)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        video_on = 0;
        x = 0;
        y = 0;
        position = 0;
        #20;
        reset = 0;

        video_on = 1;

        position[659:650] = 10'd100; // main_sq_y_t
        position[649:640] = 10'd100; // main_sq_x_l

        for (i = 0; i < 16; i = i + 1) begin
            position[i*40 + 19 -:10] = 10'd150 + i*10; // sq_y_t
            position[i*40 + 9 -:10] = 10'd150 + i*10;  // sq_x_l
        end

        #10;
        x = 10'd100;
        y = 10'd100;
        #10;
        $display("x=%d y=%d rgb=%h", x, y, rgb);

        x = 10'd115;
        y = 10'd115;
        #10;
        $display("x=%d y=%d rgb=%h", x, y, rgb);

        x = 10'd200;
        y = 10'd200;
        #10;
        $display("x=%d y=%d rgb=%h", x, y, rgb);

        x = 10'd160;
        y = 10'd160;
        #10;
        $display("x=%d y=%d rgb=%h", x, y, rgb);

        video_on = 0;
        x = 10'd100;
        y = 10'd100;
        #10;
        $display("x=%d y=%d rgb=%h (video_off)", x, y, rgb);

        $stop;
    end

endmodule
