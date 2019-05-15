module gameoverMap
    (
        input	logic	clk,
        input	logic	resetN,
        input   logic	[10:0] offsetX,// offset from top left  position 
        input   logic	[10:0] offsetY,
        input	logic	InsideRectangle, //input that the pixel is within a bracket 

        output	logic	drawingRequest, //output that the pixel should be dispalyed 
        output	logic	[7:0] RGBout  //rgb value from the bitmap 
    );
    
        localparam logic TRANSPARENT_ENCODING = 8'h00;// RGB value in the bitmap representing a transparent pixel 
          
        localparam  int OBJECT_WIDTH_X = 12;
        localparam  int OBJECT_HEIGHT_Y = 70;

        logic [0:OBJECT_HEIGHT_Y-1] [1*70-1:0] object_colors = {
        {70'b0000000000000000000000000000000000000000000000000000000000000000000000},
        {70'b0000000000000000000000000000000000000000000000000000000000000000000000},
        {70'b0000000000000000000000000000000000000000000000000000000000000000000000},
        {70'b0001111111011111001111111011111110000011111101100001011111110111111000},
        {70'b0001000000010001001001001010000000000010001101100001010000000100001000},
        {70'b0001000000011001101001001010000000000010000101100001010000000100011000},
        {70'b0001100010011111101101101011111110000010000101100001011111110111111100},
        {70'b0001100011010000101101101011000000000010000100100011011000000110000100},
        {70'b0001100011010000101101101011000000000010000100100010011000000110000100},
        {70'b0001111110010000101101101011111110000011111100111110011111110110000100},
        {70'b0000000000000000000000000000000000000000000000000000000000000000000000},
        {70'b0000000000000000000000000000000000000000000000000000000000000000000000}
        };

                
        always_ff@(posedge clk or negedge resetN)
        begin
            if(!resetN) begin
                RGBout <= 8'h00;
            end
            else begin
                if (InsideRectangle && object_colors[offsetY>>1][offsetX>>1] )  // inside an external bracket 
                    RGBout <= 8'hFF; //black 
                else 
                    RGBout <= TRANSPARENT_ENCODING; // force color to transparent so it will not be displayed 
            end 
        end
        
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap  


endmodule
