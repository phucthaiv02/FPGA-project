`timescale 1ns / 1ps

module square_controller_tb;

    reg clk;
    reg reset;
    reg btnU;
    reg btnL;
    reg btnD;
    reg btnR;
    reg refresh_tick;
    reg status;
    reg [19:0] position;
    wire [19:0] position_next;

    square_controller uut (
        .clk(clk),
        .reset(reset),
        .btnU(btnU),
        .btnL(btnL),
        .btnD(btnD),
        .btnR(btnR),
        .refresh_tick(refresh_tick),
        .status(status),
        .position(position),
        .position_next(position_next)
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
        btnU = 0;
        btnL = 0;
        btnD = 0;
        btnR = 0;
        status = 0;
        position = 20'd0;
        #10;
        reset = 0;
        status = 1;

        position = {10'd220, 10'd300}; // sq_y_reg = 220, sq_x_reg = 300

        #50;

        btnL = 1;
        #100;
        btnL = 0;

        btnU = 1;
        #100;
        btnU = 0;

        btnR = 1;
        #100;
        btnR = 0;

        btnD = 1;
        #100;
        btnD = 0;

        btnL = 1;
        btnU = 1;
        #100;
        btnL = 0;
        btnU = 0;

        $stop;
    end

    initial begin
        $monitor("Time=%0dns | btnU=%b btnL=%b btnD=%b btnR=%b | position_next x=%d y=%d",
                 $time, btnU, btnL, btnD, btnR, position_next[9:0], position_next[19:10]);
    end

    always @(posedge refresh_tick) begin
        position <= position_next;
    end

endmodule
