`timescale 1ns / 1ps

module tb_vga_controller;
    // Khai báo biến mô phỏng
    reg clk_100MHz;
    reg reset;
    wire video_on;
    wire hsync;
    wire vsync;
    wire p_tick;
    wire refresh_tick;
    wire [9:0] x;
    wire [9:0] y;

    // Khởi tạo module cần kiểm tra
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

    // Tạo xung nhịp 100MHz
    initial begin
        clk_100MHz = 0;
        forever #5 clk_100MHz = ~clk_100MHz; // Chu kỳ 10 ns tương đương với tần số 100MHz
    end

    // Quy trình kiểm thử
    initial begin
        // Khởi tạo reset và các tín hiệu ban đầu
        reset = 1;
        #20 reset = 0; // Bỏ reset sau 20 ns

        // Kiểm thử 1: Quan sát tín hiệu hsync và vsync
        #100000; // Chờ để tín hiệu VGA ổn định
        $display("Initial VGA Signals: hsync = %b, vsync = %b, video_on = %b, x = %d, y = %d", hsync, vsync, video_on, x, y);

        // Kiểm thử 2: Kiểm tra tín hiệu video_on trong phạm vi màn hình hiển thị
        #1000000;
        if (video_on)
            $display("Video ON: x = %d, y = %d", x, y);
        else
            $display("Video OFF: x = %d, y = %d", x, y);

        // Kiểm thử 3: Kiểm tra tín hiệu refresh_tick
        #1000000;
        $display("Refresh Tick: refresh_tick = %b", refresh_tick);

        // Kiểm thử 4: Đặt lại reset và kiểm tra các tín hiệu VGA
        reset = 1;
        #20 reset = 0;
        #100000; // Chờ để tín hiệu VGA khởi tạo lại
        $display("After Reset: hsync = %b, vsync = %b, video_on = %b, x = %d, y = %d", hsync, vsync, video_on, x, y);

        // Kết thúc mô phỏng
        $stop;
    end
endmodule
