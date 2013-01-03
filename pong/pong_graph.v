`timescale 1ns / 1ps
module pong_graph(
        input wire clk, reset,
        input wire [1:0] btn1,
        input wire [1:0] btn2,
        input wire [9:0] pix_x, pix_y,
        input wire graph_still,
        output wire graph_on,
        output reg hit, miss,
        output reg [2:0] graph_rgb
    );
    
    localparam MAX_X = 640;
    localparam MAX_Y = 480;
    localparam BALL_SIZE = 8;
    localparam BAR_SIZE = 72;
    localparam BAR_V = 4;
    
    // all about ball
    reg [9:0] ball_x, ball_y;
    wire [9:0] ball_x_next, ball_y_next;
    wire [9:0] ball_right, ball_left, ball_top, ball_bottom;
    reg [9:0] x_delta, x_delta_next;
    reg [9:0] y_delta, y_delta_next;
    
    wire [2:0] ball_row, ball_col;
    reg [7:0] ball_data;
    
    // all about the output rgb
    wire bar_right_on, bar_left_on, ball_on;
    wire [2:0] wall_rgb, bar_rgb, ball_rgb;
    
    // colors
    assign bar_rgb = 3'b101;    // purple
    assign ball_rgb = 3'b100;    // red
    
    // bar right & left
    reg [9:0] bar_right, bar_right_next;
    reg [9:0] bar_left, bar_left_next;
    wire [9:0] bar_right_top, bar_right_bottom;
    wire [9:0] bar_left_top, bar_left_bottom;

    // refr_tick: 1-clock tick asserted at start of v-sync
    //       i.e., when the screen is refreshed (60 Hz)
    assign refr_tick = (pix_y == 481) && (pix_x == 0);

    always @*
    case (ball_row)
        3'h0: ball_data = 8'b00111100;     //   ****
        3'h1: ball_data = 8'b01111110;     //  ******
        3'h2: ball_data = 8'b11111111;     // ********
        3'h3: ball_data = 8'b11111111;     // ********
        3'h4: ball_data = 8'b11111111;     // ********
        3'h5: ball_data = 8'b11111111;     // ********
        3'h6: ball_data = 8'b01111110;     //  ******
        3'h7: ball_data = 8'b00111100;     //   ****
    endcase
    
    always @(posedge clk, posedge reset)
    begin
        if (reset)
        begin
            bar_right_y <= 0;
            bar_left_y <= 0;
            ball_x <= 0;
            ball_y <= 0;
            x_delta <= 10'h004;
            y_delta <= 10'h004;
        end   
        else
        begin
            bar_right_y <= bar_right_y_next;
            bar_left_y <= bar_left_y_next;
            ball_x <= ball_x_next;
            ball_y <= ball_y_next;
            x_delta <= x_delta_next;
            y_delta <= y_delta_next;
        end   
    end
    
    always @*
    begin
        bar_right_next = bar_right;
        if (graph_still)
            bar_right_next = MAX_Y / 2;
        else if (refr_tick)
            if (btn1[1] & (bar_right_bottom < (MAX_Y - 1 - BAR_V)))
                bar_right_next = bar_right + BAR_V;
            else if (btn1[0] & (bar_right_top > BAR_V)) 
                bar_right_next = bar_right - BAR_V;
    end
    
    always @*
    begin
        bar_left_next = bar_left;
        if (graph_still)
            bar_left_next = MAX_Y / 2;
        else if (refr_tick)
            if (btn2[1] & (bar_left_bottom < (MAX_Y - 1 - BAR_V)))
                bar_left_next = bar_left + BAR_V;
            else if (btn2[0] & (bar_left_top > BAR_V)) 
                bar_left_next = bar_left - BAR_V;
    end  

    // positions
    assign ball_right = ball_x + 4;
    assign ball_left = ball_x + 3;
    assign ball_top = ball_y + 3;
    assign ball_bottom = ball_y + 4;
    assign ball_x_next = (graph_still) ? MAX_X / 2 :
                         (refr_tick) ? ball_x + x_delta : ball_x;
    assign ball_y_next = (graph_still) ? MAX_Y / 2 :
                         (refr_tick) ? ball_y + y_delta : ball_y;

    assign ball_row = pix_y[2:0] - ball_top[2:0];
    assign ball_col = pix_x[2:0] - ball_left[2:0];
    assign ball_bit = ball_data[ball_col];
    assign ball_on = (ball_left <= pix_x) && (pix_x <= ball_right)
                     && (ball_top <= pix_y) && (pix_y <= ball_bottom)
                     && ball_bit;

    assign bar_right_top = bar_right - BAR_SIZE / 2;
    assign bar_right_bottom = bar_right + BAR_SIZE / 2;
    assign bar_left_top = bar_left - BAR_SIZE / 2;
    assign bar_left_bottom = bar_left + BAR_SIZE / 2;
                     
    always @*
    begin
        hit = 1'b0;
        miss = 1'b0;
        x_delta_next = x_delta;
        y_delta_next = y_delta;
        if (graph_still)
            begin
                x_delta_next = 2;
                y_delta_next = 2;
            end
        else if (ball_top <= 1)
            y_delta_next = -y_delta_next;
        else if (ball_bottom >= MAX_Y - 1)
            y_delta_next = -y_delta_next;
        else if ()    
        else if (ball_right >= MAX_X - 10 or ball_right <= 10)
            miss = 1'b1;                    // a miss
    end

    always @* 
    begin
        if (bar_on)
            graph_rgb = bar_rgb;
        else if (ball_on)
            graph_rgb = ball_rgb;
        else
            graph_rgb = 3'b000;
    end

    assign graph_on =  bar_on | ball_on;
    
endmodule
