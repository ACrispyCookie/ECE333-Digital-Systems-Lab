module uart_connector(clk, reset, baud_select, tx_en, rx_en);
    input clk, reset, tx_en, rx_en;
    input [3:0] baud_select;
    wire rx_valid, rx_ferror, rx_perror, rx_end, rx_end_pulse;
    wire [7:0] rx_data;

    uart_transmitter_led uart_transmitter_inst(.clk(clk), .reset(reset), .baud_select(baud_select), .tx_en(tx_en), .txD(bus), .tx_busy(tx_busy));
    uart_receiver_led uart_receiver_inst(.clk(clk), .reset(reset), .baud_select(baud_select), .rx_en(rx_en), .rxD(bus), .rx_valid(rx_valid),
    .rx_ferror(rx_ferror), .rx_perror(rx_perror), .rx_end(rx_end), .rx_end_pulse(rx_end_pulse), .rx_data(rx_data));

endmodule