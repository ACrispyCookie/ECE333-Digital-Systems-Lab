`timescale 1ns / 10ps
module avg_tb;
reg clk, reset;
reg signed [11:0] x_binary, y_binary, z_binary;
reg signed [18:0] t_binary;
reg copy_values;
wire signed [11:0] x_avg, y_avg, z_avg;
wire signed [18:0] t_avg;
wire ready;

avg_calc uut (
    .clk(clk),
    .reset(reset),
    .x_binary(x_binary),
    .y_binary(y_binary),
    .z_binary(z_binary),
    .t_binary(t_binary),
    .x_avg(x_avg),
    .y_avg(y_avg),
    .z_avg(z_avg),
    .t_avg(t_avg),
    .copy_values(copy_values),
    .ready(ready)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    clk = 1'b0;
    reset = 1'b0;
    x_binary = 12'b0;
    y_binary = 12'b0;
    z_binary = 12'b0;
    t_binary = 19'b0;
    copy_values = 1'b0;
    #300 reset = 1'b1;
    #100 reset = 1'b0;
    #100 copy_values = 1'b1;
end

always begin
    #10 x_binary = 12'd2000;
    y_binary = 12'd0200;
    z_binary = 12'd1200;
    t_binary = -19'd50000;
    #10 x_binary = 12'd1000;
    y_binary = 12'd0400;
    z_binary = 12'd2000;
    t_binary = 19'd25000;
end

endmodule