`timescale 1ns/10ps
module LEDdecoder_tb;
    reg [5:0] char;
    wire [6:0] LED;
    wire CA = LED[6], CB = LED[5], CC = LED[4], CD = LED[3], CE = LED[2], CF = LED[1], CG = LED[0];

    LEDdecoder decoder(char, LED);
    reg [31:0] successDisplay = "PASS";
    wire [615:0] display = {" ", !CA ? "aaaa" : "    ", " \n", 
    !CF ? "f" : " ", "    ", !CB ? "b" : " ", "\n",
    !CF ? "f" : " ", "    ", !CB ? "b" : " ", "\n",
    !CF ? "f" : " ", "    ", !CB ? "b" : " ", "\n",
    !CF ? "f" : " ", "    ", !CB ? "b" : " ", "\n",
    " ", !CG ? "gggg" : "    ", " \n",
    !CE ? "e" : " ", "    ", !CC ? "c" : " ", "\n",
    !CE ? "e" : " ", "    ", !CC ? "c" : " ", "\n",
    !CE ? "e" : " ", "    ", !CC ? "c" : " ", "\n",
    !CE ? "e" : " ", "    ", !CC ? "c" : " ", "\n",
    " ", !CD ? "dddd" : "    ", " \n"};

    initial begin
        $dumpfile("LEDdecoder_tb.vcd");
        $dumpvars(0, LEDdecoder_tb);
        $monitor("time = %t, char = %d, LED = %b, success = %s, display = \n%s", $time, char, LED, successDisplay, display);
        char = 6'd0;
        #1 if (LED == 7'b0000001) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd1;
        #1 if (LED == 7'b1001111) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd2;
        #1 if (LED == 7'b0010010) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd3;
        #1 if (LED == 7'b0000110) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd4;
        #1 if (LED == 7'b1001100) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd5;
        #1 if (LED == 7'b0100100) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd6;
        #1 if (LED == 7'b0100000) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd7;
        #1 if (LED == 7'b0001111) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd8;
        #1 if (LED == 7'b0000000) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd9;
        #1 if (LED == 7'b0000100) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd10;
        #1 if (LED == 7'b1111111) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd11;
        #1 if (LED == 7'b0001000) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd12;
        #1 if (LED == 7'b0110001) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd13;
        #1 if (LED == 7'b0000011) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd14;
        #1 if (LED == 7'b0110000) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd15;
        #1 if (LED == 7'b0111000) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd16;
        #1 if (LED == 7'b0100001) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd17;
        #1 if (LED == 7'b1001000) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd18;
        #1 if (LED == 7'b1111001) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd19;
        #1 if (LED == 7'b1000011) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd20;
        #1 if (LED == 7'b0101000) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd21;
        #1 if (LED == 7'b1110001) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd22;
        #1 if (LED == 7'b0010101) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd23;
        #1 if (LED == 7'b0001001) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd24;
        #1 if (LED == 7'b0011000) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd25;
        #1 if (LED == 7'b0010100) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd26;
        #1 if (LED == 7'b0010000) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd27;
        #1 if (LED == 7'b0111001) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd28;
        #1 if (LED == 7'b1000001) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd29;
        #1 if (LED == 7'b1000101) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd30;
        #1 if (LED == 7'b0100011) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd31;
        #1 if (LED == 7'b0110110) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 char = 6'd32;
        #1 if (LED == 7'b1010100) successDisplay = "PASS";
        else successDisplay = "FAIL";
        #10 $finish;
    end


endmodule