module switchInput(input logic clock, reset, enable, input logic [7:0] SW, output logic [7:0] seq); //takes input while enabled else holds pattern
	initial seq = 8'b00000000;
	always @(posedge clock)
		if (reset)
			seq <= 0;
		else begin
			if (enable )
				seq <= SW;
			else
				seq <= seq;
		end
endmodule

module tapInput(input logic clock, reset, enable, beat, KEY, resetKEY, output logic [7:0] seq);
	logic [2:0] counter;
	logic a, b, out;
	DFlipFlop d1 (clock, reset, ~KEY, a);
	DFlipFlop d2 (clock, reset, a, b);
	detectpress d3 (clock, b, out); 
	
	logic c, d, soft_reset;
	DFlipFlop d4 (clock, reset, ~resetKEY, c);
	DFlipFlop d5 (clock, reset, c, d);
	detectpress d6 (clock, d, soft_reset); 
	
	always_ff @(posedge clock) //input circuit
		if (reset || soft_reset)
			seq <= 0;
		else if (enable) begin
			if (out)
				case (beat) // 1 should go to current beat, 0 should go to next beat
					1: seq[counter] <= 1; //if input is late
					0: if (counter == 3'b000) //if input is early
							seq[7] <= 1;
						else 
							seq[counter - 1] <=  1;
				endcase
		end

	always_ff @(posedge beat)//counter circuit
		if (reset)
			counter <= 3'b111;
		else if (counter == 3'b000)
			counter <= 3'b111;
		else
			counter <= counter - 1;
			
endmodule

module combineInput(input logic clock, reset, enable, beat, KEY1, KEY2, input logic [7:0] SW, output logic [7:0] seq); //combines key and switch input

	//if switches are all zero take key input else switch input
	logic [7:0] tapSeq = 0, swSeq = 0;
	switchInput switch (clock, reset, enable, SW, swSeq);
	tapInput tap (clock, reset, enable, beat, KEY1, KEY2, tapSeq);
	
	//logic to determine which 
	always_ff @(posedge clock)
		if (reset)
			seq <= 0;//suppress all output on reset
		else if (enable) begin//if supposed to be taking input
			if (SW == 0) begin//if switches all 0
				seq <= tapSeq; //use tap sequence
			end else begin
				seq <= swSeq; //use switch input
			end
		end
endmodule
