`timescale 1ns / 1ps
module debounce(
		input wire clk,
		input wire button,
		output reg pbreg
	);

	reg [2:0] count;
	wire clk_1ms;

	timer_1ms m0(clk, clk_1ms);

	always @(posedge clk_1ms)
	begin
		if(button == 0)
		begin
			pbreg = 0;
			count = 0;
		end
		else
		begin
			if(count < 7)
			begin
				count = count + 1;
				pbreg = 0;
			end
			else
			begin
				count = 7;
				pbreg = 1;
			end
		end
	end

endmodule
