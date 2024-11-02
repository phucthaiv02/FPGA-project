`timescale 1ns / 1ps

module tb_square_controller;
    // Khai báo biến mô phỏng
    reg clk;
    reg reset;
    reg btnU, btnL, btnD, btnR;
    reg refresh_tick;
    reg status;
    reg [19:0] position;
    wire [19:0] position_next;

    // Khởi tạo module cần kiểm tra
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

    // Tạo xung nhịp 100MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Chu kỳ 10 ns tương đương với tần số 100MHz
    end

    // Quy trình kiểm thử
    initial begin
        // Khởi tạo reset và các tín hiệu ban đầu
        reset = 1;
        btnU = 0;
        btnL = 0;
        btnD = 0;
        btnR = 0;
        refresh_tick = 0;
        status = 1;
        position = {10'd220, 10'd300}; // Vị trí ban đầu
        #20 reset = 0; // Bỏ reset sau 20 ns

        // Kiểm thử 1: Di chuyển lên
        btnU = 1;
        refresh_tick = 1;
        #10 refresh_tick = 0;
        btnU = 0;
        #20;
        $display("Move Up: position_next = %d, %d", position_next[19:10], position_next[9:0]);

        // Kiểm thử 2: Di chuyển xuống
        btnD = 1;
        refresh_tick = 1;
        #10 refresh_tick = 0;
        btnD = 0;
        #20;
        $display("Move Down: position_next = %d, %d", position_next[19:10], position_next[9:0]);

        // Kiểm thử 3: Di chuyển trái
        btnL = 1;
        refresh_tick = 1;
        #10 refresh_tick = 0;
        btnL = 0;
        #20;
        $display("Move Left: position_next = %d, %d", position_next[19:10], position_next[9:0]);

        // Kiểm thử 4: Di chuyển phải
        btnR = 1;
        refresh_tick = 1;
        #10 refresh_tick = 0;
        btnR = 0;
        #20;
        $display("Move Right: position_next = %d, %d", position_next[19:10], position_next[9:0]);

        // Kiểm thử 5: Di chuyển ô vuông đến cạnh trên cùng của màn hình
        position = {10'd5, 10'd300}; // Đặt vị trí gần biên trên
        btnU = 1;
        refresh_tick = 1;
        #10 refresh_tick = 0;
        btnU = 0;
        #20;
        $display("Move Up to Edge: position_next = %d, %d", position_next[19:10], position_next[9:0]);

        // Kiểm thử 6: Đặt lại reset và kiểm tra vị trí ô vuông
        reset = 1;
        #20 reset = 0;
        #20;
        $display("After Reset: position_next = %d, %d", position_next[19:10], position_next[9:0]);

        // Kết thúc mô phỏng
        $stop;
    end
endmodule
