`timescale 1ns/10ps
module tb_part_a;
    reg clk, reset;

    localparam CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) clk=~clk;

    initial begin
        
    end

endmodule