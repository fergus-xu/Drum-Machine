module DFlipFlop(clock, reset,  D, Q); //simple flip flop
	input logic clock, D, reset;
	output logic Q;
	
	//contains D-flipflops for inputs
	always @( posedge clock)
		if (reset)
			Q <= 0;
		else
			Q <= D;
			
endmodule

module detectpress(clock, in, out);	//registers a press as pos for one clock cycle only
	input logic in, clock;
	output logic out;
	
	logic prev;

	always @(posedge clock) begin
		 prev <= in;
	end
	assign out = in & ~prev;
	
endmodule

module holdPress(input logic clock, in, reset, output logic out); //allows to toggle between single presses and holding input at a specified rate
	parameter clock_freq = 50_000_000, seconds = 1, cycles = clock_freq*seconds; //calculate the time to trigger hold in cycles
	logic [31:0] counter;
	logic [9:0] hold_input = 10;
	
	always_ff @ (posedge clock)
		if (in)
			counter <= counter + 1; // start counting;
		else
			counter <= 0;
	logic pulse;
	clock_divider_hz c (clock, reset, hold_input, pulse); //starts outputting at specified frequency
	logic prev;
	always_ff @(posedge clock) begin
		prev <= in;
		if (counter >= cycles)
			out <= pulse;
		else 
			out <= in & ~prev;
	end
endmodule
