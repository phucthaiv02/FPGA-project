`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2024 09:01:55 AM
// Design Name: 
// Module Name: 7_segment_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module score_display(
    input clk_1Hz,
    input clk_100MHz, 
    input reset, 
    input status,
    output reg [3:0] Anode_Activate, 
    output reg [6:0] LED_out
    );
    reg [26:0] one_second_counter; 
    wire one_second_enable;
    reg [15:0] displayed_number; 
    reg [3:0] LED_BCD;
    reg [19:0] refresh_counter; 
    wire [1:0] LED_activating_counter; 
                 
    always @(posedge clk_1Hz or posedge reset)
    begin
        if(reset==1)
            displayed_number <= 0;
        else if(status)
            displayed_number <= displayed_number + 1;
        else
            displayed_number <= displayed_number;
    end
    always @(posedge clk_100MHz or posedge reset)
    begin 
        if(reset==1)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end 
    assign LED_activating_counter = refresh_counter[19:18];

    always @(*)
    begin
        case(LED_activating_counter)
        2'b00: begin
            Anode_Activate = 4'b0111; 
            LED_BCD = displayed_number/1000;
              end
        2'b01: begin
            Anode_Activate = 4'b1011; 
            LED_BCD = (displayed_number % 1000)/100;
              end
        2'b10: begin
            Anode_Activate = 4'b1101; 
            LED_BCD = ((displayed_number % 1000)%100)/10;
                end
        2'b11: begin
            Anode_Activate = 4'b1110; 
            LED_BCD = ((displayed_number % 1000)%100)%10;
               end
        endcase
    end
    
    always @(*)
    begin
        case(LED_BCD)
        4'b0000: LED_out = 7'b0000001; // "0"     
        4'b0001: LED_out = 7'b1001111; // "1" 
        4'b0010: LED_out = 7'b0010010; // "2" 
        4'b0011: LED_out = 7'b0000110; // "3" 
        4'b0100: LED_out = 7'b1001100; // "4" 
        4'b0101: LED_out = 7'b0100100; // "5" 
        4'b0110: LED_out = 7'b0100000; // "6" 
        4'b0111: LED_out = 7'b0001111; // "7" 
        4'b1000: LED_out = 7'b0000000; // "8"     
        4'b1001: LED_out = 7'b0000100; // "9" 
        default: LED_out = 7'b0000001; // "0"
        endcase
    end
 endmodule
 