`timescale 1ns / 1ps

module score_display_tb;

    reg clk_1Hz;
    reg clk_100MHz;
    reg reset;
    reg status;
    wire [3:0] Anode_Activate;
    wire [6:0] LED_out;

    score_display uut (
        .clk_1Hz(clk_1Hz),
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .status(status),
        .Anode_Activate(Anode_Activate),
        .LED_out(LED_out)
    );

    initial begin
        clk_1Hz = 0;
        forever #500000000 clk_1Hz = ~clk_1Hz; // Đảo trạng thái mỗi 500 triệu ns (0.5 giây)
    end

    initial begin
        clk_100MHz = 0;
        forever #5 clk_100MHz = ~clk_100MHz; // Đảo trạng thái mỗi 5ns (tương ứng 100MHz)
    end

    initial begin
        reset = 1;
        status = 0;
        #100;
        reset = 0;
        status = 1; 

        #2000000000; 

        $stop;
    end

    initial begin
        $monitor("Time=%0dns | reset=%b | status=%b | displayed_number=%d | Anode_Activate=%b | LED_out=%b",
                  $time, reset, status, uut.displayed_number, Anode_Activate, LED_out);
    end

endmodule
