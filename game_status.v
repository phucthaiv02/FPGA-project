`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2024 02:33:23 PM
// Design Name: 
// Module Name: game_status
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


module game_status(
    input clk,
    input reset,
    input refresh_tick,
    input[659:0] position,
    output reg status
    );
    parameter SQUARE_SIZE = 30; 
    wire [9:0] main_sq_x_l, main_sq_x_r, main_sq_y_t, main_sq_y_b;
    reg[15:0] w_status;
    assign main_sq_x_l = position[649:640];
    assign main_sq_x_r = position[649:640] + SQUARE_SIZE - 1;
    assign main_sq_y_t = position[659:650];
    assign main_sq_y_b = position[659:650] + SQUARE_SIZE - 1;
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : square_bounds
            reg [9:0] sq_x_l, sq_x_r, sq_y_t, sq_y_b;
            reg l, r, t, b;
            always @(posedge refresh_tick) begin
                    begin
                        sq_x_l <= position[i * 40 + 9 : i * 40]; 
                        sq_y_t <= position[i * 40 + 19 : i * 40 + 10];     
                        sq_x_r <= position[i * 40 + 9 : i * 40] + SQUARE_SIZE - 1;                  
                        sq_y_b <= position[i * 40 + 19 : i * 40 + 10] + SQUARE_SIZE - 1;            
        
                        l = (sq_x_l < main_sq_x_l) && (main_sq_x_l < sq_x_r);
                        r = (sq_x_l < main_sq_x_r) && (main_sq_x_r < sq_x_r);
                        t = (sq_y_t < main_sq_y_t) && (main_sq_y_t < sq_y_b);
                        b = (sq_y_t < main_sq_y_b) && (main_sq_y_b < sq_y_b);
                        
                        w_status[i] = ((l | r) && (t | b));
                    end
            end
        end
    endgenerate
    
    always @* begin
        if (w_status)
            status = 0;   
        else
            status = 1;
    end
endmodule
