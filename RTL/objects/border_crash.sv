//border crash logic
//will alert respective objects moving logic when draw request happans on border

module border_crash
	(
		input logic charDrawingRequest,
		input logic	[10:0]	pixelX, //char draw location
		input	logic	[10:0]	pixelY,
		input logic arrowDrawingRequest,
		input logic bubbleDrawingRequest,
		
		output logic bubbleHitChar,
		output logic arrowHitBubble
	);
	
	const int	x_FRAME_SIZE	=	639;
	const int	y_FRAME_SIZE	=	479;
	
	always_comb
	begin 
		//defaults 
		
		bubbleHitChar = 0;
		arrowHitBubble = 0;
		
		
		if (arrowDrawingRequest) begin
			if (bubbleDrawingRequest) begin
				arrowHitBubble = 1;
			end
		end
		if (bubbleDrawingRequest) begin
			if (charDrawingRequest) begin
				arrowHitBubble = 1;
				bubbleHitChar = 1;
			end
				 
		end
		
				
		

	end
endmodule 
