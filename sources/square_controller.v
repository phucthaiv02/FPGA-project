`timescale 1ns / 1ps

module square_controller(
    input clk,    
    input reset,     
    input btnU, btnL, btnD, btnR, 
    input refresh_tick, 
    input status,
    input [19:0] position,
    output reg [19:0] position_next
    );

    parameter X_MAX = 640;          // right border of display area
    parameter Y_MAX = 480;          // bottom border of display area
    parameter SQUARE_SIZE = 30;     // width of square sides in pixels
    parameter CHANGES = 5;          // position change value when release buttons
    
    reg [9:0] sq_x_reg, sq_y_reg;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sq_x_reg <= 10'd300;
            sq_y_reg <= 10'd220;
        end
        else if (refresh_tick && status) begin
            sq_x_reg = position[9:0];
            sq_y_reg = position[19:10];
            
            if (btnL && (sq_x_reg > CHANGES))
                sq_x_reg <= sq_x_reg - CHANGES; // Move left
            else if (btnL && (sq_x_reg <= CHANGES))
                sq_x_reg <= 0;                  // Move exactly to the left edge
            
            if (btnR && (sq_x_reg < (X_MAX - SQUARE_SIZE - CHANGES)))
                sq_x_reg <= sq_x_reg + CHANGES; // Move right 
            else if (btnR && (sq_x_reg >= (X_MAX - SQUARE_SIZE - CHANGES)))
                sq_x_reg <= X_MAX - SQUARE_SIZE; // Move exactly to the right edge
            
            if (btnU && (sq_y_reg > CHANGES))
                sq_y_reg <= sq_y_reg - CHANGES; // Move up
            else if (btnU && (sq_y_reg <= CHANGES))
                sq_y_reg <= 0;                  // Move exactly to the top edge
            
            if (btnD && (sq_y_reg < (Y_MAX - SQUARE_SIZE - CHANGES)))
                sq_y_reg <= sq_y_reg + CHANGES; // Move down
            else if (btnD && (sq_y_reg >= (Y_MAX - SQUARE_SIZE - CHANGES)))
                sq_y_reg <= Y_MAX - SQUARE_SIZE; // Move exactly to the bottom edge
        end
    end

    always @(posedge clk) begin
            position_next <= {sq_y_reg, sq_x_reg};
    end
    
endmodule
