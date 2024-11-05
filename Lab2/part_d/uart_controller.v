module uart_connector(clk, reset, baud_select, tx_en, tx_wr, rx_en, errorred, message_0, message_1, message_2, message_3);
    input clk, reset, tx_en, tx_wr, rx_en;
    input [2:0] baud_select;
    output wire [7:0] message_0, message_1, message_2, message_3; 
    output errorred;

    wire rx_ferror, rx_perror, rx_valid, tx_busy;
    wire errorred = rx_ferror || rx_perror;
    wire [1:0] tx_address, rx_address;
    wire [7:0] tx_data, rx_data;

    message_counter transmitter_message_counter(.clk(clk), .reset(reset), .enable(tx_en), .next(~tx_busy), .current_message(tx_address), .next_pulse(tx_busy_pulse));
    transmitter_memory transmitter_memory_inst(.clk(clk), .reset(reset), .address(tx_address), .data(tx_data));
    message_counter receiver_message_counter(.clk(clk), .reset(reset), .enable(rx_en), .next(rx_valid), .current_message(rx_address), .next_pulse(rx_valid_pulse));
    receiver_memory receiver_memory_inst(.clk(clk), .reset(reset), .address(rx_address), .write(rx_valid_pulse), .data_in(rx_data), .data_out_0(message_0), .data_out_1(message_1)
    , .data_out_2(message_2), .data_out_3(message_3));

    uart_transmitter uart_transmitter_inst(.clk(clk), .reset(reset), .baud_select(baud_select), .tx_data(tx_data), .tx_en(tx_en), .tx_wr(tx_wr), .txD(bus), .tx_busy(tx_busy));
    uart_receiver uart_receiver_inst(.clk(clk), .reset(reset), .baud_select(baud_select), .rx_en(rx_en), .rxD(bus), .rx_data(rx_data), .rx_valid(rx_valid), .rx_ferror(rx_ferror), .rx_perror(rx_perror));

endmodule