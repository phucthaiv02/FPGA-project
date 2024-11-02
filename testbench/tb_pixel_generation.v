`timescale 1ns / 1ps

module tb_pixel_generation;
    // Khai báo biến mô phỏng
    reg clk;
    reg reset;
    reg video_on;
    reg [9:0] x, y;
    reg [659:0] position;
    wire [11:0] rgb;

    // Khởi tạo module cần kiểm tra
    pixel_generation uut (
        .clk(clk),
        .reset(reset),
        .video_on(video_on),
        .x(x),
        .y(y),
        .position(position),
        .rgb(rgb)
    );

    // Tạo xung nhịp 100MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Chu kỳ 10 ns tương đương với tần số 100MHz
    end

    // Quy trình kiểm thử
    initial begin
        // Khởi tạo reset và video_on
        reset = 1;
        video_on = 0;
        x = 0;
        y = 0;
        position = 0;
        #20 reset = 0; // Bỏ reset sau 20 ns

        // Kiểm thử 1: Video off - kiểm tra RGB = 0
        #10;
        $display("Video OFF: RGB = %h", rgb);

        // Kiểm thử 2: Video on - kiểm tra màu nền khi không có ô vuông
        video_on = 1;
        x = 100;
        y = 100;
        #10;
        $display("Background color (No squares): RGB = %h", rgb);

        // Kiểm thử 3: Video on - Kiểm tra màu của ô vuông chính
        position[659:650] = 100;  // Đặt vị trí y của ô chính
        position[649:640] = 100;  // Đặt vị trí x của ô chính
        #10;
        $display("Main square color: RGB = %h", rgb);

        // Kiểm thử 4: Video on - Kiểm tra màu của một ô vuông khác
        position[39:0] = {10'd150, 10'd150}; // Đặt vị trí cho một ô vuông khác
        x = 150;
        y = 150;
        #10;
        $display("Additional square color: RGB = %h", rgb);

        // Kiểm thử 5: Vị trí không có ô vuông nào, kiểm tra màu nền
        x = 300;
        y = 300;
        #10;
        $display("Background color (Outside any square): RGB = %h", rgb);

        // Kết thúc mô phỏng
        $stop;
    end
endmodule
