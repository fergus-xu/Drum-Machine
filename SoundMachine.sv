module soundMachine(input logic clock, beat, reset, KEY1, KEY2, mode, input logic [7:0] SW, input logic [3:0] sound, output logic [23:0] pcm, output logic [7:0] LEDR); //handles the multiple sounds
	
	logic [2:0] counter = 3'b111; //overall beat counter
	
	//logic for sound1
	assign enable_sound1 = (sound == 1) && mode; //if sound select matches and input is enabled
	logic [7:0] sound1_seq; //repeat for each sound
	logic [23:0] sound1;
	logic play_sound1;
	
	combineInput sound1_in (clock, reset, enable_sound1, beat, KEY1, KEY2, SW, sound1_seq); //generate switch input
	//combine tap and switch input
	
	//logic for sound2
	assign enable_sound2 = (sound == 2) && mode;
	logic [7:0] sound2_seq; //repeat for each sound
	logic [23:0] sound2;
	logic play_sound2;
	
	combineInput sound2_in (clock, reset, enable_sound2, beat, KEY1, KEY2, SW, sound2_seq); //generate switch input
	
	//sound 3
	assign enable_sound3 = (sound == 3) && mode;
	logic [7:0] sound3_seq; //repeat for each sound
	logic [23:0] sound3;
	logic play_sound3;
	
	combineInput sound3_in (clock, reset, enable_sound3, beat, KEY1, KEY2, SW, sound3_seq); //generate switch input
	
	//sound 4
	assign enable_sound4 = (sound == 4) && mode;
	logic [7:0] sound4_seq; //repeat for each sound
	logic [23:0] sound4;
	logic play_sound4;
	
	combineInput sound4_in (clock, reset, enable_sound4, beat, KEY1, KEY2, SW, sound4_seq); //generate switch input
	
	//sound 5
	assign enable_sound5 = (sound == 5) && mode;
	logic [7:0] sound5_seq; //repeat for each sound
	logic [23:0] sound5;
	logic play_sound5;
	
	combineInput sound5_in (clock, reset, enable_sound5, beat, KEY1, KEY2, SW, sound5_seq); //generate switch input
	
	always_ff @(posedge beat) //on the posedge of each beat
		if (reset) begin
			play_sound1 <= 0;
			play_sound2 <= 0;
			play_sound3 <= 0;
			play_sound4 <= 0;
			play_sound5 <= 0;
			counter <= 3'b111;
		end else begin 
			if (counter == 3'b000)
				counter <= 3'b111; //reset the counter
			else 
				counter <= counter - 1; //increment the counter
			play_sound1 <= sound1_seq[counter];
			play_sound2 <= sound2_seq[counter];
			play_sound3 <= sound3_seq[counter];
			play_sound4 <= sound4_seq[counter];
			play_sound5 <= sound5_seq[counter];
		end
	
	//sound generation
	squareWave square1 (clock, play_sound1, reset, beat, sound1);
	squareWave #(.frequency(100)) square2 (clock, play_sound2, reset, beat, sound2);
	squareWave #(.frequency(50)) square3 (clock, play_sound3, reset, beat, sound3);
	squareWave #(.frequency(800)) square4 (clock, play_sound4, reset, beat, sound4);
	squareWave #(.frequency(300)) square5 (clock, play_sound5, reset, beat, sound5);
	
	//display
	logic [7:0] display_seq;
	always_ff @(posedge clock)
		if (reset)
			display_seq <= 0;
		else 
			case (sound)
				1: display_seq <= sound1_seq;
				2: display_seq <= sound2_seq;
				3: display_seq <= sound3_seq;
				4: display_seq <= sound4_seq;
				5: display_seq <= sound5_seq;
				default: display_seq <= 0;
			endcase
	soundDisplay sd1 (clock, beat, reset, display_seq, LEDR[7:0]);
	
	//combine sound
	assign pcm = sound1 + sound2 + sound3 + sound4 + sound5;
endmodule

module soundDisplay(input logic clock, beat, reset, input logic [7:0] seq, output logic [7:0] LEDR); //displays the metronome and the playing beats
	
	//metronome display
	logic [7:0] metLEDR;
	always_ff @(posedge beat)
		if (reset)	
			metLEDR[7:0] <= 8'b00000000;
		else if (LEDR[7:0] == 0)
			metLEDR[7:0] <= 8'b10000000;
		else
			metLEDR[7:0] <= {metLEDR[0] , metLEDR[7:1]};
		
	assign LEDR = metLEDR | seq; //combine the static with the LEDR
	
endmodule
