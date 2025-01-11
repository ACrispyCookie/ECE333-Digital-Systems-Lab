`timescale 1ns/10ps
module driver_tb;
reg clk, reset;

wire slave_ready;
wire [7:0] slave_received;
wire mosi, miso, sclk, ss;
wire TxD;
wire vga_red, vga_green, vga_blue, vga_hsync, vga_vsync;
reg enable, accel_mode, edit_mode;
reg up_ctrl, down_ctrl, left_ctrl, right_ctrl;

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

accelerometer_driver accelerometer_driver_inst(.clk(clk), .reset(reset), .miso(miso), .TxD(TxD), .mosi(mosi), .sclk(sclk), .ss(ss),
.vga_red(vga_red), .vga_green(vga_green), .vga_blue(vga_blue), .vga_hsync(vga_hsync), .vga_vsync(vga_vsync), .enable(enable), .accel_mode(accel_mode), .edit_mode(edit_mode),
.up_ctrl(up_ctrl), .down_ctrl(down_ctrl), .left_ctrl(left_ctrl), .right_ctrl(right_ctrl));

spi_slave spi_slave_inst(.clk(sclk), .reset(reset), .ss(ss), .ready(slave_ready), .received_data(slave_received), .mosi(mosi), .miso(miso));

initial begin
    clk = 1'b0;
    reset = 1'b0;
    #300 reset = 1'b1;
    #1700000 reset = 1'b0;
    enable = 1'b1;
    accel_mode = 1'b1;
    edit_mode = 1'b0;
    up_ctrl = 1'b0;
    down_ctrl = 1'b0;
    left_ctrl = 1'b0;
    right_ctrl = 1'b0;
end

endmodule