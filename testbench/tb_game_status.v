`timescale 1ns / 1ps

module tb_game_status;
    // Khai báo biến mô ph�?ng
    reg clk;
    reg reset;
    reg refresh_tick;
    reg [659:0] position;
    wire status;
    wire [5:0] num_squares;

    // Khởi tạo module cần kiểm tra
    game_status uut (
        .clk(clk),
        .reset(reset),
        .refresh_tick(refresh_tick),
        .position(position),
        .status(status),
        .num_squares(num_squares)
    );

    // Tạo xung nhịp 100MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Chu kỳ 10 ns tương đương với tần số 100MHz
    end

    // Quy trình kiểm thử
    initial begin
        // Khởi tạo reset
        reset = 1;
        refresh_tick = 0;
        position = 0; // Khởi tạo vị trí
        #20 reset = 0; // B�? reset sau 20 ns

        // Kiểm thử 1: Kiểm tra trạng thái ban đầu
        #10;
        $display("Initial state: status = %b, num_squares = %d", status, num_squares);

        // Kiểm thử 2: Thay đổi vị trí của các ô vuông
        refresh_tick = 1;
        position[659:650] = 200;  // �?ặt t�?a độ ô chính
        position[649:640] = 150;
        position[39:0] = {10'd210, 10'd160}; // �?ặt t�?a độ của ô vuông khác
        #10 refresh_tick = 0;

        // Kiểm tra kết quả sau khi cập nhật vị trí
        #20;
        $display("After moving square: status = %b, num_squares = %d", status, num_squares);

        // Kiểm thử 3: Thêm nhi�?u ô vuông và kiểm tra đếm số lượng
        refresh_tick = 1;
        position[79:40] = {10'd250, 10'd180}; // Thêm ô vuông thứ 2
        position[119:80] = {10'd300, 10'd220}; // Thêm ô vuông thứ 3
        #10 refresh_tick = 0;

        #20;
        $display("After adding squares: status = %b, num_squares = %d", status, num_squares);

        // Kiểm thử 4: �?ặt lại reset để kiểm tra số lượng ô vuông và trạng thái
        reset = 1;
        #20 reset = 0;

        #20;
        $display("After reset: status = %b, num_squares = %d", status, num_squares);

        // Kết thúc mô ph�?ng
        $stop;
    end
endmodule
