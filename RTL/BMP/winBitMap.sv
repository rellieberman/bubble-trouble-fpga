module winBitMap
    (
        input	logic	clk,
        input	logic	resetN,
        input   logic	[10:0] offsetX,// offset from top left  position 
        input   logic	[10:0] offsetY,
        input	logic	InsideRectangle, //input that the pixel is within a bracket 

        output	logic	drawingRequest, //output that the pixel should be dispalyed 
        output	logic	[7:0] RGBout  //rgb value from the bitmap 
    );  
  
        localparam  int OBJECT_WIDTH_X = 20;
        localparam  int OBJECT_HEIGHT_Y = 50;
        
        localparam logic [7:0] TRANSPARENT_ENCODING = 8'h00;// RGB value in the bitmap representing a transparent pixel 

        logic [0:OBJECT_HEIGHT_Y-1] [1*50-1:0] object_colors = {
        {50'b11111111111111111111111111111111111111111111111111},
        {50'b11111111111111111111111111111111111111111111111111},
        {50'b11111111111111111111111111111111111111111111111111},
        {50'b11111111111111111111111111111111111111111111111111},
        {50'b11111111111111111111111111111111111111111111111111},
        {50'b11110111011000110111011111011110110001011100110111},
        {50'b11110010011000110010011111011110110001011100100111},
        {50'b11110010010010010011011111011110110011011100110111},
        {50'b11110010010010010011011111011110110011001100110111},
        {50'b11110010010010010011011111011110110011001100110111},
        {50'b11111000110010010011011111011110110011000100101111},
        {50'b11111100110010010011011111011110110011000000101111},
        {50'b11111101110010010011011111010010110011010000111111},
        {50'b11111101110010010011011111010010110011011000111111},
        {50'b11111101111010011010011111001100110011011100111111},
        {50'b11111101111000111000111111001101100001011100110111},
        {50'b11111111111111111111111111111111111111111111111111},
        {50'b11111111111111111111111111111111111111111111111111},
        {50'b11111111111111111111111111111111111111111111111111},
        {50'b11111111111111111111111111111111111111111111111111}
        };

        
        always_ff@(posedge clk or negedge resetN)
        begin
            if(!resetN) begin
                RGBout <=	8'h00;
            end
            else begin
                if (InsideRectangle && !object_colors[offsetY][offsetX] )  // inside an external bracket 
                    RGBout <= 8'hFF; //black 
                else 
                    RGBout <= TRANSPARENT_ENCODING; // force color to transparent so it will not be displayed 
            end 
        end
        
     assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap  


endmodule
