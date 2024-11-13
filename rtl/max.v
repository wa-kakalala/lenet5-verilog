/**************************************
@ filename    : max.v
@ author      : https://github.com/djtfoo/lenet5-verilog
@ update      : yyrwkk
@ create time : 2024/11/13 17:24:27
@ version     : v1.0.0
**************************************/
module max #(
    parameter BIT_WIDTH = 8
)(
	input  signed[BIT_WIDTH-1:0] in1 ,
    input  signed[BIT_WIDTH-1:0] in2 ,
	output signed[BIT_WIDTH-1:0] max 
);

// signed comparison
assign max = (in1 > in2) ? in1 : in2;

endmodule
