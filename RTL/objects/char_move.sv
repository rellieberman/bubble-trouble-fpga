//character move logic
//character can move on bottom of screen within screen border	

module char_move
	#(parameter CHAR_HIGHT = 32,
		parameter CHAR_WIDTH = 20
	)
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
	parameter int INITIAL_Y = 479 - CHAR_HIGHT;
	
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
		

			
		if (rightPress && topLeftX <= 639 - CHAR_WIDTH)
			topLeftX_tmp = topLeftX + 1;
		else if (leftPress && topLeftX > 0)
			topLeftX_tmp = topLeftX - 1;
		else
			topLeftX_tmp = topLeftX;
	end
	
	
endmodule 