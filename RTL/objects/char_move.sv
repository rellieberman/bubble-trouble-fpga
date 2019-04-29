//character move logic
//character can move on bottom of screen within screen border	

module char_move
	#(parameter CHAR_HIGHT = 32)
	(
		
		input	logic	clk,
		input	logic	resetN,
		input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
		input logic leftPress,
		input logic rightPress,
		input logic rightCrash,
		input logic leftCrash,
		
		output	logic	[10:0]	topLeftX,// output the top left corner 
		output	logic	[10:0]	topLeftY
	);
	
	logic [10:0] topLeftX_tmp ;
	
	parameter int INITIAL_X = 320;
	parameter int INITIAL_Y = 480 - CHAR_HIGHT;
	
	always_ff@(posedge clk or negedge resetN)
	begin
		if (!resetN)
		begin
			topLeftX <= INITIAL_X;
		end
		else if (startOfFrame)
		begin
			topLeftX <= topLeftX_tmp;
		end	
	end
	
	always_comb
	begin
	
		topLeftY = INITIAL_Y;
		topLeftX_tmp = topLeftX;

			
		if (rightPress && !rightCrash)
			topLeftX_tmp = topLeftX + 1;
		else if (leftPress && !leftCrash)
			topLeftX_tmp = topLeftX - 1;
	end
	
	
endmodule 