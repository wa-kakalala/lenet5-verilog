/**************************************
@ filename    : maxpool22.v
@ author      : https://github.com/djtfoo/lenet5-verilog
@ update      : yyrwkk
@ create time : 2024/11/13 19:28:46
@ version     : v1.0.0
**************************************/
module maxpool22 # (
    parameter BIT_WIDTH = 32
)(
	input                        clk   , 
	input                        en    ,	
	input  signed[BIT_WIDTH-1:0] in1   ,
    input  signed[BIT_WIDTH-1:0] in2   ,
	output signed[BIT_WIDTH-1:0] maxOut
);

parameter SIZE = 2;	// 2x2 max pool

reg signed[BIT_WIDTH-1:0] row1[0:1];	// 1st row of layer
reg signed[BIT_WIDTH-1:0] row2[0:1];	// 2nd row of layer

genvar i;
generate
    for (i = 0; i < SIZE; i = i+1) begin : row_gen
        if( i== 0 ) begin 
            always @ (posedge clk) begin
                if (en) begin
                    row1[i] <= in1;    // shift new input to left
                    row2[i] <= in2;    // shift new input to left
                end else begin 
                    row1[i] <= row1[i];
                    row2[i] <= row2[i];
                end
            end
        end else begin 
            always @ (posedge clk) begin
                if (en) begin
                    row1[i] <= row1[i-1];    // shift left
                    row2[i] <= row2[i-1];    // shift left
                end else begin 
                    row1[i] <= row1[i];
                    row2[i] <= row2[i];
                end
            end
        end 
    end
endgenerate

// find max
wire signed[BIT_WIDTH-1:0] maxR1, maxR2;
max # (
    .BIT_WIDTH(BIT_WIDTH) 
) max_inst0 (
	.in1(row1[0]), 
    .in2(row1[1]),
	.max(maxR1  )
);

max # (
    .BIT_WIDTH(BIT_WIDTH)
) max_inst1 (
	.in1(row2[0]), 
    .in2(row2[1]),
	.max(maxR2  )  
);

max #(
    .BIT_WIDTH(BIT_WIDTH)
) max_inst2 (
	.in1(maxR1 ), 
    .in2(maxR2 ),
	.max(maxOut)
);

endmodule
