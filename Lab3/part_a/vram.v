module vram(
    input clk,
    input reset,
    input [13:0] address,
    output wire [15:0] r,
    output wire [15:0] g,
    output wire [15:0] b
);

vram_red vram_red_inst(.clk(clk), .reset(reset), .read_address(address), .out(r));
vram_green vram_green_inst(.clk(clk), .reset(reset), .read_address(address), .out(g));
vram_blue vram_blue_inst(.clk(clk), .reset(reset), .read_address(address), .out(b));

endmodule