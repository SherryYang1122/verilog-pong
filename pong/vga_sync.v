`timescale 1ns / 1ps
module vga_sync(
		input wire clk, reset,
		output wire hsync, vsync,
		output wire video_on,
		output wire p_tick,
		output wire [9:0] pixel_x, pixel_y
	);
	localparam
		HD = 640,
		HB = 16,
		HF = 48,
		VD = 480,
		VB = 33,
		VF = 10;
	reg [9:0] v_count, h_count;
	reg  hsy, vsy, point;
	always @(posedge clk, posedge reset)
	begin
		if(reset)
		begin
			v_count <= 0;
			h_count <= 0;
			hsy <= 0;
			vsy <= 0;
			point <= 1'b0;
		end
		else
		begin
			hsy <= 1;
			vsy <= 1;
			point <= ~point;
			if(h_count < HD + HB + HF - 1)
				h_count <= h_count + 1;
			else
			begin
				h_count <= 0;
				if(v_count < VD + VB + VF - 1)
					v_count <= v_count + 1;
				else
					v_count <= 0;
			end
		end
	end
	assign video_on = (v_count < VD && h_count < HD);
	assign p_tick = point;
	assign hsync = hsy & (h_count >= HD + HB && h_count <= HD + HB + HF - 1);
	assign vsync = vsy & (v_count >= VD + VB && h_count <= VD + VB + VF - 1);
	assign pixel_x = v_count;
	assign pixel_y = h_count;
endmodule
