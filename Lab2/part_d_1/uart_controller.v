module uart_connector(clk, reset, baud_select, tx_wr, tx_en, rx_en, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);
    input clk, reset, tx_wr, rx_en, tx_en;
    input [2:0] baud_select;
    output wire an3, an2, an1, an0, a, b, c, d, e, f, g, dp;
    
    wire [2:0] baud_select_db;
    wire [7:0] message_0, message_1, message_2, message_3; 
    wire rx_ferror, rx_perror, rx_valid, tx_busy, errorred;
    wire [1:0] tx_address, rx_address;
    wire [7:0] tx_data, rx_data;
    assign errorred = rx_ferror || rx_perror;

    ResetDebouncer reset_debouncer(.clk(clk), .input_bounce(reset), .debounced(reset_sync));
    InputDebouncer input_debouncer_baud_2(.clk(clk), .reset(reset_sync), .input_bounce(baud_select[2]), .debounced(baud_select_db[2]));
    InputDebouncer input_debouncer_baud_1(.clk(clk), .reset(reset_sync), .input_bounce(baud_select[1]), .debounced(baud_select_db[1]));
    InputDebouncer input_debouncer_baud_0(.clk(clk), .reset(reset_sync), .input_bounce(baud_select[0]), .debounced(baud_select_db[0]));
    InputDebouncer input_debouncer_tw_wr(.clk(clk), .reset(reset_sync), .input_bounce(tx_wr), .posedge_pulse(tx_wr_pulse));

    message_counter transmitter_message_counter(.clk(clk), .reset(reset_sync), .enable(tx_en), .next(~tx_busy), .current_message(tx_address));
    transmitter_memory transmitter_memory_inst(.clk(clk), .reset(reset_sync), .address(tx_address), .data(tx_data));
    message_counter receiver_message_counter(.clk(clk), .reset(reset_sync), .enable(rx_en), .next(rx_valid), .current_message(rx_address), .next_pulse(rx_valid_pulse));
    receiver_memory receiver_memory_inst(.clk(clk), .reset(reset_sync), .address(rx_address), .write(rx_valid_pulse), .data_in(rx_data), .data_out_0(message_0), .data_out_1(message_1)
    , .data_out_2(message_2), .data_out_3(message_3));

    uart_transmitter uart_transmitter_inst(.clk(clk), .reset(reset_sync), .baud_select(baud_select_db), .tx_data(tx_data), .tx_en(tx_en), .tx_wr(tx_wr_pulse), .txD(bus), .tx_busy(tx_busy));
    uart_receiver uart_receiver_inst(.clk(clk), .reset(reset_sync), .baud_select(baud_select_db), .rx_en(rx_en), .rxD(bus), .rx_data(rx_data), .rx_valid(rx_valid), .rx_ferror(rx_ferror), .rx_perror(rx_perror));
    FourDigitLEDdriver led_driver_inst(.clk(clk), .reset(reset_sync), .char3(message_3[5:0]), .char2(message_2[5:0]), .char1(message_1[5:0]), .char0(message_0[5:0]), .an3(an3), .an2(an2), .an1(an1), .an0(an0), 
    .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));

endmodule