module game_control
(
    input logic clk,
    input logic resetN,
    input logic charHit,
    
    
    output logic start
    
);
    enum logic [1:0] {preGame, game, win, lose} cur_st, nxt_st;
    
    
    
    always_ff@(posedge clk or negedge resetN) begin
        if (!resetN)
            cur_st <= preGame;
        else
            cur_st <= nxt_st;
    
    end

    always_comb begin
        case(cur_st)
            preGame: begin
                start = 1;
                nxt_st = game;
            
            end //preGame
            
            game: begin
                start = 0;
                if (charHit)
                    nxt_st = lose;
                else
                    nxt_st = cur_st;
            
            end //game
            
            win: begin
                start = 0;
                nxt_st = cur_st;
            
            end //win
            
            lose: begin
                start = 0;
                nxt_st = cur_st;
            
            end //lose
            
            default begin
                start = 0;
                nxt_st = cur_st;
            end
        
        endcase
    end

endmodule
