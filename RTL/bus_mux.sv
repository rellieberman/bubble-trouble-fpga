module bus_mux
(
	input logic [7:0] dat1,
	input logic [7:0] dat2,
	input logic [7:0] dat3,
	
	input logic [1:0] sel,
	
	output logic [7:0] out
);

	always_comb begin
		case (sel)
			
			2'b00 : out = dat1;
			2'b01 : out = dat2;
			2'b10 : out = dat3;
			
			default out = 8'h00;
		
		endcase
	
	end 

endmodule 