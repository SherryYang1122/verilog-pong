`timescale 1ns / 1ps
module pong_graph(
        input wire clk,
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


endmodule
