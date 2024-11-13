/**************************************
@ filename    : row4buffer.v
@ author      : https://github.com/djtfoo/lenet5-verilog
@ update      : yyrwkk
@ create time : 2024/11/13 19:41:47
@ version     : v1.0.0
**************************************/
module row4buffer #(
    parameter COLS      = 28 , 
    parameter BIT_WIDTH = 8 
)(
	input                  clk    , 
	input  [BIT_WIDTH-1:0] rb_in  ,
	input                  en     ,	
	output [BIT_WIDTH-1:0] rb_out0, 
    output [BIT_WIDTH-1:0] rb_out1, 
    output [BIT_WIDTH-1:0] rb_out2, 
    output [BIT_WIDTH-1:0] rb_out3
);

// first row to receive input
rowbuffer #(
    .COLS     (COLS     ), 
    .BIT_WIDTH(BIT_WIDTH)
) rowbuffer_inst0 (  
    .clk   (clk    ),
    .rb_in (rb_in  ),
    .en    (en     ),
    .rb_out(rb_out0)
);

rowbuffer #(
    .COLS     (COLS     ), 
    .BIT_WIDTH(BIT_WIDTH)
) rowbuffer_inst1 (  
    .clk   (clk    ),
    .rb_in (rb_out0),
    .en    (en     ),
    .rb_out(rb_out1)
);

rowbuffer #(
    .COLS     (COLS     ), 
    .BIT_WIDTH(BIT_WIDTH)
) rowbuffer_inst2 (  
    .clk   (clk    ),
    .rb_in (rb_out1),
    .en    (en     ),
    .rb_out(rb_out2)
);

rowbuffer #(
    .COLS     (COLS     ), 
    .BIT_WIDTH(BIT_WIDTH)
) rowbuffer_inst3 (  
    .clk   (clk    ),
    .rb_in (rb_out2),
    .en    (en     ),
    .rb_out(rb_out3)
);

endmodule
