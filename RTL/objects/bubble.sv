module bubble
    (
        input		logic	clk,
        input		logic	 resetN,
        
        //bubble move
        input		logic	 startOfFrame,  // short pulse every start of frame 30Hz 
        input 		logic [2:0]  size,
        input		logic 	start,
        input		logic 	 Hit,
        input		logic 	 direction,
        input		logic [10:0] startTopX,
        input		logic [10:0] startTopY,
        
        //square
        input 	logic	[10:0] pixelX,// current VGA pixel 
        input 	logic	[10:0] pixelY,
		
		
        output	logic	[10:0]	topLeftX,// output the top left corner 
        output	logic	[10:0]	topLeftY,
        output	logic 		split,
        output  logic	[2:0]	size_out,
        output	logic	[7:0]	 RGBout, //optional color output for mux 
        output	logic	drawingRequest // indicates pixel inside the bracket
    );  
    
        logic	[10:0] offsetX;// offset inside bracket from top left position 
        logic	[10:0] offsetY;
        logic   inSqure;
    
    bubble_move bubble_move_inst(.clk(clk), 
                            .resetN(resetN), 
                            .startOfFrame(startOfFrame), 
                            .size(size), 
                            .start(start), 
                            .Hit(Hit), 
                            .direction(direction),
                            .startTopX(startTopX),
                            .startTopY(startTopY),
                                   
                            .topLeftX(topLeftX),
                            .topLeftY(topLeftY),
                            .split(split)
                            );
    adj_size_square_object adj_squre(.clk(clk),
                            .resetN(resetN),
                            .pixelX(pixelX),// current VGA pixel 
									 .pixelY(pixelY),
                            .topLeftX(topLeftX), //position on the screen 
                            .topLeftY(topLeftY),
                            .size(size), //set the size in *2 steps (signed integer)
					
					
                            .offsetX(offsetX),// offset inside bracket from top left position 
                            .offsetY(offsetY),
                            .drawingRequest(inSquare)// indicates pixel inside the bracket
                                    );
   ballBitMap bitmap(.clk(clk),
                     .resetN(resetN),
                     .offsetX(offsetX),// offset from top left  position 
                     .offsetY(offsetY),
                     .InsideRectangle(inSquare), //input that the pixel is within a bracket 
                     .size(size),

                     .drawingRequest(drawingRequest), //output that the pixel should be dispalyed 
                     .RGBout(RGBout)
                     ); 
 

endmodule
