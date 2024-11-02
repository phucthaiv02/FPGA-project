`timescale 1ns / 1ps

module tb_clock_generator;
    // Khai báo biến mô phỏng
    reg clk;
    reg reset;
    wire clk_1Hz;

    // Khởi tạo module cần kiểm tra
    clock_generator uut (
        .clk(clk),
        .reset(reset),
        .clk_1Hz(clk_1Hz)
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
        #20 reset = 0; // Bỏ reset sau 20 ns

        // Kiểm thử: Chờ khoảng 1 giây (1 tỷ ns) để kiểm tra xung nhịp 1Hz
        #1000000000;
        if (clk_1Hz)
            $display("clk_1Hz chuyển lên mức cao sau 1 giây");
        else
            $display("clk_1Hz không đúng mức cao sau 1 giây");

        #1000000000;
        if (~clk_1Hz)
            $display("clk_1Hz chuyển xuống mức thấp sau 2 giây");
        else
            $display("clk_1Hz không đúng mức thấp sau 2 giây");

        // Kết thúc mô phỏng
        $stop;
    end
endmodule
