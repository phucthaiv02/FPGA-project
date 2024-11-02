`timescale 1ns / 1ps

module tb_7_segment_control;
    // Khai báo các biến để mô phỏng
    reg clk_1Hz;
    reg clk_100MHz;
    reg reset;
    reg status;
    wire [3:0] Anode_Activate;
    wire [6:0] LED_out;

    // Khởi tạo module để kiểm tra
    score_display uut (
        .clk_1Hz(clk_1Hz),
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .status(status),
        .Anode_Activate(Anode_Activate),
        .LED_out(LED_out)
    );

    // Tạo xung nhịp 1Hz và 100MHz
    initial begin
        clk_1Hz = 0;
        forever #500000000 clk_1Hz = ~clk_1Hz; // Chu kỳ xung nhịp 1Hz (1 giây)
    end

    initial begin
        clk_100MHz = 0;
        forever #5 clk_100MHz = ~clk_100MHz; // Chu kỳ xung nhịp 100MHz (10 ns)
    end

    // Quy trình kiểm thử
    initial begin
        // Khởi tạo
        reset = 1;
        status = 0;
        #20 reset = 0; // Bỏ reset sau 20 ns

        // Kiểm thử 1: Bắt đầu với trạng thái `status` = 0, kiểm tra hiển thị ban đầu
        #100;
        $display("Initial Display: Anode_Activate = %b, LED_out = %b", Anode_Activate, LED_out);

        // Kiểm thử 2: Bật `status` để bắt đầu đếm
        status = 1;
        #2000000000; // Chờ 2 giây
        $display("After 2s: Anode_Activate = %b, LED_out = %b", Anode_Activate, LED_out);

        // Kiểm thử 3: Đặt lại reset trong lúc đếm
        reset = 1;
        #20 reset = 0;
        #500000000; // Chờ 0.5 giây
        $display("After Reset: Anode_Activate = %b, LED_out = %b", Anode_Activate, LED_out);

        // Kiểm thử 4: Tiếp tục đếm sau khi reset
        status = 1;
        #2000000000; // Chờ 2 giây
        $display("After 2s Post-Reset: Anode_Activate = %b, LED_out = %b", Anode_Activate, LED_out);

        // Kết thúc mô phỏng
        $stop;
    end
endmodule
