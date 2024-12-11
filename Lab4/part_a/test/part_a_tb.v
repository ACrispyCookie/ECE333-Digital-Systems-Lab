`timescale 1ns/10ps
module tb_part_a;
    reg clk, reset, start_X;

    localparam CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) clk=~clk;

    accelerometer_driver accelerometer_driver_inst(.clk(clk), .reset(reset), .TxD(TxD), .start_X(start_X));

    initial begin
        clk = 0;
        reset = 0;
        start_X = 0;
        #300 reset = 1'b1;
        #100 reset = 1'b0;
        #100 start_X = 1'b1;
        #10 start_X = 1'b0;
    end

endmodule