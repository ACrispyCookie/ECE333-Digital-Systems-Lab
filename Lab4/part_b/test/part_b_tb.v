`timescale 1ns/10ps
module part_b_tb;
reg clk, reset;
reg enable;
reg [7:0] data_to_transmit;
wire ready, slave_ready;
wire [7:0] received_data, slave_received;

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

spi_master spi_master_inst(.clk(clk), .reset(reset), .enable(enable), .ss(ss), .sclk(sclk), .miso(miso), .mosi(mosi), 
 .data_to_transmit(data_to_transmit), .ready(ready), .received_data(received_data));

spi_slave spi_slave_inst(.clk(sclk), .reset(reset), .ss(ss), .ready(slave_ready), .received_data(slave_received), .mosi(mosi), .miso(miso));

initial begin
    reset = 1'b0;
    clk = 1'b0;
    enable = 1'b0;
    #100 reset = 1'b1;
    #200 reset = 1'b0;
    #50 data_to_transmit = 8'b00101011;
    #50 enable = 1'b1;
    #300 enable = 1'b0;
    #1495 enable = 1'b1;
    #1000 data_to_transmit = 8'b01010010;
end

endmodule