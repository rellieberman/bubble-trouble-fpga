//border crash logic
//will alert respective objects moving logic when draw request happans on border

module border_crash
	(
		input logic charDrawingRequest,
		input logic	[10:0]	pixelX, //char draw location
		input	logic	[10:0]	pixelY,
		input logic arrowDrawingRequest,
		input logic bubbleDrawingRequest,
		input logic secondArrowReq,
		input	logic secondCharReq,
		input logic lifeDrawReq,
		
		output logic bubbleHitChar_1,
		output logic bubbleHitChar_2,
		output logic arrow_1_HitBubble,
		output logic arrow_2_HitBubble,
		output logic lifeHitChar
	);
	
	const int	x_FRAME_SIZE	=	639;
	const int	y_FRAME_SIZE	=	479;
	
	always_comb
	begin 
		//defaults 
		
		bubbleHitChar_1 = 0;
		arrow_1_HitBubble = 0;
		bubbleHitChar_2 = 0;
		arrow_2_HitBubble = 0;
		lifeHitChar = 0;
		
		//first char and arrow
		if (arrowDrawingRequest) begin
			if (bubbleDrawingRequest) begin
				arrow_1_HitBubble = 1;
			end
		end
		if (bubbleDrawingRequest) begin
			if (charDrawingRequest) begin
				bubbleHitChar_1 = 1;
			end
		end
		
		//second char and arrow
		if (secondArrowReq) begin
			if (bubbleDrawingRequest) begin
				arrow_2_HitBubble = 1;
			end
		end
		if (bubbleDrawingRequest) begin
			if (secondCharReq) begin
				bubbleHitChar_2 = 1;
			end
		end
		
		if (lifeDrawReq && (charDrawingRequest || secondCharReq))
			lifeHitChar = 1;
				
		

	end
endmodule 
