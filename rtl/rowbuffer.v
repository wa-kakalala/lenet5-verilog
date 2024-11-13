/**************************************
@ filename    : rowbuffer.v
@ author      : https://github.com/djtfoo/lenet5-verilog
@ update      : yyrwkk
@ create time : 2024/11/13 19:35:32
@ version     : v1.0.0
**************************************/
module rowbuffer # (
    parameter COLS      = 28 ,       
    parameter BIT_WIDTH = 8
)(
	input                  clk   , 
	input  [BIT_WIDTH-1:0] rb_in ,
	input                  en    ,
	output [BIT_WIDTH-1:0] rb_out	// output for next buffer
);

reg [BIT_WIDTH-1:0] rb [0:COLS-1];
genvar i;
generate
    for (i = 0; i < COLS; i = i+1) begin : row_buffer
        if( i== 0 ) begin 
            always@(posedge clk) begin
                if( en ) begin
                    rb[i] <= rb_in;
                end else begin 
                    rb[i] <= rb[i];
                end
            end
        end else begin 
            always@(posedge clk) begin
                if( en ) begin
                    rb[i] <= rb[i-1];
                end else begin 
                    rb[i] <= rb[i];
                end
            end
        end
    end
endgenerate

assign rb_out = rb[COLS-1];

endmodule
