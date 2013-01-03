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
	
	always @(posedge clk)
    begin
		barr_y_reg <= barr_y_next;
        barl_y_reg <= barl_y_next;
        ball_x_reg <= ball_x_next;
        ball_y_reg <= ball_y_next;
        x_delta_reg <= x_delta_next;
        y_delta_reg <= y_delta_next;
    end
	
	always @(posedge clk)
	begin
	
	end

endmodule
