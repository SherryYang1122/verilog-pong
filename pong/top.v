`timescale 1ns / 1ps
module top(
		input wire clk,
		input wire [1:0] btn1,
		input wire [1:0] btn2,
		output wire hsync, vsync,
		output wire [2:0] rgb
	);
	 
	localparam  [1:0]
	newgame = 2'b00,
   play    = 2'b01,
   over    = 2'b10;
	
	vga_sync vsync_unit
      (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
       .video_on(video_on), .p_tick(pixel_tick),
       .pixel_x(pixel_x), .pixel_y(pixel_y));

   pong_graph graph_unit
      (.clk(clk), .reset(reset), .btn1(btn1), .btn2(btn2), .ai_switch(ai_switch),
       .pix_x(pixel_x), .pix_y(pixel_y),
       .gra_still(gra_still), .hit(hit), .miss(miss),
       .graph_on(graph_on), .graph_rgb(graph_rgb));

endmodule
