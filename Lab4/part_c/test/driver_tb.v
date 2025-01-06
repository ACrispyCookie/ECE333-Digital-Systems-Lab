`timescale 1ns/10ps
module driver_tb;
    reg clk, reset, miso;
    wire [7:0] id, id2;
    wire id_ready, sclk;

    localparam CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) clk=~clk;

    adxl362_driver adxl362_driver_inst(.clk(clk), .reset(reset), .sclk(sclk), .miso(miso), .id(id), .id2(id2), .raw_values_ready(id_ready));

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        miso = 1'b1;
        #300 reset = 1'b1;
        #100 reset = 1'b0;
    end

endmodule