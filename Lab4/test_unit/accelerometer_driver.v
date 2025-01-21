// Top module for accelerometer driver //

module accelerometer_driver (clk, reset, miso, TxD, sclk, mosi, ss, an7, an6, an5, an4,
an3, an2, an1, an0, a, b, c, d, e, f, g, dp, simple_mode, no_avg, binary_select, x_sel, y_sel, z_sel, t_sel, use_burst);

input clk, reset, miso;
input wire simple_mode, no_avg, binary_select, x_sel, y_sel, z_sel, t_sel, use_burst;
output wire TxD, sclk, mosi, ss;
output wire an7, an6, an5, an4, an3, an2, an1, an0, a, b, c, d, e, f, g, dp;

/* Binary to ascii outputs */
wire [7:0] ascii_X1, ascii_X2, ascii_X3, ascii_X4;
wire [7:0] ascii_Y1, ascii_Y2, ascii_Y3, ascii_Y4;
wire [7:0] ascii_Z1, ascii_Z2, ascii_Z3, ascii_Z4;
wire [7:0] ascii_T1, ascii_T2, ascii_T3, ascii_T4, ascii_T5, ascii_T6;
wire is_negative_X, is_negative_Y, is_negative_Z, is_negative_T;
wire ready_X, ready_Y, ready_Z, ready_T;

/* Value reader outputs */
wire signed [11:0] X_val, Y_val, Z_val;
wire signed [18:0] T_val;
wire send, values_ready;
wire [7:0] command, address, data;

/* Command sender outputs */
wire spi_enable, command_done;
wire [7:0] spi_transmit_data;

/* SPI master outputs */
wire spi_ready;
wire [7:0] received_data;

/* SSD chars */
wire char0, char1, char2, char3, char4, char5, char6, char7;
wire signed [11:0] x_binary, y_binary, z_binary;
wire signed [18:0] t_binary;

ResetDebouncer reset_debouncer_inst(.clk(clk), .input_bounce(reset), .debounced(debounced_reset), .debounced_off(), .debounced_on());

uart_transmitter_data_control uart_transmitter_data_control_inst(.clk(clk), .reset(debounced_reset), .TxD(TxD), .start_transmission(1'b1), .data_ready_for_printing(ready_T),
.ascii_X1(ascii_X1), .ascii_X2(ascii_X2), .ascii_X3(ascii_X3), .ascii_X4(ascii_X4),
.ascii_Y1(ascii_Y1), .ascii_Y2(ascii_Y2), .ascii_Y3(ascii_Y3), .ascii_Y4(ascii_Y4),
.ascii_Z1(ascii_Z1), .ascii_Z2(ascii_Z2), .ascii_Z3(ascii_Z3), .ascii_Z4(ascii_Z4),
.ascii_T1(ascii_T1), .ascii_T2(ascii_T2), .ascii_T3(ascii_T3), .ascii_T4(ascii_T4), .ascii_T5(ascii_T5), .ascii_T6(ascii_T6),
.is_negative_X(is_negative_X), .is_negative_Y(is_negative_Y), .is_negative_Z(is_negative_Z), .is_negative_T(is_negative_T)
);

binary_to_ascii_4 binary_to_ascii_X(.clk(clk), .reset(debounced_reset), .binary(X_val), .start(values_ready),
.ascii_1(ascii_X1), .ascii_2(ascii_X2), .ascii_3(ascii_X3), .ascii_4(ascii_X4), .is_negative(is_negative_X), .ready(ready_X));

binary_to_ascii_4 binary_to_ascii_Y(.clk(clk), .reset(debounced_reset), .binary(Y_val), .start(values_ready),
.ascii_1(ascii_Y1), .ascii_2(ascii_Y2), .ascii_3(ascii_Y3), .ascii_4(ascii_Y4), .is_negative(is_negative_Y), .ready(ready_Y));

binary_to_ascii_4 binary_to_ascii_Z(.clk(clk), .reset(debounced_reset), .binary(Z_val), .start(values_ready),
.ascii_1(ascii_Z1), .ascii_2(ascii_Z2), .ascii_3(ascii_Z3), .ascii_4(ascii_Z4), .is_negative(is_negative_Z), .ready(ready_Z));

binary_to_ascii_6 binary_to_ascii_T(.clk(clk), .reset(debounced_reset), .binary(T_val), .start(values_ready),
.ascii_1(ascii_T1), .ascii_2(ascii_T2), .ascii_3(ascii_T3), .ascii_4(ascii_T4), .ascii_5(ascii_T5), .ascii_6(ascii_T6), 
.is_negative(is_negative_T), .ready(ready_T));

value_reader value_reader_inst(.clk(clk), .reset(debounced_reset), .x_avg(X_val), .y_avg(Y_val), .z_avg(Z_val), .t_avg(T_val), .x_binary(x_binary), .y_binary(y_binary), .z_binary(z_binary), .t_binary(t_binary),
.simple_mode(simple_mode), .no_avg(no_avg), .use_burst(use_burst), 
.values_ready(values_ready), .send(send), .command_done(command_done), .command(command), .address(address), .data(data), .received_data(received_data));

command_sender command_sender_inst(.clk(clk), .reset(debounced_reset), .spi_enable(spi_enable), .spi_ready(spi_ready), .spi_ss(ss), .spi_transmit_data(spi_transmit_data), 
.send(send), .command_done(command_done), .command(command), .address(address), .data(data));

spi_master spi_master_inst(.clk(clk), .reset(debounced_reset), .miso(miso), .sclk(sclk), .mosi(mosi), .ss(ss),
.enable(spi_enable), .data_ready(spi_ready), .data_to_transmit(spi_transmit_data), .received_data(received_data));

char_driver char_driver_inst(.simple_mode(simple_mode), .no_avg(no_avg), .binary_select(binary_select), .x_sel(x_sel), .y_sel(y_sel), .z_sel(z_sel), .t_sel(t_sel),
.x_binary(X_val), .y_binary(Y_val), .z_binary(Z_val), .t_binary(t_binary), .x_avg(X_val), .y_avg(Y_val), .z_avg(Z_val), .t_avg(t_avg), 
.char0(char0), .char1(char1), .char2(char2), .char3(char3), .char4(char4), .char5(char5), .char6(char6), .char7(char7));

FourDigitLEDdriver four_digit(.reset(debounced_reset), .clk(clk), .an7(an7), .an6(an6), .an5(an5), .an4(an4), .an3(an3), .an2(an2), .an1(an1), .an0(an0),
.a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp), .char0(char0), .char1(char1), .char2(char2), .char3(char3), .char4(char4), .char5(char5), .char6(char6), .char7(char7));

endmodule
