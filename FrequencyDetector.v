module FrequencyDetector(MAX10_CLK1_50, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, SW, GPIO);
	input [0:0] MAX10_CLK1_50;
	input [1:0] KEY; // Keys for input and manual reset (0 for reset, 1 for input)
	output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; // Registers for 7-seg displays
	
	output reg [9:0] LEDR;
	
	input [9:0] SW;
	input [34:0] GPIO;
	
	reg [26:0] output_frequency;
	reg [26:0] output_pulse_width;
	reg [26:0] full_width_count;
	reg [26:0] num_pulse_width;
	reg [26:0] num_period_width;
	reg [26:0] count_pos_pos;
	reg [26:0] count_pos_neg;	
	
	reg[3:0] digit0, digit1, digit2, digit3, digit4, digit5;

	reg edgeFront, edgeBack, edgePos, edgeNeg;
	
	always @ (posedge MAX10_CLK1_50)
	begin
		if (SW[1] == 1) begin
			count_pos_pos <= 0;
			count_pos_neg <= 0;
			output_frequency <= 0;
			output_pulse_width <= 0;
			num_period_width <= 0;
			full_width_count <= 0;
			num_pulse_width <= 0;
			num_period_width <= 0;
			
			
			digit0 <= 0;
			digit1 <= 0;
			digit2 <= 0;
			digit3 <= 0;
			digit4 <= 0;
			digit5 <= 0;
			LEDR <= 8'b000000000;
			
			
		end
		else begin
			
			count_pos_pos <= count_pos_pos + 1;
			full_width_count <= count_pos_pos;
			count_pos_neg <= count_pos_neg + 1;
			if (count_pos_pos > 50000000) begin
				count_pos_pos <= 0; end
			if (count_pos_neg > 50000000) begin
				count_pos_neg <= 0; end
			
			if (SW[0] > 0) begin
				edgeFront <= KEY[1]; end
			else begin
				edgeFront <= ~GPIO[0]; end
			edgeBack <= edgeFront;
			edgePos <= (~edgeFront) & edgeBack;
			edgeNeg <= edgeFront & (~edgeBack);
			
			
			
			if (edgeNeg) begin
				num_pulse_width <= count_pos_neg;
			end
			
			if (edgePos) begin
				count_pos_neg <= 0;
				count_pos_pos <= 0;
				num_period_width <= full_width_count;
				
				
				
			end
			
			output_pulse_width <= (100 * num_pulse_width) / num_period_width;
			digit0 <= output_pulse_width / 100;
			digit1 <= (output_pulse_width / 10) % 10;
			digit2 <= output_pulse_width % 10;

			output_frequency <= 50000000 / num_period_width;

			if (output_frequency >= 1000000) begin
				digit3 <= output_frequency / 100000000;
				digit4 <= (output_frequency / 10000000) % 10;
				digit5 <= (output_frequency % 10000000)/1000000;
				LEDR[2] <= 0;
				LEDR[1] <= 0;
				LEDR[0] <= 1;end
			else if (output_frequency >= 1000) begin
				digit3 <= output_frequency / 100000;
				digit4 <= (output_frequency / 10000) % 10;
				digit5 <= (output_frequency % 10000)/1000;
				LEDR[2] <= 0;
				LEDR[1] <= 1;
				LEDR[0] <= 0;end
			else begin
				digit3 <= output_frequency / 100;
				digit4 <= (output_frequency / 10) % 10;
				digit5 <= output_frequency % 10;
				LEDR[2] <= 1;
				LEDR[1] <= 0;
				LEDR[0] <= 0;
			end
		end
		
	end
	
		
	always @ (posedge MAX10_CLK1_50)
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
		default:	HEX0[6:0] = 7'b1111110;
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
		default:	HEX1[6:0] = 7'b1111110;
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
		default:	HEX2[6:0] = 7'b1111110;
	endcase
	case(digit5)
		// outputting a zero = 0111111 = 63
		0:	HEX3[6:0] = 7'b1000000;
		// out3utting a one = 0000110 = 6
		1: HEX3[6:0] = 7'b1111001;
		// out3utting a two = 1011011 = 91
		2:	HEX3[6:0] = 7'b0100100;
		// outputting a three = 1001111 = 79
		3:	HEX3[6:0] = 7'b0110000;
		// outputting a four = 1100110 = 102
		4:	HEX3[6:0] = 7'b0011001;
		// outputting a five = 1101101 = 109
		5:	HEX3[6:0] = 7'b0010010;
		// outputting a six = 1111101 = 125
		6:	HEX3[6:0] = 7'b0000010;
		// outputting a seven = 0000111 = 7
		7:	HEX3[6:0] = 7'b1111000;
		// outputting an eight = 1111111 = 127
		8:	HEX3[6:0] = 7'b0000000;
		// outputting a nine = 1100111 = 103
		9:	HEX3[6:0] = 7'b0011000;
		default:	HEX3[6:0] = 7'b1111110;
	endcase
	case(digit4)
		// outputting a zero = 0111111 = 63
		0:	HEX4[6:0] = 7'b1000000;
		// outputting a one = 0000110 = 6
		1: HEX4[6:0] = 7'b1111001;
		// outputting a two = 1011011 = 91
		2:	HEX4[6:0] = 7'b0100100;
		// outputting a three = 1001111 = 79
		3:	HEX4[6:0] = 7'b0110000;
		// outputting a four = 1100110 = 102
		4:	HEX4[6:0] = 7'b0011001;
		// outputting a five = 1101101 = 109
		5:	HEX4[6:0] = 7'b0010010;
		// outputting a six = 1111101 = 125
		6:	HEX4[6:0] = 7'b0000010;
		// outputting a seven = 0000111 = 7
		7:	HEX4[6:0] = 7'b1111000;
		// outputting an eight = 1111111 = 127
		8:	HEX4[6:0] = 7'b0000000;
		// outputting a nine = 1100111 = 103
		9:	HEX4[6:0] = 7'b0011000;
		default:	HEX4[6:0] = 7'b1111110;
	endcase
	case(digit3)
		// outputting a zero = 0111111 = 63
		0:	HEX5[6:0] = 7'b1000000;
		// oututting a one = 0000110 = 6
		1: HEX5[6:0] = 7'b1111001;
		// outputting a two = 1011011 = 91
		2:	HEX5[6:0] = 7'b0100100;
		// outputting a three = 1001111 = 79
		3:	HEX5[6:0] = 7'b0110000;
		// outputting a four = 1100110 = 102
		4:	HEX5[6:0] = 7'b0011001;
		// outputting a five = 1101101 = 109
		5:	HEX5[6:0] = 7'b0010010;
		// outputting a six = 1111101 = 125
		6:	HEX5[6:0] = 7'b0000010;
		// outputting a seven = 0000111 = 7
		7:	HEX5[6:0] = 7'b1111000;
		// outputting an eight = 1111111 = 127
		8:	HEX5[6:0] = 7'b0000000;
		// outputting a nine = 1100111 = 103
		9:	HEX5[6:0] = 7'b0011000;
		default:	HEX4[6:0] = 7'b1111110;
	endcase
	end
		
	
	
endmodule
