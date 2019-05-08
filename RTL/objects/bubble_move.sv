
module bubble_move
	(	
		input		logic		 clk,
		input		logic		 resetN,
		input		logic		 startOfFrame,  // short pulse every start of frame 30Hz 
		input 		logic [2:0]  size,
		input		logic 		 start,
		input		logic 		 Hit,
		input		logic 		 direction,
		input		logic [10:0] startTopX,
		input		logic [10:0] startTopY,
		
		
		output	logic	[10:0]	topLeftX,// output the top left corner 
		output	logic	[10:0]	topLeftY,
		output	logic 			split,
		output  logic	[2:0]	size_out
	);	
	
	parameter int OBJECT_SIZE = 8;
	parameter int INITIAL_X_SPEED = 70;
	parameter int INITIAL_Y_SPEED = 0;
	parameter int Y_ACCEL = -1;
	
	
	
	enum logic [1:0] {noBubble, Start, Bubble} cur_st, nxt_st;
	
	int Xspeed, Yspeed;
	
	int	topLeftX_tmp;// output the top left corner 
	int	topLeftY_tmp;
	
	// we want to work in higher resolution
	const int MULTIPLIER = 64;
	const int	x_FRAME_SIZE	=	639 * MULTIPLIER;
	const int	y_FRAME_SIZE	=	479 * MULTIPLIER;

	
	//state machine ff
	always_ff@(posedge clk or negedge resetN) begin
		if (!resetN)
			cur_st <= noBubble;
		else
			cur_st <= nxt_st;
	end
	
	//control bubble move flipflop
	always_ff@(posedge clk or negedge resetN) begin
		if (!resetN) begin
			topLeftX_tmp <= -MULTIPLIER; //will not display
			topLeftY_tmp <= -MULTIPLIER;
		end else if (cur_st == noBubble) begin
			topLeftX_tmp <= -MULTIPLIER; //will not display
			topLeftY_tmp <= -MULTIPLIER;
		end else if (cur_st == Start) begin
			topLeftX_tmp <= startTopX * MULTIPLIER;
			topLeftY_tmp <= startTopY * MULTIPLIER;
		end else begin //cur_st == Bubble
		//only move char on start of frame
			if (startOfFrame) begin 
				topLeftX_tmp <= topLeftX_tmp + Xspeed;
				topLeftY_tmp <= topLeftY_tmp + Yspeed;
			end
		end
	end
	
	//calculate x speed
	always_ff@(posedge clk or negedge resetN) begin
		if(!resetN)
			Xspeed	<= INITIAL_X_SPEED;
		else if (cur_st == noBubble)
			Xspeed	<= INITIAL_X_SPEED;
		else if (cur_st == Start && !direction)
			Xspeed <= -INITIAL_X_SPEED;
		else if (cur_st == Bubble) begin
			
			if ((topLeftX_tmp <= 0 ) && (Xspeed < 0) ) // hit left border while moving left
				Xspeed <= -Xspeed; 
			
			if ( (topLeftX_tmp + (OBJECT_SIZE << size) * MULTIPLIER >= x_FRAME_SIZE) && (Xspeed > 0 )) // hit right border while moving left
				Xspeed <= -Xspeed; 
		end
	end

	//calculate y speed using gravity
	always_ff@(posedge clk or negedge resetN) begin
		if(!resetN)
			Yspeed	<= INITIAL_Y_SPEED; 
		else if (cur_st == noBubble)
			Yspeed	<= INITIAL_Y_SPEED;
		else begin
			if (startOfFrame == 1'b1) 
				Yspeed <= Yspeed  - Y_ACCEL ; // deAccelerate : slow the speed down every start of frame tick 
			
			if ((topLeftY_tmp <= 0 ) && (Yspeed < 0 )) // hit top border heading up
				Yspeed <= -Yspeed ; 
			
			if ( ( topLeftY_tmp + (OBJECT_SIZE << size) * MULTIPLIER >= y_FRAME_SIZE) && (Yspeed > 0 )) //hit bottom border heading down 
				Yspeed <= -Yspeed ; 
		end 

	end
	
	
	
	//state comb
	always_comb begin
	

		split = 0;
		case (cur_st)
			noBubble: begin
				if(start)
					nxt_st = Start;
				else
					nxt_st = cur_st;
			
			end //noBubble
			
			Start: begin
				nxt_st = Bubble;
			
			end //Start
			
			Bubble: begin
				if (Hit) begin
					nxt_st = noBubble;
					split = 1;
				end	else
					nxt_st = cur_st;
			end //Bubble
		
		endcase
	
	
	end
	
	
	
	//get a better (64 times) resolution using integer   
	assign 	topLeftX = topLeftX_tmp / MULTIPLIER;   // note it must be 2^n 
	assign 	topLeftY = topLeftY_tmp / MULTIPLIER;
	assign	size_out = size;   

	
	
endmodule 
