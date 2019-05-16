module hartBitMap
    (
        input	logic	clk,
        input	logic	resetN,
        input   logic	[10:0] offsetX,// offset from top left  position 
        input   logic	[10:0] offsetY,
        input	logic	InsideRectangle, //input that the pixel is within a bracket 

        output	logic	drawingRequest, //output that the pixel should be dispalyed 
        output	logic	[7:0] RGBout  //rgb value from the bitmap 
    );
					
				localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel
				
				localparam  int OBJECT_WIDTH_X = 32;
				localparam  int OBJECT_HEIGHT_Y = 32;

				logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h49, 8'h6D, 8'h6D, 8'h6D, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h96, 8'h49, 8'h49, 8'h49, 8'h49, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h00, 8'h00, 8'h00, 8'h00, 8'h29, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h25, 8'h64, 8'hA0, 8'hA0, 8'hA0, 8'hA0, 8'h80, 8'h24, 8'h92, 8'hFF, 8'hFF, 8'hDA, 8'h24, 8'h64, 8'hA0, 8'hA0, 8'hA0, 8'hA0, 8'h60, 8'h04, 8'h96, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'h92, 8'h20, 8'h60, 8'hE4, 8'hE4, 8'hE5, 8'hE4, 8'hA0, 8'h20, 8'h8D, 8'hDB, 8'hDA, 8'h92, 8'h20, 8'h80, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hA0, 8'h20, 8'h6D, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h25, 8'h00, 8'hC0, 8'hE4, 8'hE9, 8'hFA, 8'hFF, 8'hED, 8'hE9, 8'hE0, 8'h60, 8'h00, 8'h00, 8'h20, 8'hC0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'h40, 8'h00, 8'hDB, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hB6, 8'h6D, 8'h64, 8'h60, 8'hE4, 8'hE9, 8'hF6, 8'hF2, 8'hF2, 8'hE5, 8'hE4, 8'hE0, 8'hA0, 8'h60, 8'h60, 8'h60, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'h60, 8'h40, 8'h6D, 8'h92, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'h49, 8'h00, 8'hA0, 8'hE0, 8'hE9, 8'hF2, 8'h103, 8'hED, 8'hDC, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hC0, 8'hA0, 8'h00, 8'h49, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'h49, 8'h00, 8'hA0, 8'hE4, 8'hFA, 8'hF6, 8'hE9, 8'hE4, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hC0, 8'hA0, 8'h00, 8'h49, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'h49, 8'h00, 8'hA0, 8'hE4, 8'hFB, 8'hF6, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hC0, 8'hA0, 8'h00, 8'h49, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'h49, 8'h00, 8'hA0, 8'hE0, 8'hE9, 8'hE9, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hC0, 8'hA0, 8'h00, 8'h49, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'h49, 8'h00, 8'hA0, 8'hE0, 8'hE5, 8'hE4, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hC0, 8'hA0, 8'h00, 8'h49, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'h49, 8'h00, 8'hA0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hC0, 8'hA0, 8'h00, 8'h49, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hDB, 8'hB6, 8'h45, 8'h40, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hC0, 8'h40, 8'h20, 8'hB6, 8'hDB, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h29, 8'h20, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hC0, 8'hA0, 8'h20, 8'h00, 8'hDB, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h25, 8'h00, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hC0, 8'hC0, 8'h20, 8'h00, 8'hDB, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h49, 8'h80, 8'hA0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hA0, 8'h60, 8'h49, 8'h6D, 8'hDB, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h00, 8'h40, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hC0, 8'hC0, 8'h60, 8'h60, 8'h92, 8'h123, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h8D, 8'h20, 8'hA0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hC0, 8'hA0, 8'h20, 8'h69, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h00, 8'h80, 8'hC0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hA0, 8'h80, 8'h00, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h00, 8'hC0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hC0, 8'hA0, 8'h20, 8'h24, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h49, 8'h80, 8'hA0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hA0, 8'h60, 8'h49, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h04, 8'h20, 8'hE0, 8'hE0, 8'hE0, 8'hC0, 8'hC0, 8'hC0, 8'h40, 8'hDA, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h96, 8'h6D, 8'h40, 8'hA0, 8'hE0, 8'hC0, 8'hA0, 8'h40, 8'h69, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h00, 8'h60, 8'hC0, 8'hA0, 8'h80, 8'h00, 8'h92, 8'h123, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h6D, 8'h00, 8'h00, 8'h24, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h49, 8'h49, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
				{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
				};

		// pipeline (ff) to get the pixel color from the array 	 

        always_ff@(posedge clk or negedge resetN)
        begin
            if(!resetN) begin
                RGBout <=	8'hFF;
            end
            else begin
                if (InsideRectangle)  // inside an external bracket 
                    RGBout <= object_colors[offsetY][offsetX];	//get RGB from the colors table  
                else 
                    RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
            end 
        end

        // decide if to draw the pixel or not 
        assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap  
endmodule
