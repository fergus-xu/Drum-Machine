# Drum-Machine
System Verilog Code for a Drum Machine using the DE1_SoC

Additional files for audio can be found here: https://class.ece.uw.edu/271/hauck2/de1/audio/AudioFiles.zip

## Instructions

**Modes**
The drum machine has two modes, play and write.  In play mode, the beat continuously loops according to the previous input. In write mode, you can change the input for each sound. The mode is controlled using SW[8], where a toggled switch enters write mode. 

**Reset**
The machine can be reset by toggling SW[9]. 

**Changing Tempo**
You can change the tempo by pressing KEY[0]. Press once to increment the tempo by one, or hold to continuously increase it. If you wish to reset the tempo, reset the entire machine. 

**Programming a Beat**
There are 5 sounds built into the machine. Sound 0 is blank. You can swap between these sounds by pressing KEY[3]. When you have found your desired sound, you can enter input using either the switches, or by tapping in your beat. Switches 7-0 control their corresponding beat. The sound will play on the beats that are toggled. Alternatively, you can tap KEY[2] as input, and it will be corrected to the nearest beat. Switches 7-0 must be in the down position to enter key input. Press KEY[1] to clear. 

**Additional Notes**
In play mode, you can switch through the sounds, and the associated playing beats will be displayed, along with a constant metronome. 
****
