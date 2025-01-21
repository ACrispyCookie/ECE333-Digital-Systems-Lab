module uart_test(clk, reset, start, binary, TxD);

input clk, reset, start;
input [18:0] binary;
output TxD;

wire [7:0] ascii_X1, ascii_X2, ascii_X3, ascii_X4, ascii_X5, ascii_X6;
wire ready_X;
wire is_negative_X;

binary_to_ascii_6 binary_to_ascii_X(.clk(clk), .reset(reset), .binary(binary), .start(start),
.ascii_1(ascii_X1), .ascii_2(ascii_X2), .ascii_3(ascii_X3), .ascii_4(ascii_X4), .ascii_5(ascii_X5), .ascii_6(ascii_X6), .is_negative(is_negative_X), .ready(ready_X));

uart_transmitter_data_control uart_transmitter_data_control_inst(.clk(clk), .reset(reset), .TxD(TxD), .start_transmission(1'b1), .data_ready_for_printing(ready_X),
.ascii_X1(ascii_X1), .ascii_X2(ascii_X2), .ascii_X3(ascii_X3), .ascii_X4(ascii_X4),
.ascii_Y1(ascii_X1), .ascii_Y2(ascii_X2), .ascii_Y3(ascii_X3), .ascii_Y4(ascii_X4),
.ascii_Z1(ascii_X1), .ascii_Z2(ascii_X2), .ascii_Z3(ascii_X3), .ascii_Z4(ascii_X4),
.ascii_T1(ascii_X1), .ascii_T2(ascii_X2), .ascii_T3(ascii_X3), .ascii_T4(ascii_X4), .ascii_T5(ascii_X1), .ascii_T6(ascii_X1),
.is_negative_X(is_negative_X), .is_negative_Y(is_negative_X), .is_negative_Z(is_negative_X), .is_negative_T(is_negative_X)
);

endmodule