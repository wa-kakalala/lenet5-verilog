/**************************************
@ filename    : conv55.v
@ author      : https://github.com/djtfoo/lenet5-verilog
@ update      : yyrwkk
@ create time : 2024/11/13 16:34:37
@ version     : v1.0.0
**************************************/
module conv55 # (
    parameter BIT_WIDTH = 8   , 
    parameter OUT_WIDTH = 32
)(
	input                            clk      , 
	input                            en       ,	
	input signed[BIT_WIDTH-1:0]      in1      , 
    input signed[BIT_WIDTH-1:0]      in2      ,
    input signed[BIT_WIDTH-1:0]      in3      ,
    input signed[BIT_WIDTH-1:0]      in4      ,
    input signed[BIT_WIDTH-1:0]      in5      ,
	input signed[(BIT_WIDTH*25)-1:0] filter   ,	// 5x5 filter

	output signed[OUT_WIDTH-1:0]     convValue	// size should increase to hold the sum of products
);


reg signed [BIT_WIDTH-1:0] rows[0:4][0:4]; // 5x5 window matrix

genvar i;
generate
    for( i=0;i<4;i=i+1 ) begin : window_gen
        if( i == 0 ) begin // first col is always from input
            always @(posedge clk) begin
                if (en) begin
                    rows[0][i] <= in1;
                    rows[1][i] <= in2;
                    rows[2][i] <= in3;
                    rows[3][i] <= in4;
                    rows[4][i] <= in5;  
                end else begin 
                    rows[0][i] <= rows[0][i];
                    rows[1][i] <= rows[1][i];
                    rows[2][i] <= rows[2][i];
                    rows[3][i] <= rows[3][i];
                    rows[4][i] <= rows[4][i];
                end
            end
        end else begin  // other cols are shifted by 1
            always @(posedge clk) begin
                if (en) begin
                    rows[0][i] <= rows[0][i-1];
                    rows[1][i] <= rows[1][i-1];
                    rows[2][i] <= rows[2][i-1];
                    rows[3][i] <= rows[3][i-1];
                    rows[4][i] <= rows[4][i-1];
                end else begin 
                    rows[0][i] <= rows[0][i];
                    rows[1][i] <= rows[1][i];
                    rows[2][i] <= rows[2][i];
                    rows[3][i] <= rows[3][i];
                    rows[4][i] <= rows[4][i];
                end
           end
        end
       
    end
endgenerate

// multiply & accumulate in 1 clock cycle
wire signed[OUT_WIDTH-1:0] mult55[0:24];

genvar x, y;
// multiplication
generate
	for (x = 0; x < 5; x = x+1) begin : sum_rows	    // each row
		for (y = 0; y < 5; y = y+1) begin : sum_columns	// each item in a row
			assign mult55[5*x+y] = rows[x][4-y] * filter[BIT_WIDTH*(5*x+y+1)-1 : BIT_WIDTH*(5*x+y)];
		end
	end
endgenerate

genvar j;
// adder tree ： 5 leves
wire signed[OUT_WIDTH-1:0] sums[0:22];	// 25-2 intermediate sums
generate
	// sums[0] to sums[11]
	for (j = 0; j < 12; j = j+1) begin : addertree_nodes0  // 0+1 2+3 4+5 6+7 8+9 10+11 ...
		assign sums[j] = mult55[j*2] + mult55[j*2+1];
	end
	// sums[12] to sums[17]
	for (j = 0; j < 6; j = j+1) begin : addertree_nodes1  // （0+1）+（2+3）+（4+5）+（6+7）+（8+9）+（10+11）...
		assign sums[j+12] = sums[j*2] + sums[j*2+1];
	end
	// sums[18] to sums[20]
	for (j = 0; j < 3; j = j+1) begin : addertree_nodes2  // （（0+1）+（2+3）+（4+5）+（6+7）+（8+9）+（10+11））+（12+13）...
		assign sums[j+18] = sums[j*2+12] + sums[j*2+13];
	end
	assign sums[21] = sums[18] + sums[19];                 
	assign sums[22] = sums[20] + mult55[24];
endgenerate

// final sum
assign convValue = sums[21] + sums[22];

endmodule

