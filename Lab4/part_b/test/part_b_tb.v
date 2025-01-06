`timescale 1ns/10ps
module part_b_tb;
reg clk, reset;
reg enable;
reg [7:0] data_to_transmit;
wire ready;
wire [7:0] received_data;

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

spi_master spi_master_inst(.clk(clk), .reset(reset), .enable(enable), .data_to_transmit(data_to_transmit), .ready(ready), .received_data(received_data));

initial begin
    reset = 1'b0;
    clk = 1'b0;
    enable = 1'b0;
    #100 reset = 1'b1;
    #200 reset = 1'b0;
    #50 data_to_transmit = 8'b01101011;
    #50 enable = 1'b1;
end

endmodule