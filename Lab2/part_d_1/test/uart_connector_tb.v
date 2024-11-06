`timescale 1ns/10ps
module uart_connector_tb;
    reg clk, reset;
    reg tx_wr, tx_en, rx_en;
    wire an0, an1, an2, an3, a, b, c, d, e, f, g, dp;
    wire [3:0] baud_select;
    assign baud_select = 3'b111;
    
    uart_connector uart_connector_inst(.clk(clk), .reset(reset), .baud_select(baud_select), .tx_wr(tx_wr), .tx_en(tx_en), .rx_en(rx_en),
    .an0(an0), .an1(an1), .an2(an2), .an3(an3), .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp));

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        tx_wr = 1'b0;
        tx_en = 1'b1;
        rx_en = 1'b1;
        #400 reset = 1'b1;
        #1500000 reset = 1'b0;
        #400 tx_wr = 1'b1;
        #1500000 tx_wr = 1'b0;
        #400 tx_wr = 1'b1;
        #1500000 tx_wr = 1'b0;
        #400 tx_wr = 1'b1;
        #1500000 tx_wr = 1'b0;
        #400 tx_wr = 1'b1;
        #1500000 tx_wr = 1'b0;
    end

    always begin
        #5 clk = ~clk;
    end

endmodule