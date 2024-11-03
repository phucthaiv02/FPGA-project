`timescale 1ns / 1ps

module random_square_tb;

    reg clk;
    reg reset;
    reg refresh_tick;
    reg status;
    reg [5:0] num_squares;
    reg [639:0] position;
    wire [639:0] position_next;

    random_square uut (
        .clk(clk),
        .reset(reset),
        .refresh_tick(refresh_tick),
        .status(status),
        .num_squares(num_squares),
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
    
    integer speed_y, speed_x, pos_y, pos_x;
    integer i;
    initial begin
        reset = 1;
        status = 0;
        num_squares = 0;
        position = 0;
        #50; 
        
        reset = 0;
        status = 1;
        num_squares = 1; 
        
        #1000; 
        
        #1000; 

        status = 0;
        #1000; 

        $stop;
    end

    initial begin
        $monitor("Time=%0dns | status=%b | num_squares=%d", $time, status, num_squares);
    end
    
    always @(posedge clk) begin
        position <= position_next;
    end

    always @(posedge refresh_tick) begin
        speed_y = position_next[39:30];
        speed_x = position_next[29:20];
        pos_y = position_next[19:10];
        pos_x = position_next[9:0];
        
        $display("Time=%0dns |status=%0d | speed_y=%0d | speed_x=%0d | pos_y=%0d | pos_x=%0d", $time, status, speed_y, speed_x, pos_y, pos_x);
    end

endmodule
