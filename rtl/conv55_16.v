/**************************************
@ filename    : conv55_16.v
@ author      : https://github.com/djtfoo/lenet5-verilog
@ update      : yyrwkk
@ create time : 2024/11/13 17:25:35
@ version     : v1.0.0
**************************************/
module conv55_16 # (
    parameter BIT_WIDTH = 8, 
    parameter OUT_WIDTH = 32
)(
    input                                                    clk       , 
    input                                                    en        ,	
    input  signed[16*BIT_WIDTH-1:0]      in1, in2, in3, in4, in5       , // 5 input columns vector
    input  signed[(BIT_WIDTH*25*16)-1:0]                     filter    , // 5x5xN filter
    input  signed[BIT_WIDTH-1:0]                             bias      ,	
    output signed[OUT_WIDTH-1:0]                             convValue	
);

// convert flattened input vectors into arrays
wire signed[BIT_WIDTH-1:0] in1_arr[0:15], in2_arr[0:15], in3_arr[0:15], in4_arr[0:15], in5_arr[0:15];
genvar i;
generate
	for (i = 0; i < 16; i = i+1) begin : genbit
		assign in1_arr[i] = in1[BIT_WIDTH*(i+1)-1:BIT_WIDTH*i];
		assign in2_arr[i] = in2[BIT_WIDTH*(i+1)-1:BIT_WIDTH*i];
		assign in3_arr[i] = in3[BIT_WIDTH*(i+1)-1:BIT_WIDTH*i];
		assign in4_arr[i] = in4[BIT_WIDTH*(i+1)-1:BIT_WIDTH*i];
		assign in5_arr[i] = in5[BIT_WIDTH*(i+1)-1:BIT_WIDTH*i];
	end
endgenerate

// 16x 5*5*1 convolutions
wire signed [OUT_WIDTH-1:0] conv[0:15];	// store outputs of each conv55
parameter SIZE = 25;	// 5x5 filter
// generate 16x conv55 modules
genvar gen;
generate
	for (gen = 0; gen < 16; gen = gen+1) begin : conv_module
		conv55 #(
            .BIT_WIDTH(BIT_WIDTH), 
            .OUT_WIDTH(OUT_WIDTH)
        ) conv55_inst (
			.clk(clk), //.rst(rst),
			.en (en ),
			.in1(in1_arr[gen]), .in2(in2_arr[gen]), .in3(in3_arr[gen]), .in4(in4_arr[gen]), .in5(in5_arr[gen]),
			.filter( filter[BIT_WIDTH*((gen+1)*SIZE)-1 : BIT_WIDTH*gen*SIZE] ),
			.convValue(conv[gen])
		);
	end
endgenerate


wire signed[OUT_WIDTH-1:0] sums[0:13];	// 16-2 intermediate sums
genvar x;
generate
	// sums[0] to sums[7]
	for (x = 0; x < 8; x = x+1) begin : addertree_nodes0
		assign sums[x] = conv[x*2] + conv[x*2+1];
	end
	// sums[8] to sums[11]
	for (x = 0; x < 4; x = x+1) begin : addertree_nodes1
		assign sums[x+8] = sums[x*2] + sums[x*2+1];
	end
	// sums[12] to sums[13]
	for (x = 0; x < 2; x = x+1) begin : addertree_nodes2
		assign sums[x+12] = sums[x*2+8] + sums[x*2+9];
	end
endgenerate

assign convValue = sums[12] + sums[13] + bias;	// add bias and output

endmodule
