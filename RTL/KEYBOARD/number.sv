//module to input numbers
//size of output and value are to be determined by paramaters

module number
	#(	
		parameter OUTPUT_SIZE = 9,
		parameter OUTPUT_VALUE = 0
	)
	(
		output logic [OUTPUT_SIZE-1:0] number
	) ;
	
	always_comb
		number = OUTPUT_VALUE;
	
endmodule 
	