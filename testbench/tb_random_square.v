`timescale 1ns / 1ps

module tb_random_square;
    // Khai báo biến mô phỏng
    reg clk;
    reg reset;
    reg refresh_tick;
    reg status;
    reg [5:0] num_squares;
    reg [639:0] position;
    wire [639:0] position_next;

    // Khởi tạo module cần kiểm tra
    random_square uut (
        .clk(clk),
        .reset(reset),
        .refresh_tick(refresh_tick),
        .status(status),
        .num_squares(num_squares),
        .position(position),
        .position_next(position_next)
    );

    // Tạo xung nhịp 100MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Chu kỳ 10 ns tương đương với tần số 100MHz
    end

    // Quy trình kiểm thử
    initial begin
        // Khởi tạo reset và các tín hiệu ban đầu
        reset = 1;
        refresh_tick = 0;
        status = 0;
        num_squares = 0;
        position = 0;
        #20 reset = 0; // Bỏ reset sau 20 ns

        // Kiểm thử 1: Khởi tạo với không có ô vuông
        #10;
        $display("Initial position (no squares): position_next = %h", position_next);

        // Kiểm thử 2: Thêm một số ô vuông và bật refresh_tick
        num_squares = 2;
        position[39:0] = {10'd100, 10'd100}; // Ô vuông 1
        position[79:40] = {10'd200, 10'd200}; // Ô vuông 2
        status = 1;
        refresh_tick = 1;
        #10 refresh_tick = 0;

        // Kiểm tra vị trí sau khi cập nhật
        #20;
        $display("After adding squares and refresh tick: position_next = %h", position_next);

        // Kiểm thử 3: Thay đổi số lượng ô vuông và kiểm tra vị trí
        num_squares = 3;
        position[119:80] = {10'd300, 10'd300}; // Ô vuông 3
        refresh_tick = 1;
        #10 refresh_tick = 0;

        #20;
        $display("After adding another square: position_next = %h", position_next);

        // Kiểm thử 4: Đặt lại reset và kiểm tra vị trí của ô vuông
        reset = 1;
        #20 reset = 0;
        
        #20;
        $display("After reset: position_next = %h", position_next);

        // Kết thúc mô phỏng
        $stop;
    end
endmodule
