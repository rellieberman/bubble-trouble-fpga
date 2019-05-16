module life_move
(
	
		input		logic	clk,
		input		logic	resetN,
		input logic [10:0] RandTopX,
		input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
		input logic crash,
		input logic counter,
		
		output	logic	[10:0]	topLeftX,// output the top left corner 
		output	logic	[10:0]	topLeftY

);
	parameter int LIFE_HIGHT = 24;
	parameter int COUNT_TIME = 24;

	enum logic {noLife, Life} cur_st, nxt_st;
	
	logic [10:0] nxt_topLeftX;
	logic [10:0] nxt_topLeftY;
	
	int time_counter;
	int nxt_time_counter;
	
	always_ff@(posedge clk or negedge resetN) begin
		if (!resetN) begin
			cur_st <= noLife;
			topLeftX <= -1; //will not display
			topLeftY <= -1;
			time_counter = COUNT_TIME;
		end else begin
			cur_st <= nxt_st;
			topLeftX <= nxt_topLeftX;
			topLeftY <= nxt_topLeftY;
			time_counter = nxt_time_counter;
		end
	end
	
	always_comb begin
		
		
		case (cur_st)
		
			noLife: begin
			
				if (counter)
						nxt_time_counter = time_counter - 1;
					else
						nxt_time_counter = time_counter;
			
				if (time_counter == 1) begin
					nxt_st = Life;
					nxt_topLeftX = RandTopX;
					nxt_topLeftY = 0;
				end else begin
					nxt_st = cur_st;
					nxt_topLeftX = topLeftX;
					nxt_topLeftY = topLeftY;
					
				end
				
					
			end //noLife
			
			Life: begin
				nxt_time_counter = COUNT_TIME;
				if (topLeftY >= 479 - LIFE_HIGHT || crash) begin // hit bottom
					nxt_st = noLife;
					nxt_topLeftX = -1;
					nxt_topLeftY = -1;
				end else if (startOfFrame) begin
					nxt_st = cur_st;
					nxt_topLeftX = topLeftX;
					nxt_topLeftY = topLeftY + 3;
				end else begin
					nxt_st = cur_st;
					nxt_topLeftX = topLeftX;
					nxt_topLeftY = topLeftY;
				end
			
			end //Life
	
		endcase 
	end

endmodule 