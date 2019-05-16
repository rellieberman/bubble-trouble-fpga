//module will handle the multiple bubble instances and their state
module bubble_array
(
        input		logic	clk,
        input		logic	 resetN,
        
        //bubble move
        input		logic	 startOfFrame,  // short pulse every start of frame 30Hz 
        input		logic 	 start,
        input		logic 	 arrowHit,
        
        //square
        input 	logic	[10:0] pixelX,// current VGA pixel 
        input 	logic	[10:0] pixelY,
        
        output logic drawingRequest,
        output logic [7:0] RGBout,
		  output logic win
);
    logic [3:0] starts;
    logic [14:0] hits;
    logic [14:0] drawingRequests;
    logic [14:0] splits;
    logic [14:0] [7:0] RGBouts;
	 
	 int bubbles_hit;
	 int nxt_bubble;
    
    logic [6:0] [10:0] topLeftXs;
    logic [6:0] [10:0] topLeftYs;
    
    parameter [10:0] INITIAL_X = 200;
    parameter [10:0] INITIAL_Y = 50;
    parameter [2:0] SIZE = 3'd3;
	 
	 enum logic {hit, nohit} cur_st, nxt_st;
	 
	 
	 always_ff@(posedge clk or negedge resetN) begin
		if (!resetN) begin
			bubbles_hit <= 16;
			cur_st <= nohit;
		end else begin
			cur_st <= nxt_st;
			bubbles_hit <= nxt_bubble;
		end
	 
	 end
	 
	 
	 always_comb begin
		
		case (cur_st)
		
			hit : begin
				if (!arrowHit) begin
					nxt_st = nohit;
					nxt_bubble = bubbles_hit;
				end else begin
					nxt_st = cur_st;
					nxt_bubble = bubbles_hit;
				end
			
			end
			
			
			nohit : begin
				if (arrowHit) begin
					nxt_st = hit;
					nxt_bubble = bubbles_hit - 1;
				end else begin
					nxt_st = cur_st;
					nxt_bubble = bubbles_hit;
				end
			
			end
			
			default begin
				   nxt_st = cur_st;
					nxt_bubble = bubbles_hit;
			
			end
		
		
		
		
		endcase
	 
	 
	 
	 end
	 
	 assign win = (bubbles_hit == 0) ? 1'b1 : 1'b0;

    //connect all 8 bubble instances
    
    
    //first bubble
    bubble level_1(
                    .clk(clk),
                    .resetN(resetN),
                    .startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
                    .size(SIZE),
                    .start(start),
                    .Hit(hits[0]),
                    .direction(1),
                    .startTopX(INITIAL_X),
                    .startTopY(INITIAL_Y),
        
    
                    .pixelX(pixelX),// current VGA pixel 
                    .pixelY(pixelY),
		
                    .topLeftX(topLeftXs[0]),
                    .topLeftY(topLeftYs[0]),
                    .split(splits[0]),
                    .RGBout(RGBouts[0]),//optional color output for mux 
                    .drawingRequest(drawingRequests[0]) // indicates pixel inside the bracket
                    );
              
              
     // two second bubbles
     bubble level_2_1(
                    .clk(clk),
                    .resetN(resetN),
                    .startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
                    .size(3'd2),
                    .start(splits[0]),
                    .Hit(hits[1]),
                    .direction(0),
                    .startTopX(topLeftXs[0]),
                    .startTopY(topLeftYs[0]),
        
    
                    .pixelX(pixelX),// current VGA pixel 
                    .pixelY(pixelY),
		
                    .topLeftX(topLeftXs[1]),
                    .topLeftY(topLeftYs[1]),
                    .split(splits[1]),
                    .RGBout(RGBouts[1]),//optional color output for mux 
                    .drawingRequest(drawingRequests[1]) // indicates pixel inside the bracket
                    );
         bubble level_2_2(
                    .clk(clk),
                    .resetN(resetN),
                    .startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
                    .size(3'd2),
                    .start(splits[0]),
                    .Hit(hits[2]),
                    .direction(1),
                    .startTopX(topLeftXs[0]),
                    .startTopY(topLeftYs[0]),
        
    
                    .pixelX(pixelX),// current VGA pixel 
                    .pixelY(pixelY),
		
                    .topLeftX(topLeftXs[2]),
                    .topLeftY(topLeftYs[2]),
                    .split(splits[2]),
                    .RGBout(RGBouts[2]),//optional color output for mux 
                    .drawingRequest(drawingRequests[2]) // indicates pixel inside the bracket
                    );
                    
       
       
        //four third lever bubbles
        //connected to bubble 2_1
             bubble level_2_1_1(
                    .clk(clk),
                    .resetN(resetN),
                    .startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
                    .size(3'd1),
                    .start(splits[1]),
                    .Hit(hits[3]),
                    .direction(0),
                    .startTopX(topLeftXs[1]),
                    .startTopY(topLeftYs[1]),
        
    
                    .pixelX(pixelX),// current VGA pixel 
                    .pixelY(pixelY),
						  .topLeftX(topLeftXs[3]),
                    .topLeftY(topLeftYs[3]),
                    .split(splits[3]),
                    .RGBout(RGBouts[3]),//optional color output for mux 
                    .drawingRequest(drawingRequests[3]) // indicates pixel inside the bracket
                    );
         bubble level_2_1_2(
                    .clk(clk),
                    .resetN(resetN),
                    .startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
                    .size(3'd1),
                    .start(splits[1]),
                    .Hit(hits[4]),
                    .direction(1),
                    .startTopX(topLeftXs[1]),
                    .startTopY(topLeftYs[1]),
        
    
                    .pixelX(pixelX),// current VGA pixel 
                    .pixelY(pixelY),
						  .topLeftX(topLeftXs[4]),
                    .topLeftY(topLeftYs[4]),
                    .split(splits[4]),
                    .RGBout(RGBouts[4]),//optional color output for mux 
                    .drawingRequest(drawingRequests[4]) // indicates pixel inside the bracket
                    );
                    
           
            //conected to bubble 2_2
                 bubble level_2_2_1(
                    .clk(clk),
                    .resetN(resetN),
                    .startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
                    .size(3'd1),
                    .start(splits[2]),
                    .Hit(hits[5]),
                    .direction(0),
                    .startTopX(topLeftXs[2]),
                    .startTopY(topLeftYs[2]),
                    
    
                    .pixelX(pixelX),// current VGA pixel 
                    .pixelY(pixelY),
						  .topLeftX(topLeftXs[5]),
                    .topLeftY(topLeftYs[5]),
                    .split(splits[5]),
                    .RGBout(RGBouts[5]),//optional color output for mux 
                    .drawingRequest(drawingRequests[5]) // indicates pixel inside the bracket
                    );
         bubble level_2_2_2(
                    .clk(clk),
                    .resetN(resetN),
                    .startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
                    .size(3'd1),
                    .start(splits[2]),
                    .Hit(hits[6]),
                    .direction(1),
                    .startTopX(topLeftXs[2]),
                    .startTopY(topLeftYs[2]),
                    
    
                    .pixelX(pixelX),// current VGA pixel 
                    .pixelY(pixelY),
						  .topLeftX(topLeftXs[6]),
                    .topLeftY(topLeftYs[6]),
                    .split(splits[6]),
                    .RGBout(RGBouts[6]),//optional color output for mux 
                    .drawingRequest(drawingRequests[6]) // indicates pixel inside the bracket
                    );
        
        //last level
		 
				//connected to bubble 3
						 bubble level_2_1_1_1(
                    .clk(clk),
                    .resetN(resetN),
                    .startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
                    .size(3'd0),
                    .start(splits[3]),
                    .Hit(hits[7]),
                    .direction(0),
                    .startTopX(topLeftXs[3]),
                    .startTopY(topLeftYs[3]),
        
    
                    .pixelX(pixelX),// current VGA pixel 
                    .pixelY(pixelY),
		
                    .split(splits[7]),
                    .RGBout(RGBouts[7]),//optional color output for mux 
                    .drawingRequest(drawingRequests[7]) // indicates pixel inside the bracket
                    );
				  bubble level_2_1_1_2(
                    .clk(clk),
                    .resetN(resetN),
                    .startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
                    .size(3'd0),
                    .start(splits[3]),
                    .Hit(hits[8]),
                    .direction(1),
                    .startTopX(topLeftXs[3]),
                    .startTopY(topLeftYs[3]),
        
    
                    .pixelX(pixelX),// current VGA pixel 
                    .pixelY(pixelY),
		
                    .split(splits[8]),
                    .RGBout(RGBouts[8]),//optional color output for mux 
                    .drawingRequest(drawingRequests[8]) // indicates pixel inside the bracket
                    );
				//connected to bubble 4
					bubble level_2_1_2_1(
                    .clk(clk),
                    .resetN(resetN),
                    .startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
                    .size(3'd0),
                    .start(splits[4]),
                    .Hit(hits[9]),
                    .direction(1),
                    .startTopX(topLeftXs[4]),
                    .startTopY(topLeftYs[4]),
        
    
                    .pixelX(pixelX),// current VGA pixel 
                    .pixelY(pixelY),
                    .split(splits[9]),
                    .RGBout(RGBouts[9]),//optional color output for mux 
                    .drawingRequest(drawingRequests[9]) // indicates pixel inside the bracket
                    );
						
						bubble level_2_1_2_2(
                    .clk(clk),
                    .resetN(resetN),
                    .startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
                    .size(3'd0),
                    .start(splits[4]),
                    .Hit(hits[10]),
                    .direction(0),
                    .startTopX(topLeftXs[4]),
                    .startTopY(topLeftYs[4]),
        
    
                    .pixelX(pixelX),// current VGA pixel 
                    .pixelY(pixelY),

                    .split(splits[10]),
                    .RGBout(RGBouts[10]),//optional color output for mux 
                    .drawingRequest(drawingRequests[10]) // indicates pixel inside the bracket
                    );
                    
              //connected to bubble 5
					 bubble level_2_2_1_1(
                    .clk(clk),
                    .resetN(resetN),
                    .startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
                    .size(3'd0),
                    .start(splits[5]),
                    .Hit(hits[11]),
                    .direction(0),
                    .startTopX(topLeftXs[5]),
                    .startTopY(topLeftYs[5]),
                    
    
                    .pixelX(pixelX),// current VGA pixel 
                    .pixelY(pixelY),
                    .split(splits[11]),
                    .RGBout(RGBouts[11]),//optional color output for mux 
                    .drawingRequest(drawingRequests[11]) // indicates pixel inside the bracket
                    );
				   bubble level_2_2_1_2(
                    .clk(clk),
                    .resetN(resetN),
                    .startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
                    .size(3'd0),
                    .start(splits[5]),
                    .Hit(hits[12]),
                    .direction(1),
                    .startTopX(topLeftXs[5]),
                    .startTopY(topLeftYs[5]),
                    
    
                    .pixelX(pixelX),// current VGA pixel 
                    .pixelY(pixelY),
                    .split(splits[12]),
                    .RGBout(RGBouts[12]),//optional color output for mux 
                    .drawingRequest(drawingRequests[12]) // indicates pixel inside the bracket
                    );
						  
					//connected to bubble 6
					
					  bubble level_2_2_2_1(
                    .clk(clk),
                    .resetN(resetN),
                    .startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
                    .size(3'd0),
                    .start(splits[6]),
                    .Hit(hits[13]),
                    .direction(1),
                    .startTopX(topLeftXs[6]),
                    .startTopY(topLeftYs[6]),
                    
    
                    .pixelX(pixelX),// current VGA pixel 
                    .pixelY(pixelY),
                    .split(splits[13]),
                    .RGBout(RGBouts[13]),//optional color output for mux 
                    .drawingRequest(drawingRequests[13]) // indicates pixel inside the bracket
                    );
						  
					  bubble level_2_2_2_2(
                    .clk(clk),
                    .resetN(resetN),
                    .startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
                    .size(3'd0),
                    .start(splits[6]),
                    .Hit(hits[14]),
                    .direction(0),
                    .startTopX(topLeftXs[6]),
                    .startTopY(topLeftYs[6]),
                    
    
                    .pixelX(pixelX),// current VGA pixel 
                    .pixelY(pixelY),
                    .split(splits[14]),
                    .RGBout(RGBouts[14]),//optional color output for mux 
                    .drawingRequest(drawingRequests[14]) // indicates pixel inside the bracket
                    );
		  
    assign drawingRequest = (drawingRequests[0] || drawingRequests[1] || drawingRequests[2] || drawingRequests[3] || drawingRequests[4] || drawingRequests[5]
          || drawingRequests[6]) || (drawingRequests[7] || drawingRequests[8] || drawingRequests[9] || drawingRequests[10] || drawingRequests[11] || drawingRequests[12]
          || drawingRequests[13] || drawingRequests[14]);

    always_comb begin
        //defaults
        RGBout = 8'hFF;
        hits = 15'd0;
    
        if (drawingRequests[0]) begin
            RGBout = RGBouts[0];
            if (arrowHit)
                hits[0] = 1;
        end
        else if (drawingRequests[1]) begin
            RGBout = RGBouts[1];
            if (arrowHit)
                hits[1] = 1;
        end
        else if (drawingRequests[2]) begin
            RGBout = RGBouts[2];
            if (arrowHit)
                hits[2] = 1;
        end
        else if (drawingRequests[3]) begin
            RGBout = RGBouts[3];
            if (arrowHit)
                hits[3] = 1;
        end
        else if (drawingRequests[4]) begin
            RGBout = RGBouts[4];
            if (arrowHit)
                hits[4] = 1;
        end
        else if (drawingRequests[5]) begin
            RGBout = RGBouts[5];
            if (arrowHit)
                hits[5] = 1;
        end
        else if (drawingRequests[6]) begin
            RGBout = RGBouts[6];
            if (arrowHit)
                hits[6] = 1;
        end
		  if (drawingRequests[7]) begin
            RGBout = RGBouts[7];
            if (arrowHit)
                hits[7] = 1;
        end
        else if (drawingRequests[8]) begin
            RGBout = RGBouts[8];
            if (arrowHit)
                hits[8] = 1;
        end
        else if (drawingRequests[9]) begin
            RGBout = RGBouts[9];
            if (arrowHit)
                hits[9] = 1;
        end
        else if (drawingRequests[10]) begin
            RGBout = RGBouts[10];
            if (arrowHit)
                hits[10] = 1;
        end
        else if (drawingRequests[11]) begin
            RGBout = RGBouts[11];
            if (arrowHit)
                hits[11] = 1;
        end
        else if (drawingRequests[12]) begin
            RGBout = RGBouts[12];
            if (arrowHit)
                hits[12] = 1;
        end
		  else if (drawingRequests[13]) begin
            RGBout = RGBouts[13];
            if (arrowHit)
                hits[13] = 1;
        end
	     else if (drawingRequests[14]) begin
            RGBout = RGBouts[14];
            if (arrowHit)
                hits[14] = 1;
        end

    end
    

endmodule
