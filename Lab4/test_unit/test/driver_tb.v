`timescale 1ns/10ps
module driver_tb;
reg clk, reset;
reg simple_mode, no_avg, binary_select, x_sel, y_sel, z_sel, t_sel, use_burst;

wire slave_ready;
wire [7:0] slave_received;
wire mosi, miso, sclk, ss;
wire TxD;

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

accelerometer_driver accelerometer_driver_inst(.clk(clk), .debounced_reset(reset), .miso(miso), .TxD(TxD), .mosi(mosi), .sclk(sclk), .ss(ss), .an7(an7), .an6(an6), .an5(an5), .an4(an4),
.an3(an3), .an2(an2), .an1(an1), .an0(an0), .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .dp(dp), .simple_mode(simple_mode), .no_avg(no_avg), .binary_select(binary_select), .x_sel(x_sel), .y_sel(y_sel), .z_sel(z_sel), .use_burst(use_burst));

spi_slave spi_slave_inst(.clk(sclk), .reset(reset), .ss(ss), .ready(slave_ready), .received_data(slave_received), .mosi(mosi), .miso(miso));

initial begin
    clk = 1'b0;
    reset = 1'b0;
    simple_mode = 1'b0;
    no_avg = 1'b1;
    binary_select = 1'b0;
    x_sel = 1'b0;
    y_sel = 1'b0;
    z_sel = 1'b0;
    t_sel = 1'b0;
    use_burst = 1'b1;
    #300 reset = 1'b1;
    #100 reset = 1'b0;
end

endmodule