`timescale 1ns/10ps
module driver_tb;
reg clk, reset;

wire vga_red, vga_green, vga_blue, vga_hsync, vga_vsync;
reg enable, accel_mode, edit_mode;
reg up_ctrl, down_ctrl, left_ctrl, right_ctrl;
reg [11:0] x_accel, y_accel;

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

vga_controller vga_controller_inst(.clk(clk), .reset(reset),
.vga_red(vga_red), .vga_green(vga_green), .vga_blue(vga_blue), .vga_hsync(vga_hsync), .vga_vsync(vga_vsync), .enable(enable), .accel_mode(accel_mode), .edit_mode(edit_mode),
.up_ctrl(up_ctrl), .down_ctrl(down_ctrl), .left_ctrl(left_ctrl), .right_ctrl(right_ctrl), .x_accel(x_accel), .y_accel(y_accel));

initial begin
    clk = 1'b0;
    reset = 1'b0;
    #300 reset = 1'b1;
    #1700000 reset = 1'b0;
    x_accel = 12'd600;
    y_accel = 12'd600;
    enable = 1'b1;
    accel_mode = 1'b1;
    edit_mode = 1'b0;
    up_ctrl = 1'b1;
    down_ctrl = 1'b0;
    left_ctrl = 1'b1;
    right_ctrl = 1'b0;
end

endmodule