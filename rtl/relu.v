/**************************************
@ filename    : relu.v
@ author      : https://github.com/djtfoo/lenet5-verilog
@ update      : yyrwkk
@ create time : 2024/11/13 16:31:39
@ version     : v1.0.0
**************************************/
module relu # (
    parameter BIT_WIDTH = 32               
)(
	input  signed[BIT_WIDTH-1:0] in  ,
	output signed[BIT_WIDTH-1:0] out
);

// check MSB = 1 (-ve)
assign out = (in[BIT_WIDTH-1]) ? 'b0 : in;

endmodule
