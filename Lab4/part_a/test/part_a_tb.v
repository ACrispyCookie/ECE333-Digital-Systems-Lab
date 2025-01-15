`timescale 1ns/10ps
module tb_part_a;
    reg clk, reset;
    reg start;
    reg [11:0] binary;
    wire [7:0] ascii_1, ascii_2, ascii_3, ascii_4;
    wire ready, is_negative;

    localparam CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) clk=~clk;

    binary_to_ascii_4 inst(.clk(clk), .reset(reset), 
                            .binary(binary), .start(start), 
                            .ascii_1(ascii_1), .ascii_2(ascii_2), 
                            .ascii_3(ascii_3), .ascii_4(ascii_4), 
                            .ready(ready), .is_negative(is_negative));

    initial begin
        clk = 0;
        reset = 0;
        start = 1'b0;
        #300 reset = 1'b1;
        #100 reset = 1'b0;
        binary = 12'b011101111111;
    end

endmodule