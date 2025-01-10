// Top module for accelerometer driver //

module accelerometer_driver (clk, reset, miso, TxD, sclk, mosi, ss);

input clk, reset, miso;
output wire TxD, sclk, mosi, ss;

/* Binary to ascii outputs */
wire [7:0] ascii_X1, ascii_X2, ascii_X3, ascii_X4;
wire [7:0] ascii_Y1, ascii_Y2, ascii_Y3, ascii_Y4;
wire [7:0] ascii_Z1, ascii_Z2, ascii_Z3, ascii_Z4;
wire [7:0] ascii_T1, ascii_T2, ascii_T3, ascii_T4, ascii_T5, ascii_T6;
wire is_negative_X, is_negative_Y, is_negative_Z, is_negative_T;
wire ready_X, ready_Y, ready_Z, ready_T;

/* Value reader outputs */
wire [11:0] X_val, Y_val, Z_val;
wire [18:0] T_val;
wire send, values_ready;
wire [7:0] command, address, data;

/* Command sender outputs */
wire spi_enable, command_done;
wire [7:0] spi_transmit_data;

/* SPI master outputs */
wire spi_ready, spi_ss;
wire [7:0] received_data;

wire data_ready_for_printing;
assign data_ready_for_printing = ready_X && ready_Y && ready_Z && ready_T;

uart_transmitter_data_control uart_transmitter_data_control_inst(.clk(clk), .reset(reset), .TxD(TxD), .start_transmission(1'b1), .data_ready_for_printing(data_ready_for_printing),
.ascii_X1(ascii_X1), .ascii_X2(ascii_X2), .ascii_X3(ascii_X3), .ascii_X4(ascii_X4),
.ascii_Y1(ascii_Y1), .ascii_Y2(ascii_Y2), .ascii_Y3(ascii_Y3), .ascii_Y4(ascii_Y4),
.ascii_Z1(ascii_Z1), .ascii_Z2(ascii_Z2), .ascii_Z3(ascii_Z3), .ascii_Z4(ascii_Z4),
.ascii_T1(ascii_T1), .ascii_T2(ascii_T2), .ascii_T3(ascii_T3), .ascii_T4(ascii_T4), .ascii_T5(ascii_T5), .ascii_T6(ascii_T6),
.is_negative_X(is_negative_X), .is_negative_Y(is_negative_Y), .is_negative_Z(is_negative_Z), .is_negative_T(is_negative_T)
);

binary_to_ascii_4 binary_to_ascii_X(.clk(clk), .reset(reset), .binary(X_val), .start(values_ready),
.ascii_1(ascii_X1), .ascii_2(ascii_X2), .ascii_3(ascii_X3), .ascii_4(ascii_X4), .is_negative(is_negative_X), .ready(ready_X));

binary_to_ascii_4 binary_to_ascii_Y(.clk(clk), .reset(reset), .binary(Y_val), .start(values_ready),
.ascii_1(ascii_Y1), .ascii_2(ascii_Y2), .ascii_3(ascii_Y3), .ascii_4(ascii_Y4), .is_negative(is_negative_Y), .ready(ready_Y));

binary_to_ascii_4 binary_to_ascii_Z(.clk(clk), .reset(reset), .binary(Z_val), .start(values_ready),
.ascii_1(ascii_Z1), .ascii_2(ascii_Z2), .ascii_3(ascii_Z3), .ascii_4(ascii_Z4), .is_negative(is_negative_Z), .ready(ready_Z));

binary_to_ascii_6 binary_to_ascii_T(.clk(clk), .reset(reset), .binary(T_val), .start(values_ready),
.ascii_1(ascii_T1), .ascii_2(ascii_T2), .ascii_3(ascii_T3), .ascii_4(ascii_T4), .ascii_5(ascii_T5), .ascii_6(ascii_T6), 
.is_negative(is_negative_T), .ready(ready_T));

value_reader value_reader_inst(.clk(clk), .reset(reset), .x_avg(X_val), .y_avg(Y_val), .z_avg(Z_val), .t_avg(T_val),
.values_ready(values_ready), .send(send), .command_done(command_done), .command(command), .address(address), .data(data), .received_data(received_data));

command_sender command_sender_inst(.clk(clk), .reset(reset), .spi_enable(spi_enable), .spi_ready(spi_ready), .spi_ss(spi_ss), .spi_transmit_data(spi_transmit_data), 
.send(send), .command_done(command_done), .command(command), .address(address), .data(data));

spi_master spi_master_inst(.clk(clk), .reset(reset), .miso(miso), .sclk(sclk), .mosi(mosi), .ss(spi_ss),
.enable(spi_enable), .data_ready(spi_ready), .data_to_transmit(spi_transmit_data), .received_data(received_data));

endmodule
