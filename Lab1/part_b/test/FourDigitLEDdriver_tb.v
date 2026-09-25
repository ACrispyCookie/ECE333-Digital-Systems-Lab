`timescale 1ns / 10ps
module FourDigitLEDdriver_tb;
    reg clk, reset;
    wire [3:0] AN;
    wire CA, CB, CC, CD, CE, CF, CG, dp;

    FourDigitLEDdriver driver(.clk(clk), .reset(reset), .an3(AN[3]), .an2(AN[2]), .an1(AN[1]), .an0(AN[0]), 
    .a(CA), .b(CB), .c(CC), .d(CD), .e(CE), .f(CF), .g(CG), .dp(dp));

    initial begin
        clk = 1'b0;
        #10 reset = 1'b1;
        #20000 reset = 1'b0;
        #500000 $finish;
    end

    always begin
        #5 clk = ~clk;
    end
endmodule