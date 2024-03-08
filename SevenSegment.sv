// Seven segment decoder as a set of SOP or POS equations.
module SevenSegment(
		input logic [ 3:0 ] hexDigit,
		input logic enable,
		output logic [ 6:0 ] segments );
	logic b0, b1, b2, b3;
	logic [ 6:0 ] s;
	assign b0 = hexDigit[ 0 ];
	assign b1 = hexDigit[ 1 ];
	assign b2 = hexDigit[ 2 ];
	assign b3 = hexDigit[ 3 ];
	// Equations for each of the segments, counting clockwise
	// around the outside starting from the top, then the middle.
	assign s[ 0 ] = b1 & b2 | ~b1 & ~b2 & b3 | ~b0 & b3 | ~b0 & ~b2 | b0 & b2 & ~b3 | b1 & ~b3 ? enable : 0;
	// YOUR CODE HERE.
	assign s[ 1 ] = ~b2 & ~b0 | ~b3 & ~b2 | ~b3 & ~b1 & ~b0 | b1 & b0 & ~b3 | ~b1 & b3 & ~b2 | b3 & ~b1 & b0 ? enable : 0;
	assign s[ 2 ] = ~b3 & ~b1 | ~b3 & b0 | ~b3 & b2 & b1 | b3 & ~b2 | ~b1 & b0 ? enable : 0;
	assign s[ 3 ] = b2 & ~b1 & b0 | b3 & ~b1 & ~b0 | b1 & b0 & ~b2 | b2 & b1 & ~b0 | ~b3 & ~b2 & ~b0 ? enable : 0;
	assign s[ 4 ] = b3 & b2 | b1 & ~b0 | b3 & b1 | ~b2 & ~b1 & ~b0 ? enable : 0;
	assign s[ 5 ] = ~b1 & ~b0 | ~b1 & ~b3 & b2 | b1 & b3 | b3 & ~b2 | b2 & b1 & ~b0 ? enable : 0;
	assign s[ 6 ] = ~b3 & b2 & ~b1 | b3 & ~b2 & ~b1 | b1 & ~b3 & ~b2 | b3 & b0 | b1 & ~b0 ? enable : 0;
	// Invert the outputs for active low on the DE1-SoC board.
	assign segments = ~s;
	
endmodule
