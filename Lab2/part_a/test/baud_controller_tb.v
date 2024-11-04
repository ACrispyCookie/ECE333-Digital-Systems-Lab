`timescale 1ns / 10ps
module baud_controller_tb;
    reg clk, reset;
    reg [2:0] baud_select;
    wire enable;

    baud_controller controller_inst(.clk(clk), .reset(reset), .baud_select(baud_select), .enable_sample(enable));
    
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        baud_select = 3'b111;
        #20 reset = 1'b0;
        #3000 $finish;
    end

    always begin
        #5 clk = ~clk;
    end
endmodule