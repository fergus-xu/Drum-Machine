module squareWave(input logic clock, enable, reset, beat, output logic [23:0] speaker); //generates a square wave
	parameter [9:0] frequency = 440;
	logic play;
	
	clock_divider_hz c (clock, reset, frequency, play); //generate the frequency, this is positive 440 times per second
	
	always_ff @(posedge clock)
		if (reset) 
			speaker <= 0;
		else if (enable && beat) begin
			case(play)
				1: speaker <= {1'b0, {23{1'b1}}};
				0: speaker <= 0;
			endcase
		end else begin
			speaker <= 0;
		end
endmodule

module soundSelect(input logic clock, reset, KEY3, output logic [3:0] sound, output [6:0] HEX5);
	
	//input logic
	logic switch, a, b;
	DFlipFlop d1 (clock, reset, ~KEY3, a);
	DFlipFlop d2 (clock, reset, a, b);
	detectpress d3 (clock, b, switch);

	always @(posedge clock)
		if (reset)
			sound <= 0;
		else if (switch) begin //if toggled
			if (sound == 4'b0101) //however many sounds
				sound <= 0; //reset to first
			else
				sound <= sound + 1; //next sound
		end else
			sound <= sound;
		
	SevenSegment Hex5 (sound, 1, HEX5);
endmodule

	