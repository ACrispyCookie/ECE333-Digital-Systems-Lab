module uart_connector(clk, reset, baud_select, tx_en, tx_wr, rx_en, tx_data, tx_busy, rx_valid, rx_ferror, rx_perror, rx_end, rx_data);
    input clk, reset, tx_en, tx_wr, rx_en;
    input [7:0] tx_data;
    input [3:0] baud_select;
    output wire [7:0] rx_data;
    output wire tx_busy, rx_valid, rx_ferror, rx_perror, rx_end;

    uart_transmitter uart_transmitter_inst(.clk(clk), .reset(reset), .tx_data(tx_data), .baud_select(baud_select), .tx_en(tx_en), .tx_wr(tx_wr), .txD(bus), .tx_busy(tx_busy));
    uart_receiver uart_receiver_inst(.clk(clk), .reset(reset), .rx_data(rx_data), .baud_select(baud_select), .rx_en(rx_en), .rxD(bus), .rx_valid(rx_valid), .rx_ferror(rx_ferror), .rx_perror(rx_perror), .rx_end(rx_end));

endmodule