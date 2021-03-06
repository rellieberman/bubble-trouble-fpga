module ballBitMap
    (
        input	logic	clk,
        input	logic	resetN,
        input   logic	[10:0] offsetX,// offset from top left  position 
        input   logic	[10:0] offsetY,
        input	logic	InsideRectangle, //input that the pixel is within a bracket 
        input   logic   [2:0] size,

        output	logic	drawingRequest, //output that the pixel should be dispalyed 
        output	logic	[7:0] RGBout  //rgb value from the bitmap 
    );

        localparam  int OBJECT_WIDTH_X = 32;
        localparam  int OBJECT_HEIGHT_Y = 32;
        
        localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

		  int real_offsetX;
		  int real_offsetY;
		  
        logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
        {8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h88, 8'h88, 8'hA8, 8'h88, 8'hAC, 8'hAC, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
        {8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h88, 8'h68, 8'h69, 8'h8D, 8'hAD, 8'hAD, 8'hD1, 8'hB1, 8'hB1, 8'hB1, 8'hD1, 8'hAD, 8'h69, 8'h48, 8'h69, 8'hAD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
        {8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hD1, 8'hD1, 8'hD1, 8'hB1, 8'hAC, 8'hD1, 8'hB1, 8'hB1, 8'h8D, 8'h88, 8'h44, 8'h00, 8'h00, 8'h20, 8'h68, 8'h88, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
        {8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h8D, 8'h68, 8'h48, 8'h8C, 8'hB1, 8'hB1, 8'hD1, 8'hB1, 8'hB1, 8'hB1, 8'hD1, 8'hB1, 8'hAD, 8'hA8, 8'hAC, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h44, 8'h88, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
        {8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h8D, 8'h44, 8'h00, 8'h00, 8'h8C, 8'h8D, 8'h8C, 8'h8D, 8'hB1, 8'hAD, 8'hA8, 8'hA8, 8'hAC, 8'hAD, 8'h00, 8'h00, 8'h44, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h44, 8'h68, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
        {8'hFF, 8'hFF, 8'hFF, 8'h88, 8'h44, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h44, 8'hAC, 8'h88, 8'h88, 8'hAD, 8'hB1, 8'h69, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h44, 8'hAC, 8'hFF, 8'hFF, 8'hFF },
        {8'hFF, 8'hFF, 8'h88, 8'h48, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8C, 8'h8C, 8'hD1, 8'hD1, 8'hD1, 8'hB1, 8'hB1, 8'h44, 8'h8C, 8'h8C, 8'h8C, 8'h20, 8'h68, 8'h00, 8'h00, 8'h44, 8'h88, 8'h88, 8'hFF, 8'hFF },
        {8'hFF, 8'hFF, 8'hAC, 8'h88, 8'hAC, 8'hAC, 8'h44, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hB1, 8'hB1, 8'hD1, 8'hD1, 8'hD1, 8'hB1, 8'hB1, 8'hD1, 8'hD1, 8'hD1, 8'hB1, 8'hB1, 8'hAD, 8'hB1, 8'hAD, 8'hFF, 8'hFF },
        {8'hFF, 8'h88, 8'h20, 8'h00, 8'h44, 8'h00, 8'h00, 8'h00, 8'hB1, 8'h8C, 8'h68, 8'h8C, 8'h8C, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hB1, 8'hB1, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hB1, 8'hAC, 8'hFF },
        {8'hFF, 8'h8D, 8'h00, 8'h8D, 8'h8D, 8'h00, 8'h00, 8'h24, 8'hB1, 8'hB1, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hB1, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hB1, 8'h48, 8'h69, 8'h8D, 8'hB1, 8'hB1, 8'hD1, 8'hB1, 8'hAC, 8'hAC, 8'hFF },
        {8'h8C, 8'h24, 8'h8D, 8'h8C, 8'h00, 8'h44, 8'h69, 8'h8D, 8'hAC, 8'hAC, 8'hB1, 8'h8D, 8'hAD, 8'hB1, 8'h8C, 8'h89, 8'hB1, 8'hD1, 8'hB1, 8'hD1, 8'hB1, 8'h44, 8'h00, 8'h20, 8'h24, 8'h8D, 8'hAD, 8'hB1, 8'hAD, 8'hAC, 8'hAC, 8'hAC },
        {8'h8D, 8'h00, 8'h00, 8'h00, 8'h8D, 8'h8D, 8'hAD, 8'h69, 8'h69, 8'hAD, 8'hAD, 8'h8D, 8'h44, 8'h68, 8'h8C, 8'h8D, 8'hD1, 8'hD1, 8'hB1, 8'hB1, 8'h8D, 8'h00, 8'h00, 8'h00, 8'hA8, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'hA8 },
        {8'hD1, 8'hB1, 8'hAD, 8'h44, 8'h8D, 8'h8D, 8'h69, 8'h00, 8'h88, 8'hA8, 8'hA8, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'hAD, 8'hAD, 8'hAC, 8'hB1, 8'h69, 8'h00, 8'hA8, 8'hA8, 8'h00, 8'h88, 8'h88, 8'h00, 8'h44, 8'h00, 8'h00, 8'h8C },
        {8'hAC, 8'hAD, 8'hA8, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'hA8, 8'hA8, 8'hA8, 8'hA8, 8'hA8, 8'h88, 8'h88, 8'h88, 8'hAC, 8'hA8, 8'hA8, 8'hA8, 8'h8D, 8'h00, 8'h00, 8'h00, 8'h00, 8'h44, 8'h00, 8'h44, 8'h00, 8'h00, 8'h00, 8'h88 },
        {8'h88, 8'h88, 8'h88, 8'h88, 8'hA8, 8'h88, 8'hA8, 8'hA8, 8'h88, 8'hA8, 8'hA8, 8'h88, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hD1, 8'hAC, 8'h88, 8'hA8, 8'hAC, 8'h44, 8'h44, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h44, 8'h44, 8'h24 },
        {8'hAC, 8'h69, 8'h00, 8'h00, 8'h24, 8'h8D, 8'h8D, 8'h48, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h44, 8'h88, 8'h00, 8'hAD, 8'hD1, 8'hB1, 8'hB1, 8'hB1, 8'hD1, 8'hAD, 8'h8C, 8'h24, 8'hAD, 8'h00, 8'h00, 8'h8C, 8'h00, 8'h8C, 8'hD1 },
        {8'hB1, 8'h89, 8'hAC, 8'hA8, 8'h44, 8'h24, 8'h8D, 8'hAD, 8'h24, 8'h00, 8'h00, 8'h44, 8'h44, 8'h44, 8'h6D, 8'h8D, 8'hAC, 8'hB1, 8'hB1, 8'hB1, 8'hD1, 8'hB1, 8'hD1, 8'hB1, 8'hB1, 8'hAD, 8'h69, 8'h49, 8'h69, 8'h8D, 8'hAD, 8'h49 },
        {8'hB1, 8'h8D, 8'h24, 8'h00, 8'h00, 8'h00, 8'h44, 8'hAC, 8'hAC, 8'h88, 8'h24, 8'hB1, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hB1, 8'hD1, 8'hD1, 8'hD1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hAD },
        {8'h8D, 8'h8D, 8'h69, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h44, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1 },
        {8'h8D, 8'h89, 8'h8D, 8'h69, 8'h00, 8'h00, 8'h00, 8'h00, 8'h44, 8'h44, 8'h69, 8'hB1, 8'hD1, 8'hD1, 8'hAC, 8'hB1, 8'h88, 8'h88, 8'hA8, 8'hA8, 8'hA8, 8'h8C, 8'h8D, 8'hB1, 8'hAD, 8'hAD, 8'hB1, 8'hAD, 8'h8D, 8'hAD, 8'hAD, 8'hAD },
        {8'h88, 8'hA8, 8'hAD, 8'hAD, 8'h69, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'hAD, 8'hB1, 8'hB1, 8'hD1, 8'hB1, 8'hAD, 8'h69, 8'h44, 8'h44, 8'h8C, 8'h68, 8'hD1, 8'hD1, 8'hD1, 8'hAD, 8'hD1, 8'hB1, 8'hB1, 8'hB1, 8'hD1, 8'hD1, 8'hD1 },
        {8'h88, 8'h48, 8'hAD, 8'hAD, 8'hAD, 8'h8D, 8'h44, 8'h24, 8'h24, 8'h24, 8'hAD, 8'hD1, 8'hB1, 8'hB1, 8'h8D, 8'h24, 8'h00, 8'h00, 8'h00, 8'h8D, 8'h68, 8'h00, 8'h00, 8'h00, 8'h45, 8'h8D, 8'hAD, 8'hB1, 8'hB1, 8'hB1, 8'hD1, 8'hD1 },
        {8'hFF, 8'h68, 8'h8D, 8'hB1, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hB1, 8'hD1, 8'hAD, 8'hD1, 8'hD1, 8'hB1, 8'h49, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hAD, 8'hAD, 8'hB1, 8'hB1, 8'h8D, 8'hFF },
        {8'hFF, 8'h8D, 8'h8D, 8'hD1, 8'hD1, 8'hF6, 8'hD1, 8'hD5, 8'hD5, 8'hD1, 8'hAD, 8'hB1, 8'hD1, 8'hB1, 8'h44, 8'h44, 8'hAC, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hAD, 8'hAD, 8'hA8, 8'hA8, 8'hFF },
        {8'hFF, 8'hFF, 8'hAC, 8'hD1, 8'hD5, 8'hD1, 8'hF5, 8'hD1, 8'hD1, 8'hD1, 8'hB1, 8'hB1, 8'hB1, 8'hD1, 8'h44, 8'h00, 8'h00, 8'h00, 8'h68, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'h8D, 8'h8D, 8'hAD, 8'hFF, 8'hFF },
        {8'hFF, 8'hFF, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hD6, 8'hD1, 8'hD1, 8'hD1, 8'hAD, 8'hB1, 8'hB1, 8'hB1, 8'hAD, 8'h68, 8'hD1, 8'hB1, 8'h8D, 8'hAC, 8'h8D, 8'h00, 8'h00, 8'h00, 8'h00, 8'h68, 8'h20, 8'hAD, 8'hAD, 8'hA8, 8'hFF, 8'hFF },
        {8'hFF, 8'hFF, 8'hFF, 8'h8D, 8'hD1, 8'hD6, 8'hD1, 8'hD1, 8'hAC, 8'hA8, 8'hAC, 8'h44, 8'hAD, 8'hAC, 8'hB1, 8'hAD, 8'h8C, 8'h8C, 8'h8C, 8'h8D, 8'h44, 8'h44, 8'hAC, 8'hAC, 8'h88, 8'h88, 8'h88, 8'h88, 8'hA8, 8'hFF, 8'hFF, 8'hFF },
        {8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'hB1, 8'hB1, 8'h69, 8'h8C, 8'h00, 8'h00, 8'h00, 8'h44, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hB1, 8'hAD, 8'h44, 8'hAC, 8'hAC, 8'hAC, 8'hAC, 8'hAC, 8'hAC, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
        {8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'hAD, 8'h8C, 8'h00, 8'h44, 8'hAC, 8'h00, 8'h00, 8'h8D, 8'hB1, 8'hD1, 8'hD1, 8'hB1, 8'hB1, 8'hD1, 8'hAD, 8'h00, 8'h44, 8'hAC, 8'hA8, 8'hA8, 8'h88, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
        {8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'h68, 8'h00, 8'h00, 8'hAC, 8'hAD, 8'hB1, 8'hB1, 8'hAD, 8'hAD, 8'h69, 8'h20, 8'h00, 8'h44, 8'h20, 8'h88, 8'h8C, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
        {8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAC, 8'h68, 8'h68, 8'h00, 8'h00, 8'h44, 8'hB1, 8'hB1, 8'hB1, 8'h8D, 8'h8D, 8'h8C, 8'h8C, 8'h24, 8'h68, 8'h88, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
        {8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'h68, 8'hA8, 8'hAC, 8'hA8, 8'h88, 8'hA8, 8'h88, 8'h88, 8'hA8, 8'h88, 8'hA8, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
        };

        
        // pipeline (ff) to get the pixel color from the array 	 

        always_ff@(posedge clk or negedge resetN)
        begin
            if(!resetN) begin
                RGBout <=	8'h00;
            end
            else begin
                if (InsideRectangle)  // inside an external bracket 
                        RGBout <= object_colors[real_offsetY][real_offsetX];	//get RGB from the colors table  

                else 
                    RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
            end 
        end

        // decide if to draw the pixel or not 
        assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap  
		  
		  always_comb begin
				if (size == 3'b000) begin
					real_offsetX = offsetX << 2;
					real_offsetY = offsetY << 2;
				end
				else if (size == 3'b001) begin
					real_offsetX = offsetX << 1;
					real_offsetY = offsetY << 1;
				end
				else if (size == 3'b010) begin
					real_offsetX = offsetX;
					real_offsetY = offsetY;
				end
				else if(size == 3'b011) begin
					real_offsetX = offsetX >> 1;
					real_offsetY = offsetY >> 1;
				end
				else begin
					real_offsetX = offsetX;
					real_offsetY = offsetY;
				end
					
		  end


endmodule
