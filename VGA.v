`timescale 1ns / 1ps

module top(
    input clk_100MHz,       // from Basys 3
    input reset,            // btnC on Basys 3
    input BtnU, BtnL, BtnD, BtnR,  
    output hsync,           // to VGA connector
    output vsync,           // to VGA connector
    output [11:0] rgb,      // to DAC, 3 RGB bits to VGA connector
    output [3:0] Anode_Activate, 
    output[6:0] LED_out
    );
    parameter X_DELTA_INIT = 10'd2, Y_DELTA_INIT = 10'd2;
    
    wire w_video_on, w_p_tick, w_refresh_tick, clk_1Hz;
    wire [9:0] w_x, w_y;
    
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;
    
    reg [5:0] num_sq;
    wire [5:0] num_sq_next;
    
    reg status;
    wire status_next;
    
    reg [15:0] score;
    wire [15:0] score_next;
    
    reg [659:0] position;
    wire [19:0] sq_next;
    wire [639:0] position_next;
    
    clock_generator cg(.clk(clk_100MHz), .reset(reset), .clk_1Hz(clk_1Hz));
    vga_controller vc(.clk_100MHz(clk_100MHz), .reset(reset), .video_on(w_video_on), 
                      .hsync(hsync), .vsync(vsync), 
                      .p_tick(w_p_tick), .refresh_tick(w_refresh_tick),
                      .x(w_x), .y(w_y));
    square_controller sc(.clk(clk_100MHz), .reset(reset), 
                         .btnU(BtnU), .btnL(BtnL), .btnD(BtnD), .btnR(BtnR), .status(status_next),
                         .refresh_tick(w_refresh_tick), .position(position[659:640]), 
                         .position_next(sq_next));
    random_square rs(.clk(clk_100MHz), .reset(reset), .refresh_tick(w_refresh_tick),
                     .status(status_next), .num_squares(num_sq_next), .position(position[639:0]), 
                     .position_next(position_next));
    game_status gs(.clk(clk_1Hz), .reset(reset),
                   .refresh_tick(w_refresh_tick), .position(position),
                   .status(status_next), .num_squares(num_sq_next));
    score_display(.clk_1Hz(clk_1Hz), .clk_100MHz(clk_100MHz), .reset(reset), .status(status_next),
                  .Anode_Activate(Anode_Activate), .LED_out(LED_out));
    pixel_generation pg(.clk(clk_100MHz), .reset(reset), 
                        .x(w_x), .y(w_y), /* .status(status), */ 
                        .video_on(w_video_on), .position(position),
                        .rgb(rgb_next));
    
    always @(posedge clk_100MHz or posedge reset) begin
        if(reset) begin
            status <= 1;
        end
        else if(w_p_tick) begin
            rgb_reg <= rgb_next;
            position[659:640] <= sq_next;
            position[639:0] <= position_next;
        end
    end 
            
    assign rgb = rgb_reg;
    
endmodule