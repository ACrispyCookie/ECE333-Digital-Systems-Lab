module uart_controller(clk, reset, baud_select, tx_en, tx_wr, rx_en, rx_valid, tx_end, errorred, message_0, message_1, message_2, message_3);
    input clk, reset, tx_wr, rx_en, tx_en;
    input [2:0] baud_select;
    output wire [7:0] message_0, message_1, message_2, message_3; 
    output errorred, tx_end, rx_valid;

    wire [2:0] baud_select_db;
    wire rx_ferror, rx_perror, rx_valid, tx_busy, errorred, tx_end, tx_busy_pulse;
    wire [1:0] tx_address, rx_address;
    wire [7:0] tx_data, rx_data;
    assign errorred = rx_ferror || rx_perror;
    assign tx_end = tx_address == 2'b11 && !tx_busy_pulse;

    //Debouncers
    ResetDebouncer reset_debouncer(.clk(clk), .input_bounce(reset), .debounced(reset_sync));
    InputDebouncer input_debouncer_baud_2(.clk(clk), .reset(reset_sync), .input_bounce(baud_select[2]), .debounced(baud_select_db[2]));
    InputDebouncer input_debouncer_baud_1(.clk(clk), .reset(reset_sync), .input_bounce(baud_select[1]), .debounced(baud_select_db[1]));
    InputDebouncer input_debouncer_baud_0(.clk(clk), .reset(reset_sync), .input_bounce(baud_select[0]), .debounced(baud_select_db[0]));
    InputDebouncer input_debouncer_tw_wr(.clk(clk), .reset(reset_sync), .input_bounce(tx_wr), .posedge_pulse(tx_wr_pulse));

    //Transmitter and receiver memories
    message_counter transmitter_message_counter(.clk(clk), .reset(reset), .enable(tx_en), .next(~tx_busy), .current_message(tx_address), .next_pulse(tx_busy_pulse));
    transmitter_memory transmitter_memory_inst(.clk(clk), .reset(reset), .address(tx_address), .data(tx_data));
    message_counter receiver_message_counter(.clk(clk), .reset(reset), .enable(rx_en), .next(rx_valid), .current_message(rx_address), .next_pulse(rx_valid_pulse));
    receiver_memory receiver_memory_inst(.clk(clk), .reset(reset), .address(rx_address), .write(rx_valid_pulse), .data_in(rx_data), .data_out_0(message_0), .data_out_1(message_1)
    , .data_out_2(message_2), .data_out_3(message_3));

    uart_transmitter uart_transmitter_inst(.clk(clk), .reset(reset), .baud_select(baud_select), .tx_data(tx_data), .tx_en(tx_en), .tx_wr(tx_wr), .txD(bus), .tx_busy(tx_busy));
    uart_receiver uart_receiver_inst(.clk(clk), .reset(reset), .baud_select(baud_select), .rx_en(rx_en), .rxD(bus), .rx_data(rx_data), .rx_valid(rx_valid), .rx_ferror(rx_ferror), .rx_perror(rx_perror));

endmodule