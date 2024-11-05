`timescale 1ns/10ps
module uart_connector_tb;
    reg clk, reset;
    reg tx_en, rx_en, tx_wr;
    wire [7:0] message_0, message_1, message_2, message_3;
    wire errorred;
    wire [3:0] baud_select = 3'b111;
    
    uart_connector uart_connector_inst(.clk(clk), .reset(reset), .baud_select(baud_select), .tx_en(tx_en), .rx_en(rx_en), .tx_wr(tx_wr),
    .errorred(errorred), .message_0(message_0), .message_1(message_1), .message_2(message_2), .message_3(message_3));

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        tx_en = 1'b1;
        rx_en = 1'b1;
        tx_wr = 1'b0;
        #300 reset = 1'b1;
        #300 reset = 1'b0;
        #10 tx_wr = 1'b1;
        #10 tx_wr = 1'b0;
        #100000 tx_wr = 1'b1;
        #10 tx_wr = 1'b0;
        #100000 tx_wr = 1'b1;
        #10 tx_wr = 1'b0;
        #100000 tx_wr = 1'b1;
        #10 tx_wr = 1'b0;
    end

    always begin
        #5 clk = ~clk;
    end

endmodule