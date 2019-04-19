
module	back_ground_draw_blue	(	  

					input	logic	clk,
					input	logic	resetN,
					input 	logic	[10:0]	pixelX,
					input 	logic	[10:0]	pixelY,

					output	logic	[7:0]	BG_RGB
);

const int	xFrameSize	=	639;
const int	yFrameSize	=	479;
const int	bracketOffset =	10;

logic [2:0] redBits;
logic [2:0] greenBits;
logic [1:0] blueBits;

localparam logic [2:0] DARK_COLOR = 3'b111 ;// bitmap of a dark color
localparam logic [2:0] LIGHT_COLOR = 3'b000 ;// bitmap of a light color

assign BG_RGB =  {redBits , greenBits , blueBits} ; //collect color nibbles to an 8 bit word 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
				redBits <= DARK_COLOR ;	
				greenBits <= DARK_COLOR  ;	
				blueBits <= DARK_COLOR ;	 
	end 
	else begin
	
	// defaults 
		greenBits <= 3'b110 ; 
		redBits <= 3'b010 ;
		blueBits <= LIGHT_COLOR;
					
	// draw the yellow borders 
		if (pixelX == 0 || pixelY == 0  || pixelX == xFrameSize || pixelY == yFrameSize)
			begin 
				redBits <= DARK_COLOR ;	
				greenBits <= DARK_COLOR ;	
				blueBits <= LIGHT_COLOR ;	// 3rd bit will be truncked
			end	
		else begin
				redBits <= LIGHT_COLOR ;	
				greenBits <= LIGHT_COLOR ;	
				blueBits <= DARK_COLOR ;	// 3rd bit will be truncked
		
		end
		
	end 	
end 

endmodule

