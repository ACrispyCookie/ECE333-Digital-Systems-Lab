`timescale 1ns/10ps
/* 
Tests the functionality of the binary_to_ascii_4 module
and the uart_transmitter_data_control module by sending a 12-bit binary number
to the binary_to_ascii_4 module and then transmitting the ASCII characters
*/
module part_a_tb;
    reg clk, reset;
    reg start;
    reg [11:0] binary;
    wire TxD;

    localparam CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) clk=~clk;

    uart_test uart_inst(clk, reset, start, binary, TxD);

    initial begin
        clk = 0;
        reset = 0;
        start = 1'b0;
        #300 reset = 1'b1;
        #100 reset = 1'b0;
        binary = 12'b1011_1000_0011;
        start = 1'b1;
    end

endmodule