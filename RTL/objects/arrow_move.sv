module arrow_Move
	(
		input		logic	clk,
		input		logic	resetN,
		input logic [10:0] charTopX,
		input logic [10:0] charTopY,
		input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
		input logic spacePress,
		input logic crash,
		
		output	logic	[10:0]	topLeftX,// output the top left corner 
		output	logic	[10:0]	topLeftY
	);
	
	
	
endmodule 