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
    logic [2:0] starts;
    logic [7:0] hits;
    logic [7:0] drawingRequests;
    logic [7:0] splits;
    logic [10:0] [7:0] RGBouts;
	 
	 int bubbles_hit;
	 int nxt_bubble;
    
    logic [7:0] [10:0] topLeftXs;
    logic [7:0] [10:0] topLeftYs;
    
    parameter [10:0] INITIAL_X = 200;
    parameter [10:0] INITIAL_Y = 50;
    parameter [2:0] SIZE = 3'd3;
	 
	 enum logic {hit, nohit} cur_st, nxt_st;
	 
	 
	 always_ff@(posedge clk or negedge resetN) begin
		if (!resetN) begin
			bubbles_hit <= 8;
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
		
                    .split(splits[6]),
                    .RGBout(RGBouts[6]),//optional color output for mux 
                    .drawingRequest(drawingRequests[6]) // indicates pixel inside the bracket
                    );
        
        
    assign drawingRequest = (drawingRequests[0] || drawingRequests[1] || drawingRequests[2] || drawingRequests[3] || drawingRequests[4] || drawingRequests[5]
          || drawingRequests[6]);

    always_comb begin
        //defaults
        RGBout = 8'hFF;
        hits = 4'b0000;
    
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
                hits[03] = 1;
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

    end
    

endmodule
