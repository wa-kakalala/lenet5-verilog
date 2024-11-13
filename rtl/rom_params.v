/**************************************
@ filename    : rom_params.v
@ author      : https://github.com/djtfoo/lenet5-verilog
@ update      : yyrwkk
@ create time : 2024/11/13 20:13:04
@ version     : v1.0.0
**************************************/
module rom_params # (
    parameter BIT_WIDTH = 8  , 
    parameter SIZE      = 26 , // 26 = 5x5 filter + 1 bias
    parameter FILE      = "kernel_c1.list"
)(
	input                           clk     ,
	input                           read    ,
	output reg [BIT_WIDTH*SIZE-1:0] read_out
);

reg [BIT_WIDTH-1:0] weights [0:SIZE-1];

// simple way to read weights from memory
initial begin
	$readmemh(FILE, weights); // read 5x5 filter + 1 bias
end

genvar i;
generate
    for (i = 0; i < SIZE; i = i+1) begin : rom_inst
        always @ (posedge clk) begin
            if (read) begin
                read_out[i*BIT_WIDTH +: BIT_WIDTH] <= weights[i];
            end else begin
                read_out[i*BIT_WIDTH +: BIT_WIDTH] <= read_out[i*BIT_WIDTH +: BIT_WIDTH];
            end
        end
    end
endgenerate

endmodule



