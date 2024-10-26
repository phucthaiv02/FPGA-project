`timescale 1ns / 1ps

module square_controller(
    input clk,    
    input reset,     
    input btnU, btnL, btnD, btnR, 
    input refresh_tick, 
//    input [9:0] x,     // pixel count/position of pixel x, max 0-799
//    input [9:0] y, 
    input [19:0] position,
    output reg [19:0] position_next
    );

    parameter X_MAX = 640;          // right border of display area
    parameter Y_MAX = 480;          // bottom border of display area
    parameter SQUARE_SIZE = 10;     // width of square sides in pixels
    parameter CHANGES = 5;          // position change value when release buttons
    parameter SQUARE_ID = 0;        // ID của hình vuông cần cập nhật (0 - 16)
    
//    wire refresh_tick;
//    assign refresh_tick = ((y == 481) && (x == 0)) ? 1 : 0;
    // Thanh ghi để lưu tọa độ X và Y của hình vuông
    reg [9:0] sq_x_reg = 300, sq_y_reg = 220;
    reg [19:0] position_next;
    
    // Cập nhật vị trí của hình vuông khi có refresh_tick
    always @(posedge clk) begin
        if (refresh_tick) begin
            sq_x_reg = position[9:0];
            sq_y_reg = position[19:10];
            // Di chuyển trái 
            if (btnL && (sq_x_reg > CHANGES))
                sq_x_reg <= sq_x_reg - CHANGES; // Move left
            else if (btnL && (sq_x_reg <= CHANGES))
                sq_x_reg <= 0;                  // Move to left edge if too close
            
            // Di chuyển phải
            if (btnR && (sq_x_reg < (X_MAX - SQUARE_SIZE - CHANGES)))
                sq_x_reg <= sq_x_reg + CHANGES; // Move right normally
            else if (btnR && (sq_x_reg >= (X_MAX - SQUARE_SIZE - CHANGES)))
                sq_x_reg <= X_MAX - SQUARE_SIZE; // Move exactly to the right edge
            
            // Di chuyển lên
            if (btnU && (sq_y_reg > CHANGES))
                sq_y_reg <= sq_y_reg - CHANGES; // Move up
            else if (btnU && (sq_y_reg <= CHANGES))
                sq_y_reg <= 0;                  // Move to top edge if too close
            
            // Di chuyển xuống
            if (btnD && (sq_y_reg < (Y_MAX - SQUARE_SIZE - CHANGES)))
                sq_y_reg <= sq_y_reg + CHANGES; // Move down normally
            else if (btnD && (sq_y_reg >= (Y_MAX - SQUARE_SIZE - CHANGES)))
                sq_y_reg <= Y_MAX - SQUARE_SIZE; // Move exactly to the bottom edge
        end
    end

    always @(posedge clk) begin
            position_next <= {sq_y_reg, sq_x_reg};
    end
    
endmodule
