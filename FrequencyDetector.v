module ClockCounter(clk, count, reset);
	input clk, reset;
	output [25:0] count;
	reg [25:0] count_reg = 0;
	assign count = count_reg;
	
	always @ (posedge clk)
	begin
		if (reset == 1 & count < 26'b10111110101111000010000000) begin
			count_reg <= count_reg + 1; end
		else begin
			count_reg <= 0; end
	end
endmodule
	

module FrequencyDetector(clk, count, reset);
	input clk, reset;
	output [25:0] count;
	ClockCounter(clk, count, reset);

endmodule
