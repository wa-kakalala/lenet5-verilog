/**************************************
@ filename    : conv553.v
@ author      : https://github.com/djtfoo/lenet5-verilog
@ update      : yyrwkk
@ create time : 2024/11/13 17:01:42
@ version     : v1.0.0
**************************************/
module conv553 #(
    parameter BIT_WIDTH = 8   ,
    parameter OUT_WIDTH = 32
)(
    input                                                clk      , 
    input                                                en       ,	
    input  signed[BIT_WIDTH-1:0] in01, in02, in03, in04, in05     ,
    input  signed[BIT_WIDTH-1:0] in11, in12, in13, in14, in15     ,
    input  signed[BIT_WIDTH-1:0] in21, in22, in23, in24, in25     ,
    input  signed[(BIT_WIDTH*75)-1:0]                    filter   ,	// 5x5x3 filter
    input  signed[BIT_WIDTH-1:0]                         bias     ,
    output signed[OUT_WIDTH-1:0]                         convValue	
);

wire signed[OUT_WIDTH-1:0]  conv0, conv1, conv2;

localparam SIZE = 25;	// 5x5 filter

// first feature map
conv55 # (
    .BIT_WIDTH(BIT_WIDTH), 
    .OUT_WIDTH(OUT_WIDTH)
) conv55_inst0 (
	.clk      (clk                           ), 
	.en       (en                            ),
	.in1      (in01                          ), 
    .in2      (in02                          ), 
    .in3      (in03                          ), 
    .in4      (in04                          ), 
    .in5      (in05                          ),
	.filter   ( filter[BIT_WIDTH*SIZE-1 : 0] ),
	.convValue(conv0                         )
);

// second feature map
conv55 # (
    .BIT_WIDTH(BIT_WIDTH), 
    .OUT_WIDTH(OUT_WIDTH)
) conv55_inst1 (
	.clk      (clk                                            ), 
	.en       (en                                             ),
	.in1      (in11                                           ), 
    .in2      (in12                                           ), 
    .in3      (in13                                           ), 
    .in4      (in14                                           ), 
    .in5      (in15                                           ),
	.filter   ( filter[BIT_WIDTH*(2*SIZE)-1 : BIT_WIDTH*SIZE] ),
	.convValue(conv1                                          ) 
);

// third (last) feature map
conv55 #(
    .BIT_WIDTH(BIT_WIDTH), 
    .OUT_WIDTH(OUT_WIDTH)
) conv55_inst2 (
	.clk      (clk                                              ), 
	.en       (en                                               ),
	.in1      (in21                                             ), 
    .in2      (in22                                             ), 
    .in3      (in23                                             ), 
    .in4      (in24                                             ), 
    .in5      (in25                                             ),
	.filter   ( filter[BIT_WIDTH*(3*SIZE)-1 : BIT_WIDTH*2*SIZE] ),
	.convValue(conv2                                            ) 
);

wire signed[OUT_WIDTH-1:0] sum0, sum1;

assign sum0 = conv0 + conv1;
assign sum1 = conv2 + bias ;
assign convValue = sum0 + sum1;

endmodule
