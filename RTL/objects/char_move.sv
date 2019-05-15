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
		input logic bubbleHit,
		input logic start,
		
		output	logic	[10:0]	topLeftX,// output the top left corner 
		output	logic	[10:0]	topLeftY
	);
	
	enum logic [1:0] {preGame, game, gameOver} cur_st, nxt_st;
	
	logic [10:0] topLeftX_tmp;
	logic [10:0] topLeftY_tmp;
	
	parameter int INITIAL_X = 320;
	parameter int INITIAL_Y = 479 - CHAR_HIGHT;
	
	
	//state machine ff
	always_ff@(posedge clk or negedge resetN)
	begin
		if (!resetN)
			cur_st <= gameOver;
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
			if (startOfFrame || cur_st == gameOver || cur_st == preGame)
			begin
				topLeftX <= topLeftX_tmp;
				topLeftY <= topLeftY_tmp;
			end
		end
	end
	
	always_comb
	begin
	
		
		case (cur_st)
		
		
		
			preGame: begin
					topLeftY_tmp = INITIAL_Y;
					topLeftX_tmp = INITIAL_X;
					if (start)
						nxt_st = game;
					else
						nxt_st = cur_st;
			end	
			
			gameOver: begin
					topLeftY_tmp = -1;
					topLeftX_tmp = -1;
					if (start)
						nxt_st = preGame;
					else
						nxt_st = cur_st;
			end
		
		
			game : begin
				
				if (bubbleHit) begin
					nxt_st = gameOver;
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
