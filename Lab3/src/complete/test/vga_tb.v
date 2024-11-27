`timescale 1ns/1ns
module vga_tb;
    reg clk, reset, enable;
    reg edit_mode, up_ctrl, down_ctrl, left_ctrl, right_ctrl;
    wire vga_red, vga_green, vga_blue, vga_hsync, vga_vsync;

    localparam CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) clk=~clk;

    vga_controller controller_inst(.clk(clk), .reset(reset), .enable(enable), .edit_mode(edit_mode),
    .up_ctrl(up_ctrl), .down_ctrl(down_ctrl), .left_ctrl(left_ctrl), .right_ctrl(right_ctrl),
    .vga_red(vga_red), .vga_green(vga_green), .vga_blue(vga_blue), .vga_hsync(vga_hsync), .vga_vsync(vga_vsync));

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        enable = 1'b0;
        edit_mode = 1'b0;
        up_ctrl = 1'b0;
        down_ctrl = 1'b0;
        left_ctrl = 1'b0;
        right_ctrl = 1'b0;
        #300 reset = 1'b1;
        #1700000 reset = 1'b0;
        #100 enable = 1'b1;
    end

endmodule