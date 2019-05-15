module winBitMap
    (
        input	logic	clk,
        input	logic	resetN,
        input   logic	[10:0] offsetX,// offset from top left  position 
        input   logic	[10:0] offsetY,
        input	logic	InsideRectangle, //input that the pixel is within a bracket 
		  input	logic [1:0] message,

        output	logic	drawingRequest, //output that the pixel should be dispalyed 
        output	logic	[7:0] RGBout  //rgb value from the bitmap 
    );  
  
        localparam logic TRANSPARENT_ENCODING = 8'h00;// RGB value in the bitmap representing a transparent pixel 
            
        localparam  int OBJECT_WIDTH_X = 12;
        localparam  int OBJECT_HEIGHT_Y = 70;

        bit [0:12-1] [0:69] object_colors = {
        70'b1111111111111111111111111111111111111111111111111111111111111111111111,
        70'b1111111111111111111111111111111111111111111111111111111111111111111111,
        70'b1111111111111111111111111111111111111111111111111111111111111111111111,
        70'b1111110011000110000011100110001111110011111001100001100111100111001111,
        70'b1111110011000100111001000110001111110011111001110011100111100111001111,
        70'b1111110011000100111001000110001111110011111001110011100011100111001111,
        70'b1111111000011100111001000110001111110011111001110011100000100111011111,
        70'b1111111100111100111001000110001111110010001001110011100110000111011111,
        70'b1111111100111100011001100110011111110011001001110001100111000111111111,
        70'b1111111100111111000011110000111111111001110011100001100111100111001111,
        70'b1111111111111111111111111111111111111111111111111111111111111111111111,
        70'b1111111111111111111111111111111111111111111111111111111111111111111111
        };
  
        
    


        
        always_ff@(posedge clk or negedge resetN)
        begin
            if(!resetN) begin
                RGBout <=	8'h00;
            end
            else begin
                if (InsideRectangle && !object_colors[offsetY>>2][offsetX>>2] )  // inside an external bracket 
                    RGBout <= 8'hFF; //black 
                else 
                    RGBout <= TRANSPARENT_ENCODING; // force color to transparent so it will not be displayed 
            end 
        end
        
     assign drawingRequest = ((RGBout != TRANSPARENT_ENCODING) && (message == 2'b01)) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap  


endmodule
