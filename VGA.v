`timescale 1ns / 1ps

module top(
    input clk_100MHz,       // from Basys 3
    input reset,            // btnC on Basys 3
    input BtnU, BtnL, BtnD, BtnR,  
    output hsync,           // to VGA connector
    output vsync,           // to VGA connector
    output [11:0] rgb       // to DAC, 3 RGB bits to VGA connector
    );
    parameter X_DELTA_INIT = 10'd2, Y_DELTA_INIT = 10'd2;
    
    wire w_video_on, w_p_tick, w_refresh_tick;
    wire [9:0] w_x, w_y;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;
    wire status;
    reg [659:0] position;
    wire [19:0] sq_next;
    wire [639:0] position_next;
    
    vga_controller vc(.clk_100MHz(clk_100MHz), .reset(reset), .video_on(w_video_on), 
                      .hsync(hsync), .vsync(vsync), 
                      .p_tick(w_p_tick), .refresh_tick(w_refresh_tick),
                      .x(w_x), .y(w_y));
    square_controller sc(.clk(clk_100MHz), .reset(reset), 
                         .btnU(BtnU), .btnL(BtnL), .btnD(BtnD), .btnR(BtnR),
                         .refresh_tick(w_refresh_tick), .position(position[659:640]), 
                         .position_next(sq_next));
    random_square rs(.clk(clk_100MHz), .reset(reset), .refresh_tick(w_refresh_tick),
                     /* .number_square(num_sq),*/ .position(position[639:0]), 
                     .position_next(position_next));
//    game_status gs(.clk(clk_100MHz), .reset(reset),.p_tick(w_p_tick),
//                   .status(status));
    pixel_generation pg(.clk(clk_100MHz), .reset(reset), 
                        .x(w_x), .y(w_y), /* .status(status), */ 
                        .video_on(w_video_on), .position(position),
                        .rgb(rgb_next));
    
    
//    genvar i;
//    generate
//        for (i = 0; i < 16; i = i + 1) begin : init_position
//            always @(posedge clk_100MHz or posedge reset) begin
//                if (reset) begin
//                    position[i * 40 + 39: i * 40] <= { Y_DELTA_INIT, X_DELTA_INIT, 10'd0, i * 40};
//                end
//            end
//        end
//    endgenerate
    integer i;
    always @(posedge clk_100MHz) begin
        if(reset)
            position[659:650] <= 10'd220;  
            position[649:640] <= 10'd300;
            
            
            for (i = 0; i < 16; i = i + 1) begin
                position[i * 40 + 39: i * 40] <= { Y_DELTA_INIT, X_DELTA_INIT, 10'd0, i * 40 };
            end
        if(w_p_tick)
            rgb_reg <= rgb_next;
        position[659:640] <= sq_next;
        position[639:0] <= position_next;
    end 
            
    assign rgb = rgb_reg;
    
endmodule