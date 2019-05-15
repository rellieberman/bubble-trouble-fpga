module game_control
(
    input logic clk,
    input logic resetN,
    input logic charHit,
	 input logic counter,
	 input logic player_won,
	 input logic space_press,
    
    
    output logic bubbleStart,
	 output logic charStart,
	 output logic [3:0] digit,
	 output logic displayMessage,
	 output logic [1:0] message
    
);
    enum logic [2:0] {preGame, game, ev_life, ret_game, win, lose} cur_st, nxt_st;
    logic [3:0] digit_tmp;
    
    
    always_ff@(posedge clk or negedge resetN) begin
        if (!resetN) begin
            cur_st <= preGame;
				digit <= 4'b0011;
			end else begin
            cur_st <= nxt_st;
				digit <= digit_tmp;
			end
    end

    always_comb begin

        case(cur_st)
            preGame: begin
                bubbleStart = 1;
					 charStart = 0;
					 digit_tmp = 4'b0011;
					 
					 displayMessage = 1;
					 message = 2'b00;
					 
					 if (space_press)
						nxt_st = game;
					 else
						nxt_st = cur_st;
					 
            end //preGame
				
				ret_game : begin
				
					displayMessage = 0;
					message = 2'b00;
					
					
					if (counter) begin
						bubbleStart = 0;
						charStart = 1;
						nxt_st = game;
						digit_tmp = digit;
					end else begin
						bubbleStart = 0;
						charStart = 0;
						nxt_st = cur_st;
						digit_tmp = digit;
					end
				
				end //ret_game
            
            game: begin
				
				  	 displayMessage = 0;
					 message = 2'b00;
				
                charStart = 1;
					 bubbleStart = 0;
                if (charHit) begin
                    nxt_st = ev_life;
						  digit_tmp = digit - 1;
					 end else if (player_won) begin
						 nxt_st = win;
						 digit_tmp = digit;
                end else begin
                    nxt_st = cur_st;
						  digit_tmp = digit;
					 end
            
            end //game
				
				ev_life : begin
				
					displayMessage = 0;
					message = 2'b00;
			
					bubbleStart = 0;
					charStart = 0;
					digit_tmp = digit;
					if (digit == 4'b0000)
						nxt_st = lose;
					else if (counter)
						nxt_st = ret_game;
					else
						nxt_st = cur_st;
				
				
				end //ev_life
            
            win: begin
                bubbleStart = 0;
					 charStart = 0;
                nxt_st = cur_st;
					 digit_tmp = digit;
					 
					 displayMessage = 1;
					 message = 2'b01;
            
            end //win
            
            lose: begin
                bubbleStart = 0;
					 charStart = 0;
                nxt_st = cur_st;
					 digit_tmp = digit;
					 
					 displayMessage = 1;
					 message = 2'b10;
            
            end //lose
            
            default begin
                bubbleStart = 0;
					 charStart = 0;
                nxt_st = cur_st;
					 digit_tmp = digit;
					 displayMessage = 0;
					 message = 2'b00;
            end
        
        endcase
    end

endmodule
