localparam  int OBJECT_WIDTH_X = 32;
localparam  int OBJECT_HEIGHT_Y = 20;

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'h00, 8'h00, 8'h04, 8'h05, 8'h49, 8'h89, 8'hA9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hA9, 8'h89, 8'h65, 8'h44, 8'h00, 8'h04, 8'h05, 8'h05, },
{8'h00, 8'h05, 8'h44, 8'hA9, 8'hE9, 8'hE9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hED, 8'hED, 8'hC9, 8'hA9, 8'h44, 8'h05, 8'h00, },
{8'h04, 8'h49, 8'hA4, 8'hA9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hA9, 8'hA4, 8'h45, 8'h00, },
{8'h29, 8'hA9, 8'hC0, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC0, 8'hA9, 8'h25, },
{8'h69, 8'hC9, 8'hC9, 8'hCD, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hA9, 8'hC9, 8'h49, },
{8'h69, 8'hE9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hED, 8'h65, },
{8'h49, 8'hE9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hED, 8'h45, },
{8'h24, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'h24, },
{8'h00, 8'hA9, 8'hE9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hE9, 8'h89, 8'h00, },
{8'h00, 8'h49, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hA9, 8'hA9, 8'hA9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'h29, 8'h00, },
{8'h00, 8'h04, 8'h49, 8'hC9, 8'hED, 8'hED, 8'h89, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h89, 8'hED, 8'hE9, 8'hC9, 8'h49, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h04, 8'h29, 8'hA9, 8'hC9, 8'h44, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h44, 8'hA9, 8'h89, 8'h24, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h00, 8'h25, 8'h24, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h24, 8'h04, 8'h00, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h00, 8'h24, 8'h24, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h24, 8'h04, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h04, 8'h00, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h09, 8'h04, 8'h00, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h29, 8'h04, 8'h00, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h29, 8'h04, 8'h00, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h05, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h25, 8'h25, 8'h24, 8'h25, 8'h25, 8'h25, 8'h24, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h00, 8'h04, 8'h25, 8'h25, 8'h25, 8'h24, 8'h25, 8'h25, 8'h25, 8'h24, 8'h25, 8'h25, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h00, 8'h05, 8'h25, 8'h25, 8'h25, 8'h24, 8'h25, 8'h25, 8'h25, 8'h24, 8'h24, 8'h25, 8'h25, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h04, 8'h25, 8'h25, 8'h25, 8'h24, 8'h24, 8'h25, 8'h25, 8'h25, 8'h24, 8'h24, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h05, 8'h25, 8'h25, 8'h25, 8'h24, 8'h24, 8'h25, 8'h25, 8'h25, 8'h24, 8'h24, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h04, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h25, 8'h25, 8'h25, 8'h04, 8'h00, 8'h00, 8'h00, },
{8'h04, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h24, 8'h25, 8'h25, 8'h25, 8'h00, 8'h00, 8'h00, },
{8'h00, 8'h00, 8'h25, 8'h24, 8'h25, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h24, 8'h68, 8'h48, 8'h09, 8'h00, 8'h00, },
{8'h00, 8'h29, 8'h8C, 8'hB0, 8'h8C, 8'h68, 8'h68, 8'h68, 8'h68, 8'h29, 8'h29, 8'h68, 8'h68, 8'h68, 8'hAC, 8'hD0, 8'hD0, 8'hB0, 8'h29, 8'h00, },
{8'h00, 8'h68, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h49, 8'h29, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h8C, 8'h04, }
};

wire [7:0] red_sig, green_sig, blue_sig;
assign red_sig     = {object_colors[offsetY][offsetX][7:5] , 5'd0};
assign green_sig   = {object_colors[offsetY][offsetX][4:2] , 5'd0};
assign blue_sig    = {object_colors[offsetY][offsetX][1:0] , 6'd0};


