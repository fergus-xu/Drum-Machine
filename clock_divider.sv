module clock_divider_hz(input logic clock, reset, input logic [9:0] freq, output logic enable );

	parameter clockFreq = 50_000_000;
	logic [31:0] divisor;
	assign divisor = clockFreq / (2*freq); // set desired freq
	
	logic [ 31:0 ] counter;
	
	always_ff @( posedge clock )
		if (reset) begin
			counter <= divisor;
			enable <= 1'b0;
		end else if (counter == 0) begin
			enable <= ~enable;
			counter <= divisor;
		end else 
			counter <= counter -1;
endmodule

module clock_divider_bpm(input logic clock, reset, input logic [13:0] bpm, output logic beat); //in eighth notes
	parameter clockFreq = 3_000_000_000;
	logic [31:0] divisor;
	assign divisor = clockFreq / (4*bpm); // set desired freq
	
	logic [ 31:0 ] counter;
	
	always_ff @( posedge clock )
		if (reset) begin
			counter <= divisor;
			beat <= 1'b0;
		end else if (counter == 0) begin
			beat <= ~beat;
			counter <= divisor;
		end else 
			counter <= counter -1;

endmodule
