
module bubble_move
	(	
		input		logic			 clk,
		input		logic			 resetN,
		input		logic			 startOfFrame,  // short pulse every start of frame 30Hz 
		input 	logic	[1:0]  size,
		input		logic 		 start,
		input		logic 		 Hit,
		input		logic 		 direction,
		input		logic [10:0] startTopX,
		input		logic [10:0] startTopY,
		
		
		output	logic	[10:0]	topLeftX,// output the top left corner 
		output	logic	[10:0]	topLeftY,
		output	logic 			split
	);	
	
	parameter int INITIAL_X_SPEED = 30;
	parameter int INITIAL_Y_SPEED = 0;
	parameter int Y_ACCEL = -1;
	
	
	
	enum logic {noBubble, Bubble} cur_st, nxt_state;
	
	logic int Xspeed, Yspeed;
	
	logic	[10:0]	topLeftX_tmp,// output the top left corner 
	logic	[10:0]	topLeftY_tmp,
	
	// we want to work in higher resolution
	const int	x_FRAME_SIZE	=	639 * MULTIPLIER;
	const int	y_FRAME_SIZE	=	479 * MULTIPLIER;
	const int MULTIPLIER = 64;
	
	
	//state machine and bubble move flipflop
	always_ff@(posedge clk or negedge resetN) begin
		if (!resetN) begin
			cur_st <= noBubble;
			topLeftX_tmp <= -1; //will not display
			topLeftY_tmp <= -1;
		end else begin
		cur_st <= nxt_st;
		
		//only move char on start of frame
		if (startOfFrame) begin 
			topLeftX <= topLeftX + Xspeed;
			topLeftY <= topLeftY + Yspeed;
			
		end
	end
	
	//calculate x speed
	always_ff@(posedge clk or negedge resetN) begin
		if(!resetN || (cur_st == noBubble))
			Xspeed	<= INITIAL_X_SPEED;
	
	else if (cur_st = Bubble)	begin
			
			if ((topLeftX_tmp <= 0 ) && (Xspeed < 0) ) // hit left border while moving left
				Xspeed <= -Xspeed ; 
			
			if ( (topLeftX_tmp >= x_FRAME_SIZE) && (Xspeed > 0 )) // hit right border while moving left
				Xspeed <= -Xspeed ; 
	end
end

	//calculate y speed using gravity
	always_ff@(posedge clk or negedge resetN)
	begin
		if(!resetN || (cur_st == noBubble) begin 
			Yspeed	<= INITIAL_Y_SPEED; 
	else if  begin
			if (startOfFrame == 1'b1) 
				Yspeed <= Yspeed  - Y_ACCEL ; // deAccelerate : slow the speed down every start of frame tick 
			
			if ((topLeftY_tmp <= 0 ) && (Yspeed < 0 )) // hit top border heading up
				Yspeed <= -Yspeed ; 
			
			if ( ( topLeftY_tmp >= y_FRAME_SIZE) && (Yspeed > 0 )) //hit bottom border heading down 
				Yspeed <= -Yspeed ; 
		end 

	end
end
	
	
	
	//state comb
	always_comb begin
		
		case (cur_st)
			noBubble: begin
				if(start) begin
					
				end
			
			end //noBubble
		
		endcase
	
	
	end
	
	//get a better (64 times) resolution using integer   
	assign 	topLeftX = topLeftX_tmp / MULTIPLIER ;   // note it must be 2^n 
	assign 	topLeftY = topLeftY_tmp / MULTIPLIER ;    

	
	
endmodule 