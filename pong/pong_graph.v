`timescale 1ns / 1ps
module pong_graph(
        input wire clk, reset,
        input wire [1:0] btn1,
        input wire [1:0] btn2,
        input wire [9:0] pix_x, pix_y,
        input wire gra_still,
        output wire graph_on,
        output reg hit, miss,
        output reg [2:0] graph_rgb
    );
    
    localparam MAX_X = 640;
    localparam MAX_Y = 480;
	
	// all about ball
    localparam BALL_SIZE = 8;
    wire [9:0] ball_x_l, ball_x_r;
    wire [9:0] ball_y_t, ball_y_b;
    reg [9:0] ball_x_reg, ball_y_reg;
    wire [9:0] ball_x_next, ball_y_next;
    reg [9:0] x_delta_reg, x_delta_next;
    reg [9:0] y_delta_reg, y_delta_next;
	
	// all about the output rgb
	wire barr_on, barl_on, sq_ball_on, rd_ball_on;
	wire [2:0] wall_rgb, barr_rgb, barl_rgb, ball_rgb;
	
	// colors
	assign barr_rgb = 3'b101;	// purple
	assign barl_rgb = 3'b010;	// green
	assign ball_rgb = 3'b100;	// red
	
	always @(posedge clk, posedge reset)
    begin
		if (reset)
        begin
            barr_y_reg <= 0;
            barl_y_reg <= 0;
            ball_x_reg <= 0;
            ball_y_reg <= 0;
            x_delta_reg <= 10'h004;
            y_delta_reg <= 10'h004;
        end   
		else
        begin
            barr_y_reg <= barr_y_next;
            barl_y_reg <= barl_y_next;
            ball_x_reg <= ball_x_next;
            ball_y_reg <= ball_y_next;
            x_delta_reg <= x_delta_next;
            y_delta_reg <= y_delta_next;
        end   
    end

	always @* 
	begin
        if (barr_on)
			graph_rgb = barr_rgb;
        else if (barl_on)
			graph_rgb = barl_rgb;
		else if (rd_ball_on)
			graph_rgb = ball_rgb;
		else
			graph_rgb = 3'b000;
	end

	assign graph_on =  barr_on | barl_on | rd_ball_on;
	
endmodule
