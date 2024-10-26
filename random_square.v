`timescale 1ns / 1ps

module random_square(
    input clk,    
    input reset,     
    input refresh_tick, 
//    input num_square,
    input [639:0] position,
    output reg [639:0] position_next
    );
    
    parameter X_MAX = 639;                  // right border of display area
    parameter Y_MAX = 479;                  // bottom border of display area
    parameter SQUARE_SIZE = 10;             // width of square sides in pixels
    parameter SQUARE_VELOCITY_POS = 2;
    parameter SQUARE_VELOCITY_NEG = -2;
    
    reg [9:0] sq_x, sq_y;           
    reg [9:0] sq_x_next, sq_y_next;       
    
    reg [9:0] x_delta, y_delta;     
    reg [9:0] x_delta_next, y_delta_next;   // buffer regs   
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : init_position
            always @(posedge clk) begin
                { y_delta, x_delta, sq_y, sq_x} = position[i * 40 + 39: i * 40];
                if(refresh_tick) begin
                    sq_x_next = sq_x + x_delta;
                    sq_y_next = sq_y + y_delta;
                end else begin
                    sq_x_next = sq_x;
                    sq_y_next = sq_y;
                end
                x_delta_next = x_delta;
                y_delta_next = y_delta;
                if(sq_x_next < 1)                              
                    x_delta_next = SQUARE_VELOCITY_POS;     
                else if(sq_x_next + SQUARE_SIZE > X_MAX)                     
                    x_delta_next = SQUARE_VELOCITY_NEG;     
                if(sq_y_next < 1)                         
                    y_delta_next = SQUARE_VELOCITY_POS;    
                else if(sq_y_next + SQUARE_SIZE > Y_MAX)                     
                    y_delta_next = SQUARE_VELOCITY_NEG; 
                    
                position_next[i * 40 + 39: i * 40] <= {y_delta_next, x_delta_next, sq_y_next, sq_x_next};
            end
        end
    endgenerate
    
endmodule