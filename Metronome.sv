module bpmCounter(input logic clock, reset, in, output logic [13:0] tempo);//counter for metronome, feed tempo into clock_divider
	logic press, out;
	initial begin
		tempo = 6'b111100;
	end
	holdPress h (clock, in, reset, out);
	detectpress d (clock, out, press);
	always_ff @ (posedge clock)
		if (reset)
			tempo <= 14'b00000000000001;
		else begin
			if (press)
				tempo <= tempo + 1;
		end
endmodule

module bpmDisplay(input logic [13:0] tempo, output [6:0] HEX0, HEX1, HEX2);
	logic [15:0] bcd_tempo;
	doubleDabble dd (tempo, bcd_tempo); //convert tempo to bcd
	
	//display tempo
	SevenSegment Hex0 (bcd_tempo[3:0], 1, HEX0);
	SevenSegment Hex1 (bcd_tempo[7:4], 1, HEX1);
	SevenSegment Hex2 (bcd_tempo[11:8], 1, HEX2);
endmodule