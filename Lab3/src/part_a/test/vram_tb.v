module vram_tb;
    reg clk, reset;
    reg [13:0] address;
    wire [15:0] red, green, blue;

    vram vram_inst(.clk(clk), .reset(reset), .read_address(address), .r(red), .g(green), .b(blue));

    initial begin
        clk = 1'b0;
        address = 14'b0;
        reset = 1'b0;
        #300 reset = 1'b1;
        #300 reset = 1'b0;
        #200 address = 14'd16;
        #10000 $finish;
    end

    always begin
        #5 clk = ~clk;
    end

endmodule