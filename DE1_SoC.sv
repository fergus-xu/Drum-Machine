module DE1_SoC(CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW,
					FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK,
					AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);
	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0 = 7'b1111111, HEX1 = 7'b1111111, HEX2 = 7'b1111111, HEX3 = 7'b1111111, HEX4 = 7'b1111111, HEX5 = 7'b1111111; //suppress for now
	output logic [9:0] LEDR	;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	
	logic reset;
	assign reset = SW[9];
	assign LEDR[9] = reset;
	logic clock; //main clock
	assign clock = CLOCK_50;
	
	//tempo controls and display
	logic [13:0] tempo;
	logic a, b; //temporary logic to register input
	logic beat; //pos on beat
	//tempo control
	DFlipFlop d1 (clock, reset, ~KEY[0], a);
	DFlipFlop d2 (clock, reset, a, b);
	bpmCounter count (clock, reset, b, tempo); //control tempo
	bpmDisplay display (tempo, HEX0, HEX1, HEX2); //display the tempo
	
	clock_divider_bpm bpm_clock (clock, reset, tempo, beat); //generate the overall bpm
	//logic for the audio driver
	logic [23:0] dac_left, dac_right;
	logic [23:0] adc_left, adc_right;
	logic advance;
	logic [23:0] pcm = 0;
	assign dac_left = pcm;
	assign dac_right = pcm;
	logic [3:0] sound = 0; 
	
	//logic mode;
	assign mode = SW[8]; //this controls play/write mode. 0:write, 1: play only
	assign LEDR[8] = mode;
	
	//main modules 
	soundSelect select (clock, reset, KEY[3], sound, HEX5); //select the sound
	soundMachine sm (clock, beat, reset, KEY[2], KEY[1], mode, SW[7:0], sound, pcm, LEDR[7:0]); //generate the sound
	audio_driver ad2 (clock, reset, dac_left, dac_right, adc_left, adc_right, advance, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);
endmodule
