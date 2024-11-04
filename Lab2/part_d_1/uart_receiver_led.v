module uart_receiver_led(clk, reset, baud_select, rx_en, rxD, rx_valid, rx_ferror, rx_perror, rx_end, rx_end_pulse, rx_data);
    input clk, reset, rx_en, rxD;
    input [3:0] baud_select;
    output wire [7:0] rx_data;
    output wire rx_valid, rx_ferror, rx_perror, rx_end,rx_end_pulse;

    reg [7:0] messages [3:0];
    reg [2:0] message_counter;

    uart_receiver uart_receiver_inst(.clk(clk), .reset(reset), .rx_data(rx_data), .baud_select(baud_select), .rx_en(rx_en), .rxD(rxD), 
    .rx_valid(rx_valid), .rx_ferror(rx_ferror), .rx_perror(rx_perror), .rx_end(rx_end), .rx_end_pulse(rx_end_pulse));
    FourDigitLEDdriver led_driver(.clk(clk), .reset(reset), .char0(messages[0]), .char1(messages[1]), .char2(messages[2]), .char3(messages[3]));

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            messages[0] <= 8'b00000000;
            messages[1] <= 8'b00000000;
            messages[2] <= 8'b00000000;
            messages[3] <= 8'b00000000;
        end else if (rx_end_pulse) begin
            messages[message_counter] <= rx_data;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            message_counter <= 3'b0;
        end else if (rx_end_pulse) begin
            message_counter <= message_counter + 3'b1;
        end
    end

endmodule