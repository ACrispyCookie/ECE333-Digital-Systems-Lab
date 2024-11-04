module uart_tb;
    reg clk, reset;
    reg [3:0] baud_select;
    reg tx_en, rx_en;

    uart_connector uart_connector_inst(.clk(clk), .reset(reset), .baud_select(baud_select), .tx_en(tx_en), .rx_en(rx_en));

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        rx_en = 1'b0;
        tx_en = 1'b0;
        baud_select = 3'b0;
        #200 reset = 1'b1;
        #200 reset = 1'b0;
        baud_select = 3'b111;
        rx_en = 1'b1;
        tx_en = 1'b1;
    end

    always begin
        #5 clk = ~clk;
    end
endmodule