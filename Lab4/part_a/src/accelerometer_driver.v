// Top module for accelerometer driver //
// TODO: add your modules instantiations here //
// TODO: add SPI communication ports here //

module accelerometer_driver (clk, reset, TxD);

parameter X_val = 14'd1312;
parameter Y_val = 14'd834;
parameter Z_val = 14'd5049;
parameter T_val = 20'd123145;

input clk, reset;
output TxD;

wire data_ready;

wire [7:0] ascii_X1, ascii_X2, ascii_X3, ascii_X4;
wire [7:0] ascii_Y1, ascii_Y2, ascii_Y3, ascii_Y4;
wire [7:0] ascii_Z1, ascii_Z2, ascii_Z3, ascii_Z4;
wire [7:0] ascii_T1, ascii_T2, ascii_T3, ascii_T4, ascii_T5, ascii_T6;
wire is_negative_X, is_negative_Y, is_negative_Z, is_negative_T;
wire ready_X, ready_Y, ready_Z, ready_T;

wire data_ready_for_printing;
assign data_ready_for_printing = ready_X && ready_Y && ready_Z && ready_T;

uart_transmitter_data_control uart_transmitter_data_control_inst(.clk(clk), .reset(reset), .TxD(TxD), .start_transmission(1'b1), .data_ready_for_printing(data_ready_for_printing),
.ascii_X1(ascii_X1), .ascii_X2(ascii_X2), .ascii_X3(ascii_X3), .ascii_X4(ascii_X4),
.ascii_Y1(ascii_Y1), .ascii_Y2(ascii_Y2), .ascii_Y3(ascii_Y3), .ascii_Y4(ascii_Y4),
.ascii_Z1(ascii_Z1), .ascii_Z2(ascii_Z2), .ascii_Z3(ascii_Z3), .ascii_Z4(ascii_Z4),
.ascii_T1(ascii_T1), .ascii_T2(ascii_T2), .ascii_T3(ascii_T3), .ascii_T4(ascii_T4), .ascii_T5(ascii_T5), .ascii_T6(ascii_T6),
.is_negative_X(is_negative_X), .is_negative_Y(is_negative_Y), .is_negative_Z(is_negative_Z), .is_negative_T(is_negative_T)
);

binary_to_ascii_4 binary_to_ascii_X(.binary(X_val), .start(1'b1),
.ascii_1(ascii_X1), .ascii_2(ascii_X2), .ascii_3(ascii_X3), .ascii_4(ascii_X4), .ready(ready_X));

binary_to_ascii_4 binary_to_ascii_Y(.binary(Y_val), .start(1'b1),
.ascii_1(ascii_Y1), .ascii_2(ascii_Y2), .ascii_3(ascii_Y3), .ascii_4(ascii_Y4), .ready(ready_Y));

binary_to_ascii_4 binary_to_ascii_Z(.binary(Z_val), .start(1'b1),
.ascii_1(ascii_Z1), .ascii_2(ascii_Z2), .ascii_3(ascii_Z3), .ascii_4(ascii_Z4), .ready(ready_Z));

binary_to_ascii_6 binary_to_ascii_T(.binary(T_val), .start(1'b1),
.ascii_1(ascii_T1), .ascii_2(ascii_T2), .ascii_3(ascii_T3), .ascii_4(ascii_T4), .ascii_5(ascii_T5), .ascii_6(ascii_T6), .ready(ready_T));

endmodule
