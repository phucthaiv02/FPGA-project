`timescale 1ns / 1ps

module pixel_generation(
    input clk,                              // 100MHz from Basys 3
    input reset,                            // btnC
    input video_on,        
    input [9:0] x, y,                       // current pixel position from VGA controller
    input [659:0] position,                 // positions and sizes of squares
    output reg [11:0] rgb                   // output RGB signal
    );

    parameter SQ_RGB = 12'h00F;  
    parameter MAIN_RGB = 12'h0FF;            
    parameter BG_RGB = 12'hF00;             // background color (blue)
    parameter SQUARE_SIZE = 30;             // width of square sides in pixels

    wire main_sq_on;
    reg[0:15] sq_on;          // array to indicate if each square is on
    
    
    assign main_sq_on = (position[649:640] <= x) && (x <= position[649:640] + SQUARE_SIZE - 1) &&
                        (position[659:650] <= y) && (y <= position[659:650] + SQUARE_SIZE - 1);
    // Extract square positions and determine boundaries
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : square_bounds
            reg [9:0] sq_x_l, sq_x_r, sq_y_t, sq_y_b;
            
            always @(posedge clk) begin
                begin
                    sq_x_l <= position[i * 40 + 9 : i * 40]; 
                    sq_y_t <= position[i * 40 + 19 : i * 40 + 10];     
                    sq_x_r <= position[i * 40 + 9 : i * 40] + SQUARE_SIZE - 1;                  
                    sq_y_b <= position[i * 40 + 19 : i * 40 + 10] + SQUARE_SIZE - 1;            
    
    //                sq_on[i] <= (position[i * 40 + 9 : i * 40] <= x) && 
    //                            (x <= position[i * 40 + 9 : i * 40] + SQUARE_SIZE - 1) &&
    //                            (position[i * 40 + 19 : i * 40 + 10] <= y) && 
    //                            (y <= position[i * 40 + 19 : i * 40 + 10] + SQUARE_SIZE - 1);
                    sq_on[i] = (sq_x_l <= x) && (x <= sq_x_r) &&
                               (sq_y_t <= y) && (y <= sq_y_b);
                end
            end
        end
    endgenerate
    // RGB control: if any square is "on", display square color; otherwise display background
    always @* begin
        if (~video_on)
            rgb = 12'h000;  // black when video is off
        else if (sq_on)    // if any bit in sq_on is 1
            rgb = SQ_RGB;   // yellow square color
        else if (main_sq_on)
            rgb = MAIN_RGB;   
        else
            rgb = BG_RGB;
    end
    
endmodule
