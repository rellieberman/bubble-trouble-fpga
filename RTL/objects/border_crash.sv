//border crash logic
//will alert respective objects moving logic when draw request happans on border

module border_crash
	(
		input logic charDrawingRequest,
		input logic	[10:0]	charX, //char draw location
		input	logic	[10:0]	charY,
		input logic arrowDrawingRequest,
		input logic	[10:0]	arrowX, //arrow draw location
		input	logic	[10:0]	arrowY,
		input logic bubbleDrawingRequet,
		input logic	[10:0]	bubbleX, //bubble draw location
		input	logic	[10:0]	bubbleY,
		
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
		arrowCrash = 0;
		bubbleCrash = 0;
		
		if (charDrawingRequest)
		begin
			if (charX == 0)
				charCrashLeft = 1;
			if (charX == x_FRAME_SIZE)
				charCrashRight = 1;
		end
		
		if (arrowDrawingRequest) begin
			if (arrowY = 0)
				arrowHitTop = 1;
			if (bubbleDrawingRequest)
				arrowHitBubble = 1;
			
			end
				
		
		end

	end
endmodule 
