//border crash logic
//will alert respective objects moving logic when draw request happans on border

module border_crash
	(
		input logic charDrawingRequest,
		input logic	[10:0]	pixelX, //char draw location
		input	logic	[10:0]	pixelY,
		input logic arrowDrawingRequest,
		input logic bubbleDrawingRequest,
		
		output logic charCrashLeft,
		output logic charCrashRight,
		output logic arrowHitTop,
		output logic bubbleHitChar,
		output logic arrowHitBubble
	);
	
	const int	x_FRAME_SIZE	=	639;
	const int	y_FRAME_SIZE	=	479;
	
	always_comb
	begin 
		//defaults 
		charCrashLeft = 0;
		charCrashRight = 0;
		arrowHitTop = 0;
		bubbleHitChar = 0;
		arrowHitBubble = 0;
		
		
		if (arrowDrawingRequest) begin
			if (pixelY == 0)
				arrowHitTop = 1;
			if (bubbleDrawingRequest)
				arrowHitBubble = 1;
			
		end
				
		

	end
endmodule 
