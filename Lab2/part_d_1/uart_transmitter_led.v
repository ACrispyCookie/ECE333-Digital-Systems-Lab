module uart_transmitter_led(clk, reset, baud_select, tx_en, txD, tx_busy);
    input clk, reset, tx_en, txD;
    input [3:0] baud_select;
    output wire tx_busy;
    
    reg [7:0] messages [3:0];
    reg [2:0] message_counter;
    reg tx_wr;

    wire [7:0] tx_data = messages[message_counter - 1];

    uart_transmitter uart_transmitter_inst(.clk(clk), .reset(reset), .tx_data(tx_data), .baud_select(baud_select), .tx_en(tx_en), .tx_wr(tx_wr), .txD(txD), .tx_busy(tx_busy));

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            messages[0] <= 7'd19;
            messages[1] <= 7'd5;
            messages[2] <= 7'd0;
            messages[3] <= 7'd23;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            message_counter <= 3'b0;
        end else if (tx_en && ~tx_busy && ~tx_wr && message_counter < 3'd4) begin
            message_counter <= message_counter + 3'b1;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset || message_counter == 3'b100) begin
            tx_wr <= 1'b0;
        end else if (tx_en && ~tx_busy && ~tx_wr) begin
            tx_wr <= 1'b1;
        end else begin
            tx_wr <= 1'b0;
        end
    end

endmodule