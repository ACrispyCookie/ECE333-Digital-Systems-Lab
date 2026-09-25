`timescale 1ns / 10ps
module uart_receiver_tb;
    reg clk, reset;
    reg rx_en, rxD;
    wire [7:0] rx_data;
    wire [2:0] baud_select = 3'b111;
    wire rx_valid, rx_ferror, rx_perror;

    uart_receiver uart_receiver_inst(.clk(clk), .reset(reset), .baud_select(baud_select),
    .rx_en(rx_en), .rx_data(rx_data), .rxD(rxD), .rx_valid(rx_valid), .rx_ferror(rx_ferror), .rx_perror(rx_perror));

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        rx_en = 1'b0;
        rxD = 1'b1;
        #200 reset = 1'b0;
        rx_en = 1'b1;
        #100 rxD = 1'b0;
        #8800 rxD = 1'b1;
        #8800 rxD = 1'b0;
        #8800 rxD = 1'b1;
        #8800 rxD = 1'b0;
        #8800 rxD = 1'b1;
        #8800 rxD = 1'b0;
        #8800 rxD = 1'b1;
        #8800 rxD = 1'b0;
        #8800 rxD = 1'b1;
        #8800 rxD = 1'b1;
        #600000 $finish;
    end

    always begin
        #5 clk = ~clk;
    end

endmodule