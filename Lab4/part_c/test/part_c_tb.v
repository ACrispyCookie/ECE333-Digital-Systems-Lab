`timescale 1ns/10ps
module driver_tb;
reg clk, reset;
wire [7:0] id, id2;
wire id_ready;

wire slave_ready;
wire [7:0] data_to_transmit, received_data, slave_received;
wire [7:0] command, address, data;


localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

value_reader value_reader_inst (.clk(clk), .reset(reset), .id(id), .id2(id2), .values_ready(id_ready), .send(send), .command_done(command_done), 
.command(command), .address(address), .data(data), .received_data(received_data));

command_sender command_sender_inst(.clk(clk), .reset(reset), .spi_enable(spi_enable), .spi_ready(spi_ready), .spi_ss(ss), .spi_transmit_data(data_to_transmit), 
.send(send), .command_done(command_done), .command(command), .address(address), .data(data));

spi_master spi_master_inst(.clk(clk), .reset(reset), .enable(spi_enable), .ss(ss), .sclk(sclk), .miso(miso), .mosi(mosi), 
 .data_to_transmit(data_to_transmit), .ready(spi_ready), .received_data(received_data));

spi_slave spi_slave_inst(.clk(sclk), .reset(reset), .ss(ss), .ready(slave_ready), .received_data(slave_received), .mosi(mosi), .miso(miso));

initial begin
    clk = 1'b0;
    reset = 1'b0;
    #300 reset = 1'b1;
    #100 reset = 1'b0;
end

endmodule