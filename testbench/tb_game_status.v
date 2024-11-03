`timescale 1ns / 1ps

module game_status_tb;

    reg clk;
    reg reset;
    reg refresh_tick;
    reg [659:0] position;
    wire status;
    wire [5:0] num_squares;

    integer i;

    game_status uut (
        .clk(clk),
        .reset(reset),
        .refresh_tick(refresh_tick),
        .position(position),
        .status(status),
        .num_squares(num_squares)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        refresh_tick = 0;
        forever #20 refresh_tick = ~refresh_tick;
    end

    initial begin
        reset = 1;
        position = 0;
        #10;
        reset = 0;

        // Giả sử main square ở tọa độ (100, 100)
        position[659:650] = 10'd100; // main_sq_y_t
        position[649:640] = 10'd100; // main_sq_x_l

        position[19:10] = 10'd110; // sq0_y_t
        position[9:0]   = 10'd110; // sq0_x_l

        for (i = 1; i < 16; i = i + 1) begin
            position[i*40 + 19 -:10] = 10'd200 + i*10; // sq_y_t
            position[i*40 + 9  -:10] = 10'd200 + i*10; // sq_x_l
        end

        #100;

        position[19:10] = 10'd300;
i 
        #150;

        $stop;
    end

    initial begin
        $monitor("Time =%0dns | status=%b | num_squares=%d | score=%d",
                 $time, status, num_squares, uut.score);
    end

endmodule
