module led_uart_connector(clk, reset, baud_select, tx_wr, tx_en, rx_en, errorred, rx_valid, tx_end, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);
    input clk, reset, tx_wr, rx_en, tx_en;
    input [2:0] baud_select;
    output wire an3, an2, an1, an0, a, b, c, d, e, f, g, dp;
    output wire errorred, rx_valid, tx_end;
    
    wire [7:0] message_0, message_1, message_2, message_3;

    uart_controller uart_controller_inst(.clk(clk), .reset(reset), .baud_select(baud_select), .tx_en(tx_en), .tx_wr(tx_wr), .rx_en(rx_en), .errorred(errorred), .rx_valid(rx_valid), .tx_end(tx_end),
    .message_0(message_0), .message_1(message_1), .message_2(message_2), .message_3(message_3));
    FourDigitLEDdriver led_driver_inst(.clk(clk), .reset(reset), .char3(message_3[5:0]), .char2(message_2[5:0]), .char1(message_1[5:0]), .char0(message_0[5:0]), .an3(an3), .an2(an2), .an1(an1), .an0(an0), 
    .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));
endmodule