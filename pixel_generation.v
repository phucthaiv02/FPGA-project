`timescale 1ns / 1ps

module pixel_generation(
    input clk,                              // 100MHz from Basys 3
    input reset,                            // btnC
    input video_on,                         // from VGA controller
    input [9:0] x, y,      
    input btnU, btnL, btnD, btnR,                 // from VGA controller
    output reg [11:0] rgb                   // to DAC, to VGA controller
    );
    
    parameter X_MAX = 639;                  // right border of display area
    parameter Y_MAX = 479;                  // bottom border of display area
    parameter SQ_RGB = 12'h0FF;             // red & green = yellow for square
    parameter BG_RGB = 12'hF00;             // blue background
    parameter SQUARE_SIZE = 40;             // width of square sides in pixels
    parameter CHANGES = 5;                  // position change value when release buttons
//    parameter SQUARE_VELOCITY_POS = 2;      // set position change value for positive direction
//    parameter SQUARE_VELOCITY_NEG = -2;     // set position change value for negative direction  
    
    // create a 60Hz refresh tick at the start of vsync 
    wire refresh_tick;
    assign refresh_tick = ((y == 481) && (x == 0)) ? 1 : 0;
    
    // square boundaries and position
    wire [9:0] sq_x_l, sq_x_r;              // square left and right boundary
    wire [9:0] sq_y_t, sq_y_b;              // square top and bottom boundary
    
    reg [9:0] sq_x_reg, sq_y_reg;           // regs to track left, top position
    wire [9:0] sq_x_next, sq_y_next;        // buffer wires
    
    reg [9:0] x_delta_reg, y_delta_reg;     // track square speed
    reg [9:0] x_delta_next, y_delta_next;   // buffer regs    
    
    // register control
    always @(posedge clk or posedge reset)
        if(reset) begin
            sq_x_reg <= 300;
            sq_y_reg <= 220;
//            x_delta_reg <= 10'h002;
//            y_delta_reg <= 10'h002;
        end
        else if(refresh_tick) begin
        // Update x position based on left and right button presses
        if (btnL && (sq_x_reg > CHANGES))
            sq_x_reg <= sq_x_reg - CHANGES; // Move left
        else if (btnL && (sq_x_reg <= CHANGES))
            sq_x_reg <= 0;                  // Move to left edge if too close
        
        if (btnR && (sq_x_reg < (X_MAX - SQUARE_SIZE - CHANGES)))
            sq_x_reg <= sq_x_reg + CHANGES; // Move right normally
        else if (btnR && (sq_x_reg >= (X_MAX - SQUARE_SIZE - CHANGES)))
            sq_x_reg <= X_MAX - SQUARE_SIZE; // Move exactly to the right edge
        
        // Update y position based on up and down button presses
        if (btnU && (sq_y_reg > CHANGES))
            sq_y_reg <= sq_y_reg - CHANGES; // Move up
        else if (btnU && (sq_y_reg <= CHANGES))
            sq_y_reg <= 0;                  // Move to top edge if too close
        
        if (btnD && (sq_y_reg < (Y_MAX - SQUARE_SIZE - CHANGES)))
            sq_y_reg <= sq_y_reg + CHANGES; // Move down normally
        else if (btnD && (sq_y_reg >= (Y_MAX - SQUARE_SIZE - CHANGES)))
            sq_y_reg <= Y_MAX - SQUARE_SIZE; // Move exactly to the bottom edge
    end
    // square boundaries
    assign sq_x_l = sq_x_reg;                   // left boundary
    assign sq_y_t = sq_y_reg;                   // top boundary
    assign sq_x_r = sq_x_l + SQUARE_SIZE - 1;   // right boundary
    assign sq_y_b = sq_y_t + SQUARE_SIZE - 1;   // bottom boundary
    
    // square status signal
    wire sq_on;
    assign sq_on = (sq_x_l <= x) && (x <= sq_x_r) &&
                   (sq_y_t <= y) && (y <= sq_y_b);
                   
    // RGB control
    always @*
        if(~video_on)
            rgb = 12'h000;          // black(no value) outside display area
        else
            if(sq_on)
                rgb = SQ_RGB;       // yellow square
            else
                rgb = BG_RGB;       // blue background
    
endmodule