`timescale 1ns / 10ps
module uart_transmitter_tb;
    reg clk, reset;
    reg tx_en, tx_wr;
    reg [7:0] tx_data;
    wire txD, tx_busy;
    wire [2:0] baud_select = 3'b110;
    parameter data = 8'b10101010;

    uart_transmitter uart_transmitter_inst(.clk(clk), .reset(reset), .baud_select(baud_select),
    .tx_en(tx_en), .tx_wr(tx_wr), .tx_data(tx_data), .txD(txD), .tx_busy(tx_busy));

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        tx_en = 1'b0;
        tx_wr = 1'b0;
        tx_data = 8'b00000000;
        #200 reset = 1'b0;
        tx_en = 1'b1;
        tx_data = data;
        #200 tx_wr = 1'b1;
        #10 tx_wr = 1'b0;
        #100000 tx_wr = 1'b1;
        #10 tx_wr = 1'b0;
        #300000 $finish;
    end

    always begin
        #5 clk = ~clk;
    end

endmodule