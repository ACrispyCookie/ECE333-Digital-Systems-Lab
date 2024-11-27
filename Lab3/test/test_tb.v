`timescale 1ns/1ns
module test_tb;
    reg clk, reset;
    wire [15:0] out;
    reg write_enable;
    reg [13:0] read_address, write_address;
    reg write_data;

    localparam CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) clk=~clk;

    vram vram_inst(.clk(clk), .reset(reset), .read_address(read_address), .out(out));

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        read_address = 14'd0;
        write_enable = 1'b0;
        write_address = 14'd17;
        write_data = 1'b1;
        #300 reset = 1'b1;
        #300 reset = 1'b0;
        #100 write_enable = 1'b1;
        #100 write_enable = 1'b0;
        #100 read_address = 14'd1;
        #100 read_address = 14'd2;
        #100 read_address = 14'd3;
        #100 read_address = 14'd4;
        #100 read_address = 14'd5;
        #100 read_address = 14'd6;
        #100 read_address = 14'd7;
        #100 read_address = 14'd8;
        #100 read_address = 14'd9;
        #100 read_address = 14'd10;
        #100 read_address = 14'd11;
        #100 read_address = 14'd12;
        #100 read_address = 14'd13;
        #100 read_address = 14'd14;
        #100 read_address = 14'd15;
        #100 read_address = 14'd16;
        #100 read_address = 14'd17;
        #100 read_address = 14'd18;
        #100 read_address = 14'd19;
        #100 read_address = 14'd20;
        #100 read_address = 14'd21;
        #100 read_address = 14'd22;
        #100 read_address = 14'd23;
        #100 read_address = 14'd24;
        #100 read_address = 14'd25;
        #100 read_address = 14'd26;
        #100 read_address = 14'd27;
        #100 read_address = 14'd28;
        #100 read_address = 14'd29;
        #100 read_address = 14'd30;
        #100 read_address = 14'd31;
        #100 read_address = 14'd32;
    end

endmodule