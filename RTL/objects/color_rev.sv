module color_rev
(
	input logic [7:0] color,
	
	output logic [7:0] reversed
);


	assign reversed = 8'hFF - color;

endmodule