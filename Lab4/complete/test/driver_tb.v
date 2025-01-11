`timescale 1ns/10ps
module driver_tb;
reg clk, reset;

wire slave_ready;
wire [7:0] slave_received;
wire mosi, miso, sclk, ss;
wire TxD;

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

accelerometer_driver accelerometer_driver_inst(.clk(clk), .reset(reset), .miso(miso), .TxD(TxD), .mosi(mosi), .sclk(sclk), .ss(ss));

spi_slave spi_slave_inst(.clk(sclk), .reset(reset), .ss(ss), .ready(slave_ready), .received_data(slave_received), .mosi(mosi), .miso(miso));

initial begin
    clk = 1'b0;
    reset = 1'b0;
    #300 reset = 1'b1;
    #1700000 reset = 1'b0;
end

endmodule