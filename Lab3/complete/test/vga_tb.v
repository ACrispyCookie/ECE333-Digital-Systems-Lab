`timescale 1ns/10ps
module vga_tb;
    reg clk, reset, enable;
    wire vga_red, vga_green, vga_blue, vga_hsync, vga_vsync;

    localparam CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) clk=~clk;

    vga_controller controller_inst(.clk(clk), .reset(reset), .enable(enable), .vga_red(vga_red), .vga_green(vga_green), .vga_blue(vga_blue), .vga_hsync(vga_hsync), .vga_vsync(vga_vsync));

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        enable = 1'b0;
        #300 reset = 1'b1;
        #300 reset = 1'b0;
        #100 enable = 1'b1;
    end

endmodule