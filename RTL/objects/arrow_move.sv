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
	
	enum logic {noArrow, ArrowShot} cur_st, nxt_st;
	
	logic [10:0] nxt_topLeftX;
	logic [10:0] nxt_topLeftY;
	
	always_ff@(posedge clk or negedge resetN) begin
		if (!resetN) begin
			cur_st <= noArrow;
			topLeftX <= -1; //will not display
			topLeftY <= -1;
		end else begin
			cur_st <= nxt_st;
			topLeftX <= nxt_topLeftX;
			topLeftY <= nxt_topLeftY;
		end
	end
	
	always_comb begin
		
		
		
		case (cur_st)
		
			noArrow: begin
				if (spacePress) begin
					nxt_st = ArrowShot;
					nxt_topLeftX = charTopX;
					nxt_topLeftY = charTopY;
				end else begin
					nxt_st = cur_st;
					nxt_topLeftX = topLeftX;
					nxt_topLeftY = topLeftY;
				end
				
					
			end //noArrow
			
			ArrowShot: begin
				if (crash) begin
					nxt_st = noArrow;
					nxt_topLeftX = -1;
					nxt_topLeftY = -1;
				end else if (startOfFrame) begin
					nxt_st = cur_st;
					nxt_topLeftX = topLeftX;
					nxt_topLeftY = topLeftY - 1;
				end else begin
					nxt_st = cur_st;
					nxt_topLeftX = topLeftX;
					nxt_topLeftY = topLeftY;
				end
			
			end //ArrowShot
	
	
	end
	
	
endmodule 
