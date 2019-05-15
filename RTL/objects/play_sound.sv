module play_sound
(
	input logic clk,
	input logic resetN,
	input logic counter,
	
	input logic charHit,
	input logic bubbleHit,
	
	output logic play,
	output logic [3:0] tone

);

	assign tone = 4'b0011;
	
	enum logic [1:0] {quiet, play_1, play_2} cur_st, nxt_st;
	
	always_ff@(posedge clk or negedge resetN) begin
		if (!resetN)
			cur_st <= quiet;
		else
			cur_st <= nxt_st;
		end 
		
		
	 always_comb begin
	
		case (cur_st)
			quiet : begin
				play = 0;
				if (charHit || bubbleHit)
					nxt_st = play_1;
				else
					nxt_st = cur_st;
				
			
			end //quiet
			
			play_1 : begin
				play = 1;
				if (counter)
					nxt_st = play_2;
				else
					nxt_st = cur_st;
			
			
			end //play_1
			
			play_2 : begin
				play = 1;
				if (counter)
					nxt_st = quiet;
				else
					nxt_st = cur_st;
				
			
			end //play_2
			
			default begin
				play = 0;
				nxt_st = cur_st;
			
			end
	 
		endcase 
	 
	 end

endmodule 