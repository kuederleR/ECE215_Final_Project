//module ClockCounter(clk, count, reset);
//	input clk, reset;
//		output [3:0] count;
//		reg [3:0] count_reg;
//		assign count = count_reg;
//		always @ (posedge clk)
//			if (reset == 0 || count_reg == 4'b1010) begin
//				count_reg <= 4'b0000; end
//			else begin
//				count_reg <= count_reg + 1; end
//endmodule
//
//module InputPulseCounter(dev_clk, in_clk, count2);
//	input dev_clk, in_clk;
//	output [3:0] count2;
//	reg [3:0] count2_reg;
//	assign count2 = count2_reg;
//	wire [3:0] count_connect;
//	ClockCounter(dev_clk, count_connect, in_clk);
//	always @ (negedge in_clk) begin
//		count2_reg <= count_connect;
//end
//	
//	
//		
//		
//endmodule
//
//module FrequencyDetector(device_clock, input_clock, cycle_count, frequency);
//	input device_clock, input_clock;
//	output [3:0] cycle_count;
//	output [3:0] frequency;
//	reg [3:0] frequency_reg;
//	InputPulseCounter(device_clock, input_clock, cycle_count);
//	assign frequency = frequency_reg;
//	always @ (posedge device_clock) begin
//		frequency_reg <= (10/(2 * cycle_count));
//	end
//	
//endmodule

module FrequencyDetector(MAX10_CLK1_50, INPUT_CLK, HEX0, HEX1, HEX2, KEY);
	input [0:0] MAX10_CLK1_50, INPUT_CLK;
	input [1:0] KEY; // Keys for input and manual reset (0 for reset, 1 for input)
	output reg [6:0] HEX0, HEX1, HEX2; // Registers for 7-seg displays
	
	reg [9:0] OUTPUT_NUM; // Register to store 3-digit output
		
	reg [25:0] count;
	reg [25:0] pulse_width;
	reg [25:0] period;
	
	always @ (posedge MAX10_CLK1_50)
	begin
		count <= count + 1; // Clock count
		
		if (INPUT_CLK > 0) begin
			// start count
		
		
	
	
endmodule
