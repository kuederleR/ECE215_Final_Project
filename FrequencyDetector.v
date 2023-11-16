module FrequencyDetector(MAX10_CLK1_50, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input [0:0] MAX10_CLK1_50;
	input [1:0] KEY; // Keys for input and manual reset (0 for reset, 1 for input)
	output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; // Registers for 7-seg displays
	
	output reg [9:0] LEDR;
	
	input [9:0] SW;
	
	reg [9:0] output_frequency; // Register to store 3-digit output
	reg [9:0] output_pulse_width;
	reg [9:0] num_pulse_width;
	reg [9:0] num_period_width;
	reg [25:0] count_pos_pos;
	reg [25:0] count_pos_neg;	
	reg [25:0] count;
	
	reg[3:0] digit0, digit1, digit2, digit3, digit4, digit5;

	reg edgeFront, edgeBack, edgePos, edgeNeg;
		
	
	always @ (posedge MAX10_CLK1_50)
	begin
		count <= count + 1; // Clock count
		count_pos_pos <= count_pos_pos + 1;
		count_pos_neg <= count_pos_neg + 1;
		
		LEDR[0] <= 1;
		
		edgeFront <= KEY[1];
		edgeBack <= edgeFront;
		edgePos <= (~edgeFront) & edgeBack;
		edgeNeg <= edgeFront & (~edgeBack);
		
		if (count == 50000000) begin 
			count <= 0;
		end
		
		
		if (edgePos) begin
			count_pos_neg <= 0;
			num_period_width <= count_pos_pos;
			count_pos_pos <= 0;			
		end
			
		if (edgeNeg) begin
			num_pulse_width <= count_pos_neg;
		end
				
		output_frequency <= 1/((1/50000000)*(num_pulse_width*2)); // Frequency in Hz
		if (output_frequency >= 1000000) begin // If freq is in MHz range
			LEDR[8] <= 0;
			LEDR[9] <= 1; // LEDR9 makes units MHz
			output_frequency <= output_frequency / 1000000;
		end
		else if (output_frequency >= 1000) begin // If freq is in kHz range
			LEDR[8] <= 1; // LEDR8 makes units kHz
			LEDR[9] <= 0;
			output_frequency <= output_frequency / 1000;
		end 
		else begin // No LED means Hz
			LEDR[8] <= 0;
			LEDR[9] <= 0;
		end
		
		digit0 <= output_frequency / 100; // 100s place
		digit1 <= (output_frequency / 10) % 10; // 10s place
		digit2 <= (output_frequency) % 100; // 1s Place
		
	end
		
	always @ (output_frequency)
	begin
		case(digit2)
		// outputting a zero = 0111111 = 63
		0:	HEX0[6:0] = 7'b1000000;
		// outputting a one = 0000110 = 6
		1: HEX0[6:0] = 7'b1111001;
		// outputting a two = 1011011 = 91
		2:	HEX0[6:0] = 7'b0100100;
		// outputting a three = 1001111 = 79
		3:	HEX0[6:0] = 7'b0110000;
		// outputting a four = 1100110 = 102
		4:	HEX0[6:0] = 7'b0011001;
		// outputting a five = 1101101 = 109
		5:	HEX0[6:0] = 7'b0010010;
		// outputting a six = 1111101 = 125
		6:	HEX0[6:0] = 7'b0000010;
		// outputting a seven = 0000111 = 7
		7:	HEX0[6:0] = 7'b1111000;
		// outputting an eight = 1111111 = 127
		8:	HEX0[6:0] = 7'b0000000;
		// outputting a nine = 1100111 = 103
		9:	HEX0[6:0] = 7'b0011000;
		default:	HEX0[6:0] = 7'hxx;
	endcase
	
	case(digit1)
		// outputting a zero = 0111111 = 63
		0:	HEX1[6:0] = 7'b1000000;
		// outputting a one = 0000110 = 6
		1: HEX1[6:0] = 7'b1111001;
		// outputting a two = 1011011 = 91
		2:	HEX1[6:0] = 7'b0100100;
		// outputting a three = 1001111 = 79
		3:	HEX1[6:0] = 7'b0110000;
		// outputting a four = 1100110 = 102
		4:	HEX1[6:0] = 7'b0011001;
		// outputting a five = 1101101 = 109
		5:	HEX1[6:0] = 7'b0010010;
		// outputting a six = 1111101 = 125
		6:	HEX1[6:0] = 7'b0000010;
		// outputting a seven = 0000111 = 7
		7:	HEX1[6:0] = 7'b1111000;
		// outputting an eight = 1111111 = 127
		8:	HEX1[6:0] = 7'b0000000;
		// outputting a nine = 1100111 = 103
		9:	HEX1[6:0] = 7'b0011000;
		default:	HEX1[6:0] = 7'hxx;
	endcase
	case(digit0)
		// outputting a zero = 0111111 = 63
		0:	HEX2[6:0] = 7'b1000000;
		// outputting a one = 0000110 = 6
		1: HEX2[6:0] = 7'b1111001;
		// outputting a two = 1011011 = 91
		2:	HEX2[6:0] = 7'b0100100;
		// outputting a three = 1001111 = 79
		3:	HEX2[6:0] = 7'b0110000;
		// outputting a four = 1100110 = 102
		4:	HEX2[6:0] = 7'b0011001;
		// outputting a five = 1101101 = 109
		5:	HEX2[6:0] = 7'b0010010;
		// outputting a six = 1111101 = 125
		6:	HEX2[6:0] = 7'b0000010;
		// outputting a seven = 0000111 = 7
		7:	HEX2[6:0] = 7'b1111000;
		// outputting an eight = 1111111 = 127
		8:	HEX2[6:0] = 7'b0000000;
		// outputting a nine = 1100111 = 103
		9:	HEX2[6:0] = 7'b0011000;
		default:	HEX2[6:0] = 7'hxx;
	endcase
	end
		
	
	
endmodule
