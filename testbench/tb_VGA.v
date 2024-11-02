`timescale 1ns / 1ps

module tb_VGA;
    // Khai báo biến mô ph�?ng
    reg clk_100MHz;
    reg reset;
    reg BtnU, BtnL, BtnD, BtnR;
    wire hsync, vsync;
    wire [11:0] rgb;
    wire [3:0] Anode_Activate;
    wire [6:0] LED_out;

    // Khởi tạo module cần kiểm tra
    top uut (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .BtnU(BtnU),
        .BtnL(BtnL),
        .BtnD(BtnD),
        .BtnR(BtnR),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb),
        .Anode_Activate(Anode_Activate),
        .LED_out(LED_out)
    );

    // Tạo xung nhịp 100MHz
    initial begin
        clk_100MHz = 0;
        forever #5 clk_100MHz = ~clk_100MHz; // Chu kỳ 10 ns tương đương với tần số 100MHz
    end

    // Quy trình kiểm thử
    initial begin
        // Khởi tạo reset và tín hiệu đầu vào
        reset = 1;
        BtnU = 0;
        BtnL = 0;
        BtnD = 0;
        BtnR = 0;
        #20 reset = 0; // B�? reset sau 20 ns

        // Kiểm thử 1: Kiểm tra tín hiệu hsync, vsync, rgb khi bắt đầu
        #100000; // Ch�? để tín hiệu VGA ổn định
        $display("Initial VGA Signals: hsync = %b, vsync = %b, rgb = %h", hsync, vsync, rgb);

        // Kiểm thử 2: Nhấn nút lên để di chuyển ô vuông
        BtnU = 1;
        #20 BtnU = 0;
        #100000; // Ch�? để vị trí ô vuông cập nhật
        $display("After BtnU Press: hsync = %b, vsync = %b, rgb = %h", hsync, vsync, rgb);

        // Kiểm thử 3: Nhấn nút xuống để di chuyển ô vuông
        BtnD = 1;
        #20 BtnD = 0;
        #100000; // Ch�? để vị trí ô vuông cập nhật
        $display("After BtnD Press: hsync = %b, vsync = %b, rgb = %h", hsync, vsync, rgb);

        // Kiểm thử 4: Kiểm tra tín hiệu hiển thị 7 đoạn
        #5000000; // Ch�? vài giây để giá trị trên 7 đoạn thay đổi
        $display("7 Segment Display: Anode_Activate = %b, LED_out = %b", Anode_Activate, LED_out);

        // Kiểm thử 5: �?ặt lại reset và kiểm tra tín hiệu VGA
        reset = 1;
        #20 reset = 0;
        #100000; // Ch�? để tín hiệu VGA khởi tạo lại
        $display("After Reset: hsync = %b, vsync = %b, rgb = %h", hsync, vsync, rgb);

        // Kết thúc mô ph�?ng
        $stop;
    end
endmodule
