`timescale 1ns / 1ps
module top(
        input wire clk,
        input wire [1:0] btn1,
        input wire [1:0] btn2,
        output wire hsync, vsync,
        output wire [2:0] rgb
    );

    localparam  [1:0]
    new     = 2'b00,
    play    = 2'b01,
    over    = 2'b10;

    reg [1:0] state, state_next;
    wire [9:0] pixel_x, pixel_y;
    wire video_on, pixel_tick, graph_on, hit, miss;
    wire [2:0] graph_rgb;
    reg [2:0] rgb_now, rgb_next;
    reg gra_still, timer_start;
	wire [1:0] btn1_out, btn2_out;
	
	initial begin
		state = 2'b00;
	end
	
	debounce p0(clk, btn1[0], btn1_out[0]);
	debounce p1(clk, btn1[1], btn1_out[1]);
	debounce p2(clk, btn2[0], btn2_out[0]);
	debounce p3(clk, btn2[1], btn2_out[1]);

    vga_sync vsync_unit
        (.clk(clk), .hsync(hsync), .vsync(vsync),
        .video_on(video_on), .p_tick(pixel_tick),
        .pixel_x(pixel_x), .pixel_y(pixel_y));

    pong_graph graph_unit
      (.clk(clk), .btn1(btn1_out), .btn2(btn2_out),
       .pix_x(pixel_x), .pix_y(pixel_y),
       .gra_still(gra_still), .hit(hit), .miss(miss),
       .graph_on(graph_on), .graph_rgb(graph_rgb));

    always @(posedge clk)
    begin
        state_reg <= state_next;
        if (pixel_tick)
            rgb_reg <= rgb_next;
    end

    always @*
    begin
        state_next = state;
        case (state)
            new:
                begin
                    if ((btn1 != 2'b00) || (btn2 != 2'b00))    // any button pressed the game start
                    begin
                        state_next = play;
                    end
                end
            play:
                begin
                    
                end
            over:
                begin
                    state_next = new;
                end
        endcase
    end

    always @*
    begin
        if (~video_on)
            rgb_next = "000"; // blank the edge/retrace
        else
            if (graph_on)  // display graph
                rgb_next = graph_rgb;
            else
                rgb_next = 3'b110; // yellow background
    end

    assign rgb = rgb_now;

endmodule
