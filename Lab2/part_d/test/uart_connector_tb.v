`timescale 1ns/10ps
module uart_connector_tb;
    reg clk, reset;
    reg [7:0] messages [3:0];
    reg [7:0] received [3:0];
    reg [2:0] message_counter;
    reg [7:0] tx_data;
    reg tx_en, rx_en, tx_wr;
    wire tx_busy, rx_valid, rx_ferror, rx_perror, rx_end, rx_end_pulse;
    wire [7:0] rx_data;
    wire [3:0] baud_select = 3'b111;
    
    uart_connector uart_connector_inst(.clk(clk), .reset(reset), .baud_select(baud_select), .tx_en(tx_en), .rx_en(rx_en), .tx_wr(tx_wr),
    .tx_data(tx_data), .tx_busy(tx_busy), .rx_data(rx_data), .rx_valid(rx_valid), .rx_ferror(rx_ferror), .rx_perror(rx_perror), .rx_end(rx_end), .rx_end_pulse(rx_end_pulse));

    initial begin
        messages[0] <= 8'haa;
        messages[1] <= 8'h55;
        messages[2] <= 8'hcc;
        messages[3] <= 8'h89;
    end

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        tx_en = 1'b1;
        rx_en = 1'b1;
        #300 reset = 1'b1;
        #300 reset = 1'b0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            received[0] <= 8'b0;
            received[1] <= 8'b0;
            received[2] <= 8'b0;
            received[3] <= 8'b0;
        end else if (rx_end) begin
            received[message_counter - 1] <= rx_data; 
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx_data <= messages[0];
            tx_wr <= 1'b0;
        end else if (tx_wr == 1'b0 && tx_busy == 1'b0 && message_counter != 3'b100) begin
            tx_data <= messages[message_counter];
            tx_wr <= 1'b1;
        end else begin
            tx_wr <= 1'b0;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            message_counter <= 3'b000;
        end else if (tx_wr == 1'b1) begin 
            message_counter <= message_counter + 3'b001;
        end
    end

    always begin
        #5 clk = ~clk;
    end

endmodule