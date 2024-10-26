`timescale 1ns / 1ps

module pixel_generation(
    input clk,                              // 100MHz from Basys 3
    input reset,                            // btnC
    input video_on,                         // from VGA controller
    input [9:0] x, y,                       // current pixel position from VGA controller
    input [659:0] position,                 // positions and sizes of squares
    output reg [11:0] rgb                   // output RGB signal
    );

    parameter SQ_RGB = 12'h0FF;             // color for squares (yellow)
    parameter BG_RGB = 12'hF00;             // background color (blue)
    parameter SQUARE_SIZE = 10;             // width of square sides in pixels
    parameter NUM_SQUARES = 16;             // number of squares

    // Registers to hold square boundaries and sq_on status
    reg [9:0] sq_x_l [0:NUM_SQUARES-1];     // left boundary for each square
    reg [9:0] sq_x_r [0:NUM_SQUARES-1];     // right boundary for each square
    reg [9:0] sq_y_t [0:NUM_SQUARES-1];     // top boundary for each square
    reg [9:0] sq_y_b [0:NUM_SQUARES-1];     // bottom boundary for each square
    reg [NUM_SQUARES-1:0] sq_on;            // array to indicate if each square is on

    // Extract square positions and determine boundaries
    genvar i;
    generate
        for (i = 0; i < NUM_SQUARES; i = i + 1) begin : square_bounds
            always @(posedge clk) begin
                sq_x_l[i] <= position[i * 40 + 9 : i * 40]; 
                sq_y_t[i] <= position[i * 40 + 19 : i * 40 + 10];     
                sq_x_r[i] <= position[i * 40 + 9 : i * 40] + SQUARE_SIZE - 1;                  
                sq_y_b[i] <= position[i * 40 + 19 : i * 40 + 10] + SQUARE_SIZE - 1;            

                sq_on[i] <= (sq_x_l[i] <= x) && (x <= sq_x_r[i]) &&
                           (sq_y_t[i] <= y) && (y <= sq_y_b[i]);
            end
           
        end
    endgenerate

    // RGB control: if any square is "on", display square color; otherwise display background
    always @* begin
        if (~video_on)
            rgb = 12'h000;  // black when video is off
        else if (|sq_on)    // if any bit in sq_on is 1
            rgb = SQ_RGB;   // yellow square color
        else
            rgb = BG_RGB;   // blue background
    end
    
endmodule
