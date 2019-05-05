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
		input logic onN,
		
		output	logic	[10:0]	topLeftX,// output the top left corner 
		output	logic	[10:0]	topLeftY
	);
	
	enum logic {game, game_over} cur_st, nxt_st;
	
	logic [10:0] topLeftX_tmp;
	logic [10:0] topLeftY_tmp;
	
	parameter int INITIAL_X = 320;
	parameter int INITIAL_Y = 479 - CHAR_HIGHT;
	
	
	//state machine ff
	always_ff@(posedge clk or negedge resetN)
	begin
		if (!resetN)
			cur_st <= game;
		else
			cur_st <= nxt_st;
	end
	
	//char move ff
	always_ff@(posedge clk or negedge resetN)
	begin
		if (!resetN)
		begin
			topLeftX <= INITIAL_X;
			topLeftY <= INITIAL_Y;
		end
		else begin 
			if (startOfFrame || cur_st == game_over)
			begin
				topLeftX <= topLeftX_tmp;
				topLeftY <= topLeftY_tmp;
			end
		end
	end
	
	always_comb
	begin
	
		
		case (cur_st)
		
		
		
			game_over: begin
					topLeftY_tmp = INITIAL_Y;
					topLeftX_tmp = INITIAL_X;
					nxt_st = game;
			end	
		
		
			game : begin
				
				if (onN) begin
					nxt_st = game_over;
					topLeftY_tmp = INITIAL_Y;
					topLeftX_tmp = INITIAL_X;
				end else begin
					topLeftY_tmp = INITIAL_Y;
					nxt_st = cur_st;
					if (rightPress && topLeftX <= 639 - CHAR_WIDTH)
						topLeftX_tmp = topLeftX + 1;
					else if (leftPress && topLeftX > 0)
						topLeftX_tmp = topLeftX - 1;
					else
						topLeftX_tmp = topLeftX;
				end
			end


		endcase
	end
	
endmodule 